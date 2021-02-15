### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 27cc4430-6fa4-11eb-2c1b-35d7b7282184
using JLD2

# ╔═╡ 33f647b0-6fa4-11eb-2e9a-2135ade9e603
using Catlab

# ╔═╡ 37a60940-6fa4-11eb-238c-a79a8580fb43
using FileIO

# ╔═╡ 3c381480-6fa4-11eb-25fb-d93e3827cd0b
using Pkg

# ╔═╡ 814a8be0-6fa7-11eb-34d8-4bdb2bfb7992
using Flux

# ╔═╡ 402d91a0-6fa4-11eb-2506-298f3b4d9ce5
include("functions_struct.jl")

# ╔═╡ 1d585fb2-6fa5-11eb-06e8-c737e011d7dc
include("join_data.jl")

# ╔═╡ 41574490-6fa4-11eb-2230-298bcbf3a133
include("function_CSet.jl")

# ╔═╡ 561b69e0-6fab-11eb-1f2c-e70da84495fb
include("unzip.jl")

# ╔═╡ 560fa6e0-6fa7-11eb-3fd6-db6eb4a046ec
function mod_src(str::String)
	string(Pkg.dir(str),"/src")
end

# ╔═╡ 451a18f2-6fa4-11eb-0daf-2951e8563787
res1 = folder_to_CSet(mod_src("Flux"));

# ╔═╡ aa310eb0-6fa9-11eb-04aa-2bc4a9ac98a5
data = res1[2]

# ╔═╡ e47621d0-6fab-11eb-32e6-3ff9e7b1d860
res1[2]

# ╔═╡ 5a5e43b0-6fab-11eb-3bca-fd4d929dd9ab
folder_to_CSet

# ╔═╡ 953e4930-6fab-11eb-1ab7-37c91d1c60ea
rm

# ╔═╡ 20d2d1b0-6fab-11eb-3f1b-bb938b5026e1
begin
	mkpath("tmp/zoo")
	download("https://github.com/FluxML/model-zoo/archive/master.zip", "tmp/zoo/master.zip")
	unzip("tmp/zoo/master.zip")
	res2 = folder_to_CSet("tmp/zoo")
	rm("tmp/zoo"; recursive = true)
	join_data!(data, res2[2])
end

# ╔═╡ e7f361b0-6fab-11eb-3015-7d06c243afb9
@save "flux_plus_zoo.jld2" res1

# ╔═╡ Cell order:
# ╠═27cc4430-6fa4-11eb-2c1b-35d7b7282184
# ╠═33f647b0-6fa4-11eb-2e9a-2135ade9e603
# ╠═37a60940-6fa4-11eb-238c-a79a8580fb43
# ╠═3c381480-6fa4-11eb-25fb-d93e3827cd0b
# ╠═402d91a0-6fa4-11eb-2506-298f3b4d9ce5
# ╠═1d585fb2-6fa5-11eb-06e8-c737e011d7dc
# ╠═41574490-6fa4-11eb-2230-298bcbf3a133
# ╠═560fa6e0-6fa7-11eb-3fd6-db6eb4a046ec
# ╠═814a8be0-6fa7-11eb-34d8-4bdb2bfb7992
# ╠═451a18f2-6fa4-11eb-0daf-2951e8563787
# ╠═aa310eb0-6fa9-11eb-04aa-2bc4a9ac98a5
# ╠═e47621d0-6fab-11eb-32e6-3ff9e7b1d860
# ╠═561b69e0-6fab-11eb-1f2c-e70da84495fb
# ╠═5a5e43b0-6fab-11eb-3bca-fd4d929dd9ab
# ╠═953e4930-6fab-11eb-1ab7-37c91d1c60ea
# ╠═20d2d1b0-6fab-11eb-3f1b-bb938b5026e1
# ╠═e7f361b0-6fab-11eb-3015-7d06c243afb9
