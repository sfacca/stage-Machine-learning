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

# ╔═╡ 20b850c0-6898-11eb-1640-c5b7949a97fe
using Catlab.Rewrite

# ╔═╡ d109ed00-6580-11eb-1d38-3568019914ea
include("unzip.jl")

# ╔═╡ d6047e10-6580-11eb-01ba-1ba6e8281ecd
include("function_CSet.jl")

# ╔═╡ ca5db740-6894-11eb-1677-e56fceb42617
include("functions_struct.jl")

# ╔═╡ cd236400-6580-11eb-3a95-edcebf7fce8d
Pkg.activate(".")

# ╔═╡ ceee5b90-6897-11eb-0ebe-67354802cfa2
begin
	
	result = folder_to_CSet(string(Pkg.dir("CSTParser"),"/src"))
	# 3 save CSet
	@save "src_cstparser.jld2" result
end

# ╔═╡ db4a5c70-6d35-11eb-2984-4168ec2658d1
result[2]

# ╔═╡ 77a4b130-7126-11eb-0c66-e554a1d1c926
result[1]

# ╔═╡ Cell order:
# ╠═a059efc0-6580-11eb-2954-8fee0da0a55c
# ╠═cd236400-6580-11eb-3a95-edcebf7fce8d
# ╠═d109ed00-6580-11eb-1d38-3568019914ea
# ╠═d6047e10-6580-11eb-01ba-1ba6e8281ecd
# ╠═ca5db740-6894-11eb-1677-e56fceb42617
# ╠═0562b07e-658d-11eb-21c2-3953538d214c
# ╠═ae0dd220-6581-11eb-0153-95687a5a79ab
# ╠═20b850c0-6898-11eb-1640-c5b7949a97fe
# ╠═ceee5b90-6897-11eb-0ebe-67354802cfa2
# ╠═db4a5c70-6d35-11eb-2984-4168ec2658d1
# ╠═77a4b130-7126-11eb-0c66-e554a1d1c926
