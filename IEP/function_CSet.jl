### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ f5031280-600e-11eb-3799-015a8792ae63
using Pkg

# ╔═╡ 90e5cff0-6012-11eb-3182-ef1e1f802343
using Catlab, Catlab.CategoricalAlgebra, DataFrames

# ╔═╡ f4e1c610-6096-11eb-0a8c-6f0ffcc97f6b
using Tokenize

# ╔═╡ b9cf6ec0-600e-11eb-25d0-93643031c456
include("scrape.jl")

# ╔═╡ f0743ec0-6012-11eb-154a-e9a8eff08ce7
include("parse_folder.jl")

# ╔═╡ f4d99180-600e-11eb-3053-2f2814838927
Pkg.activate(".")

# ╔═╡ c0c38910-6012-11eb-0000-45b104ddfe5f
#1 get parsed
raw_parse = read_code("programs");

# ╔═╡ 3bad9990-6013-11eb-2151-852ff5553fcf
#2 scrape a few
begin
	parsed = []
	for i in 1:5
		tmp = scrape_expr(raw_parse[i][1])
		parsed = vcat(parsed, [(scrape = tmp[x], source= raw_parse[i][2]) for x in 1:length(tmp)])
		
	end
end

# ╔═╡ c75650e0-6013-11eb-0e27-a13d3d271048
#3 convert to dataframe
begin
	#3.2 remove functions from the rest
	functions = filter(
		(x)->(x.scrape.type == :function), parsed
	)
end

# ╔═╡ 7227baa0-6018-11eb-0dd4-0f104882dedd
begin
	docs = [x.scrape.docs for x in functions]
	names = [x.scrape.content.name for x in functions]
	inputs = [x.scrape.content.input_variables for x in functions]
	sources = [x.source for x in functions]
	raws = [x.scrape.raw for x in functions]
	ls = [x.scrape.leaves for x in functions]
	df = DataFrame(name= names, doc = docs, inputs = inputs, source = sources, exprs = ls, raw = raws)
end

# ╔═╡ 97006fa2-6015-11eb-34ec-3969e1b63b0e
# get the leaves
begin
	leaves = []
	for i in 1:5
		tmp = get_leaves(raw_parse[i][1])
		leaves = vcat(leaves, [(leaves = tmp[x], source= raw_parse[i][2]) for x in 1:length(tmp)])
	end
end

# ╔═╡ 6a2a73a0-6096-11eb-237b-292c40feab88
unique([x[1].val for x in leaves])

# ╔═╡ b4b9db60-60ad-11eb-255c-c9e7bec51fae
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
	

# ╔═╡ 0dcbef90-60b8-11eb-09d6-8bc1176c8f13
const parsedData = ACSetType(functionSchema, index=[:impl_fun])

# ╔═╡ d2368b80-60b1-11eb-2be7-7fe121cd2f66
data = parsedData{Any, Any, Any, Union{String,Nothing}, Union{String,Nothing}}()

# ╔═╡ 53ba7670-60b8-11eb-1407-914724e5b264
impl_names = df.name;

# ╔═╡ c6a6c700-60c3-11eb-02a8-01486e522c30
function_ids = add_parts!(data, :Function, length(unique(impl_names)))

# ╔═╡ ed0474b0-60c8-11eb-1b2c-a50b5fb5f934
implementation_ids = add_parts!(data, :Implementation, length(impl_names))

# ╔═╡ 1d45aa90-60c9-11eb-086c-ad50f90193f7
input_ids = add_parts!(data, :Inputs, length(impl_names))#every implementation has a set of inputs

# ╔═╡ 4d2f4a90-60c9-11eb-164f-8d2339f0ab9a
map(length, tables(data))

# ╔═╡ f5eba970-60ed-11eb-199f-f5c226d89f2e
df.exprs[1]

# ╔═╡ eb41d91e-60f4-11eb-180a-2722748c057c
length(df[!,1])

# ╔═╡ 26d4e980-60ca-11eb-3290-5dfd070dda19
# assign function to implementations
for i in 1:length(impl_names)
	
	fun_index = findfirst((x)->(x == impl_names[i]), unique(impl_names))
	in = incident(data, fun_index, :impl_fun)
	data[i, :impl_expr] = df.exprs[i]
	data[i, :impl_set] = df.raw[i]
	data[i, :impl_docs] = df.doc[i]
	# do inputs together since they have same indexing
	data[i, :in_set] = df.inputs[i]
end

# ╔═╡ a69d8980-60c8-11eb-1961-bdfc4f19f908
#=
for tree in trees
    measurements = incident(sitka, tree, :tree) # Uses `tree` index.
    sitka[tree, :treat] = only(unique(sitka_df.treat[measurements]))
end

withenv("LINES" => 10) do
    foreach(display∘DataFrame, tables(sitka))
end
treat::Attr(Tree, Treatment)
tree::Hom(Measurement, Tree)
=#

# ╔═╡ 37cd2f60-60f5-11eb-085d-55558904af4b
withenv("LINES" => 10) do
    foreach(display∘DataFrame, tables(data))
end

# ╔═╡ Cell order:
# ╠═f5031280-600e-11eb-3799-015a8792ae63
# ╠═f4d99180-600e-11eb-3053-2f2814838927
# ╠═b9cf6ec0-600e-11eb-25d0-93643031c456
# ╠═f0743ec0-6012-11eb-154a-e9a8eff08ce7
# ╠═90e5cff0-6012-11eb-3182-ef1e1f802343
# ╠═c0c38910-6012-11eb-0000-45b104ddfe5f
# ╠═3bad9990-6013-11eb-2151-852ff5553fcf
# ╠═c75650e0-6013-11eb-0e27-a13d3d271048
# ╠═7227baa0-6018-11eb-0dd4-0f104882dedd
# ╠═97006fa2-6015-11eb-34ec-3969e1b63b0e
# ╠═f4e1c610-6096-11eb-0a8c-6f0ffcc97f6b
# ╠═6a2a73a0-6096-11eb-237b-292c40feab88
# ╠═b4b9db60-60ad-11eb-255c-c9e7bec51fae
# ╠═0dcbef90-60b8-11eb-09d6-8bc1176c8f13
# ╠═d2368b80-60b1-11eb-2be7-7fe121cd2f66
# ╠═53ba7670-60b8-11eb-1407-914724e5b264
# ╠═c6a6c700-60c3-11eb-02a8-01486e522c30
# ╠═ed0474b0-60c8-11eb-1b2c-a50b5fb5f934
# ╠═1d45aa90-60c9-11eb-086c-ad50f90193f7
# ╠═4d2f4a90-60c9-11eb-164f-8d2339f0ab9a
# ╠═f5eba970-60ed-11eb-199f-f5c226d89f2e
# ╠═eb41d91e-60f4-11eb-180a-2722748c057c
# ╠═26d4e980-60ca-11eb-3290-5dfd070dda19
# ╠═a69d8980-60c8-11eb-1961-bdfc4f19f908
# ╠═37cd2f60-60f5-11eb-085d-55558904af4b
