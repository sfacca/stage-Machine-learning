### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ f5031280-600e-11eb-3799-015a8792ae63
using Pkg

# ╔═╡ 90e5cff0-6012-11eb-3182-ef1e1f802343
using Catlab, Catlab.CategoricalAlgebra, DataFrames

# ╔═╡ f4e1c610-6096-11eb-0a8c-6f0ffcc97f6b
using Tokenize

# ╔═╡ 45fa2930-6181-11eb-22b0-6d76ebff6633
using CSTParser

# ╔═╡ a721c7e2-617c-11eb-325f-a58b3c82471e
using Catlab.Graphics

# ╔═╡ b9cf6ec0-600e-11eb-25d0-93643031c456
include("scrape.jl")

# ╔═╡ f0743ec0-6012-11eb-154a-e9a8eff08ce7
include("parse_folder.jl")

# ╔═╡ f4d99180-600e-11eb-3053-2f2814838927
Pkg.activate(".")

# ╔═╡ dafd3880-619d-11eb-24b8-ebd69e0320cf
function folder_to_CSet(path::String)
	
	println("#### parsing folder #####")
	raw_parse = read_code(path)
	
	
	println("#### scraping parsed #####")	
	parsed = []
	for i in 1:length(raw_parse)
		try
			tmp = scrape_expr(raw_parse[i][1])
			parsed = vcat(parsed, [(scrape = tmp[x], source= raw_parse[i][2]) for x in 1:length(tmp)])
		catch e
			println("SCRAPE ERROR: $e")
			println("SCRAPING EXPRESSION: $(raw_parse[i][1])")
		end
	end
	
	println("#### selecting functions #####")
	functions = filter(
	(x)->(x.scrape.type == :function), parsed
)
	println("functions number: $(length(functions))")
	
	println("#### creating arrays #####")
	docs = [x.scrape.docs for x in functions]
	names = [x.scrape.content.name for x in functions]
	inputs = [x.scrape.content.input_variables for x in functions]
	sources = [x.source for x in functions]
	raws = [x.scrape.raw for x in functions]
	ls = [x.scrape.leaves for x in functions]
	df = DataFrame(name= names, doc = docs, inputs = inputs, source = sources, exprs = ls, raw = raws);
	
	println("#### creating schema #####")
	@present functionSchema(FreeSchema) begin
		(Function, Implementation, Inputs)::Ob
		(setImpl, setInp, setExpr)::Data
		(docs, name)::Data	

		in_expr::Attr(Inputs, setExpr)# ogni input è un expr

		impl_in::Hom(Implementation, Inputs)# ogni implem ha degli input	
		impl_fun::Hom(Implementation, Function)# ogni impl implementa una funzione
		impl_expr::Attr(Implementation, setExpr)#ogni impl è composta da expr


		# link objects to their actual data
		impl_set::Attr(Implementation, setImpl)
		in_set::Attr(Inputs, setInp)

		# more attributes
		func_name::Attr(Function, name)
		impl_docs::Attr(Implementation, docs)

	end
	
	println("#### declaring schema, data #####")
	parsedData = ACSetType(functionSchema, index=[:impl_fun])
	data = parsedData{Any, Any, Any, Union{String,Nothing}, Union{String,Nothing}}()
	
	impl_names = df.name;
	println("#### initializing #####")
	impls = add_parts!(data, :Implementation, length(impl_names))
	funs = add_parts!(data, :Function, length(unique(impl_names)))
	inps = add_parts!(data, :Inputs, length(impl_names))
	
	
	
	println("#### handling impl and inp #####")
	# assign function to implementations
	for i in 1:length(impl_names)
		println("loop $i")
	
		println("impl expr")
		data[i, :impl_expr] = df.exprs[i]
		println("impl set")
		data[i, :impl_set] = df.raw[i]
		println("impl docs")
		data[i, :impl_docs] = df.doc[i]	
		println("impl in")
		data[i, :impl_in] = i
		println("impl fun")
		data[i, :impl_fun] = findfirst((x)->(x == impl_names[i]), unique(impl_names))
		# do inputs together since they have same indexing
		println("in set")
		data[i, :in_set] = df.inputs[i]
		println("in expr")
		data[i, :in_expr] = [
			typeof(x) == CSTParser.EXPR ? x : x.type for x in df.inputs[i]
				]
	end
		# do func names
	println("#### handling function #####")
	for i in 1:length(unique(impl_names))
		data[i, :func_name] = unique(impl_names)[i]
	end
	
	println("#### finished #####")
	return (set_type = parsedData, set = data)
end

# ╔═╡ ac07a000-619e-11eb-3633-b7f29d8aee62
parsed , data = folder_to_CSet("programs")

# ╔═╡ f6905300-619f-11eb-353b-85691e354965
data

# ╔═╡ Cell order:
# ╠═f5031280-600e-11eb-3799-015a8792ae63
# ╠═f4d99180-600e-11eb-3053-2f2814838927
# ╠═b9cf6ec0-600e-11eb-25d0-93643031c456
# ╠═f0743ec0-6012-11eb-154a-e9a8eff08ce7
# ╠═90e5cff0-6012-11eb-3182-ef1e1f802343
# ╠═dafd3880-619d-11eb-24b8-ebd69e0320cf
# ╠═ac07a000-619e-11eb-3633-b7f29d8aee62
# ╠═f6905300-619f-11eb-353b-85691e354965
# ╠═f4e1c610-6096-11eb-0a8c-6f0ffcc97f6b
# ╠═45fa2930-6181-11eb-22b0-6d76ebff6633
# ╠═a721c7e2-617c-11eb-325f-a58b3c82471e
