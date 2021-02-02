### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ a059efc0-6580-11eb-2954-8fee0da0a55c
using Pkg

# ╔═╡ 0562b07e-658d-11eb-21c2-3953538d214c
using JLD2

# ╔═╡ ae0dd220-6581-11eb-0153-95687a5a79ab
using ZipFile

# ╔═╡ d109ed00-6580-11eb-1d38-3568019914ea
include("unzip")

# ╔═╡ d6047e10-6580-11eb-01ba-1ba6e8281ecd
include("function_CSet.jl")

# ╔═╡ cd236400-6580-11eb-3a95-edcebf7fce8d
Pkg.activate(".")

# ╔═╡ 406aa6d0-6581-11eb-0396-237c911d9332
begin
	#1 dl CSTParser source
	#mkpath("tmp_cst")
	#download("https://github.com/julia-vscode/CSTParser.jl/archive/master.zip", "tmp_cst/cstparser")
	#unzip("tmp_cst/cstparser")
	# 2 make CSet
	result = folder_to_CSet("tmp_cst/CSTParser.jl-master/src")
	# 3 save CSet
	@save result "src_cstparser.jld2"
	# 4 delete downloaded stuff
	rm("tmp_cst")	
end

# ╔═╡ Cell order:
# ╠═a059efc0-6580-11eb-2954-8fee0da0a55c
# ╠═cd236400-6580-11eb-3a95-edcebf7fce8d
# ╠═d109ed00-6580-11eb-1d38-3568019914ea
# ╠═d6047e10-6580-11eb-01ba-1ba6e8281ecd
# ╠═0562b07e-658d-11eb-21c2-3953538d214c
# ╠═ae0dd220-6581-11eb-0153-95687a5a79ab
# ╠═406aa6d0-6581-11eb-0396-237c911d9332
