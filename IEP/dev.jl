### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ a15e6010-769a-11eb-353a-d18266848193
using Pkg

# ╔═╡ 596467e0-7691-11eb-3747-57d06be7535b
include("src/IEP.jl")

# ╔═╡ 98b6575e-769a-11eb-03bd-2d9cc2e9b6c7
parse = IEP.read_code(string(Pkg.dir("Catlab"),"/src"));

# ╔═╡ 38252f80-76a3-11eb-1a87-2b1aac50ccca
scr = IEP.scrape(parse);

# ╔═╡ 26ab0410-76a7-11eb-2455-b787ea5f6356
IEP.FunctionContainer

# ╔═╡ 0f7d9e90-76ae-11eb-166c-839c4db64ac7
IEP.FuncDef

# ╔═╡ 659a2500-76ae-11eb-2f9d-655bec8cc719
IEP.InputDef

# ╔═╡ 15685c00-76ae-11eb-3aaf-9f3de086c8d4
inps = [x.func.inputs for x in scr]

# ╔═╡ 8c610e10-76ae-11eb-337c-673be363d664
begin
	typ = Array{IEP.NameDef,1}(undef, 0)
	for in in inps
		typ = vcat(typ, [x.type for x in in])
	end
end

# ╔═╡ 4dfddfd0-76af-11eb-32a3-51c826394ed0
md"####################################################"

# ╔═╡ Cell order:
# ╠═596467e0-7691-11eb-3747-57d06be7535b
# ╠═a15e6010-769a-11eb-353a-d18266848193
# ╠═98b6575e-769a-11eb-03bd-2d9cc2e9b6c7
# ╠═38252f80-76a3-11eb-1a87-2b1aac50ccca
# ╠═26ab0410-76a7-11eb-2455-b787ea5f6356
# ╠═0f7d9e90-76ae-11eb-166c-839c4db64ac7
# ╠═659a2500-76ae-11eb-2f9d-655bec8cc719
# ╠═15685c00-76ae-11eb-3aaf-9f3de086c8d4
# ╠═8c610e10-76ae-11eb-337c-673be363d664
# ╟─4dfddfd0-76af-11eb-32a3-51c826394ed0
