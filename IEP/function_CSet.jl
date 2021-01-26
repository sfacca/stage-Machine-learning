### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ f5031280-600e-11eb-3799-015a8792ae63
using Pkg

# ╔═╡ 90e5cff0-6012-11eb-3182-ef1e1f802343
using Catlab, Catlab.CategoricalAlgebra, DataFrames

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
	df = DataFrame(name= names, doc = docs, inputs = inputs, source = sources)
end

# ╔═╡ 97006fa2-6015-11eb-34ec-3969e1b63b0e
# get the leaves
begin
	leaves = []
	for i in 1:5
		tmp = leaves(raw_parse[i][1])
		parsed = vcat(leaves, [(leaves = tmp[x], source= leaves[i][2]) for x in 1:length(tmp)])
	end
end

# ╔═╡ 0eb42cf0-6019-11eb-1d05-b1a0ffb98461


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
# ╠═0eb42cf0-6019-11eb-1d05-b1a0ffb98461
