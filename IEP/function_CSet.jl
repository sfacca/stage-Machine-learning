### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ f5031280-600e-11eb-3799-015a8792ae63
using Pkg

# ╔═╡ 6a976fde-624f-11eb-0219-776399a2f5fc
using Match

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

# ╔═╡ 669206b0-626f-11eb-3d06-8f6951f50af8
function _get_types_from_inputs(arr::Array{Array{T,1} where T,1})
	println("start")
	res = Array{Array{Any,1},1}(undef, length(arr))
	println("pre loop")
	for i in 1:length(arr)
		println("loop num $i")
		res[i] = Array{Any,1}(undef, length(arr[i]))
		println("pre inner")
		for j in 1:length(arr[i])
			println("inner $j")
			@match typeof(arr[i][j]) begin				
				CSTParser.EXPR => (res[i][j] = "Any")
				_ => (res[i][j] = arr[i][j].type)
			end
			if isnothing(res[i][j])
				res[i][j] = "Any"
			end			
		end
		res[i] = sort(res[i])
	end
	res
end

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
	calls = [
		filter(!isnothing, [x[1].val for x in i]) for i in [
				find_heads(x.scrape.raw, :call) for x in functions
					]
		]
	for i in 1:length(calls)
		@match length(calls[i]) begin
			0 => (calls[i] = [])
			1 => (calls[i] = [])
			_ => (calls[i] = sort(unique(calls[i][2:end])))
		end
	end
	df = DataFrame(name= names, doc = docs, inputs = inputs, source = sources, exprs = ls, raw = raws, calls = calls);#we dont need this
	
	# 
	
	
	println("")
	
	
	println("#### creating schema #####")
	@present functionSchema(FreeSchema) begin
		(Function, Implementation, Inputs, Calls)::Ob
		(setImpl, setInp, setExpr, setCalls, docs, name
			)::Data	

		impl_in::Hom(Implementation, Inputs)# ogni implem ha degli input	
		impl_fun::Hom(Implementation, Function)# ogni impl implementa una funzione
		impl_expr::Attr(Implementation, setExpr)#ogni impl è composta da expr
		impl_calls::Hom(Implementation, Calls)

		# link objects to their actual data
		impl_set::Attr(Implementation, setImpl)
		in_set::Attr(Inputs, setInp)
		calls_set::Attr(Calls, setCalls)

		# more attributes
		func_name::Attr(Function, name)
		impl_docs::Attr(Implementation, docs)

	end
	
	println("#### declaring schema, data #####")
	parsedData = ACSetType(functionSchema, index=[:impl_fun])
	data = parsedData{Any, Any, Any, Any, Union{String,Nothing}, Union{String,Nothing}}()
	
	impl_names = df.name;
	println("#### initializing #####")
	impls = add_parts!(data, :Implementation, length(impl_names))
	println(impls)
	funs = add_parts!(data, :Function, length(unique(impl_names)))
	println(funs)
	cal = add_parts!(data, :Calls, length(unique(df.calls)))
	println(cal)
	# all inputs
	inputs = _get_types_from_inputs(df.inputs)
	inps = add_parts!(data, :Inputs, length(unique(inputs)))
	
	data[:, :in_set] = unique(inputs)
			# do inputs together since they have same indexing
	println("in expr")
	
	println("handling calls sets")
	#=for i in cal
		println("loop $i")
		
		println("calls set")
		data[i, :calls_set] = unique(df.calls)[i]
	end=#
	data[:, :calls_set] = unique(df.calls)
		
	
	println("#### handling impl and inp #####")
	# assign implementations data
	for i in 1:length(impl_names)
		println("loop $i")
	
		println("impl expr")
		data[i, :impl_expr] = df.exprs[i]
		println("impl set")
		data[i, :impl_set] = df.raw[i]
		println("impl docs")
		data[i, :impl_docs] = df.doc[i]	
		println("impl in")
		data[i, :impl_in] = findfirst((x)->(x == sort(inputs[i])), unique(inputs))
		println("impl fun")
		data[i, :impl_fun] = findfirst((x)->(x == impl_names[i]), unique(impl_names))
		println("impl calls")
		if isnothing(df.calls[i]) || isempty(df.calls[i])
			data[i, :impl_calls] = 0
		else
			asdf = findfirst((x)->( x == df.calls[i]), unique(df.calls))
			data[i, :impl_calls] = findfirst(
				(x)->(x == df.calls[i]), unique(df.calls)
			)
		end
	end
		# do func names
	println("#### handling function #####")
	for i in 1:length(unique(impl_names))
		data[i, :func_name] = unique(impl_names)[i]
	end
	
	println("#### finished #####")
	return (set_type = parsedData, set = data, df = df)
end

# ╔═╡ ac07a000-619e-11eb-3633-b7f29d8aee62
parsed , data, df = folder_to_CSet("programs");

# ╔═╡ 9d8b0ad0-626b-11eb-16cf-a99423ff659c
df.inputs

# ╔═╡ dc900b50-63ff-11eb-3a93-65069f769128
data

# ╔═╡ Cell order:
# ╠═f5031280-600e-11eb-3799-015a8792ae63
# ╠═f4d99180-600e-11eb-3053-2f2814838927
# ╠═b9cf6ec0-600e-11eb-25d0-93643031c456
# ╠═f0743ec0-6012-11eb-154a-e9a8eff08ce7
# ╠═6a976fde-624f-11eb-0219-776399a2f5fc
# ╠═90e5cff0-6012-11eb-3182-ef1e1f802343
# ╠═dafd3880-619d-11eb-24b8-ebd69e0320cf
# ╠═ac07a000-619e-11eb-3633-b7f29d8aee62
# ╠═9d8b0ad0-626b-11eb-16cf-a99423ff659c
# ╠═dc900b50-63ff-11eb-3a93-65069f769128
# ╠═669206b0-626f-11eb-3d06-8f6951f50af8
# ╠═f4e1c610-6096-11eb-0a8c-6f0ffcc97f6b
# ╠═45fa2930-6181-11eb-22b0-6d76ebff6633
# ╠═a721c7e2-617c-11eb-325f-a58b3c82471e
