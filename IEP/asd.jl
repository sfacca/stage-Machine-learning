### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 91097e40-72ce-11eb-3167-8f4b699c3417
using Catlab, CSTParser, FileIO, Pkg

# ╔═╡ fc8edd60-72f4-11eb-2acd-89d135260251
include("src/src.jl")

# ╔═╡ 6148fe00-72b6-11eb-0d20-8dc5b09c67af
raw = read_code("src");

# ╔═╡ 50b08f22-72fe-11eb-265e-99d4693ac0ef
typeof(raw)

# ╔═╡ 5c9b94d0-72b1-11eb-10a2-6bace567087d
asd = scrape(raw);

# ╔═╡ 7f1964b0-72c0-11eb-25d3-977e08d2e7af
typeof(asd)

# ╔═╡ 5b6cd1d0-72fe-11eb-3299-538cfafbea2d
code_only = [x[1] for x in raw];

# ╔═╡ 9eb632b0-72e5-11eb-2c71-2b3c53696440
println("asdasdasd")

# ╔═╡ 87833d00-72ee-11eb-0d23-4782b5fbd372
find_heads

# ╔═╡ cececf90-72b1-11eb-1ccf-7ff5747ddf5c
FunctionContainer

# ╔═╡ 6214d782-72cc-11eb-19f4-7d50113cb6b2
function find_function(str::String, funcs)
	res = []
	for tup in funcs
		if tup[1] == str
			push!(res, tup[2])
		end
	end
	res
end

# ╔═╡ a3c70880-72b1-11eb-139a-89cb8464ef3c
funs = [[getName(x.func.name),x.source] for x in asd]

# ╔═╡ 8de4f7a0-72cc-11eb-129b-15313417aada
find_function("view_Expr", funs)

# ╔═╡ 3799b780-72b5-11eb-3fc0-1b0382d0204d
strr = string([string([tup[1], tup[2], "\n"]) for tup in funs])

# ╔═╡ Cell order:
# ╠═91097e40-72ce-11eb-3167-8f4b699c3417
# ╠═6148fe00-72b6-11eb-0d20-8dc5b09c67af
# ╠═50b08f22-72fe-11eb-265e-99d4693ac0ef
# ╠═5c9b94d0-72b1-11eb-10a2-6bace567087d
# ╠═fc8edd60-72f4-11eb-2acd-89d135260251
# ╠═7f1964b0-72c0-11eb-25d3-977e08d2e7af
# ╠═5b6cd1d0-72fe-11eb-3299-538cfafbea2d
# ╠═9eb632b0-72e5-11eb-2c71-2b3c53696440
# ╠═87833d00-72ee-11eb-0d23-4782b5fbd372
# ╠═cececf90-72b1-11eb-1ccf-7ff5747ddf5c
# ╠═6214d782-72cc-11eb-19f4-7d50113cb6b2
# ╠═8de4f7a0-72cc-11eb-129b-15313417aada
# ╠═a3c70880-72b1-11eb-139a-89cb8464ef3c
# ╠═3799b780-72b5-11eb-3fc0-1b0382d0204d
