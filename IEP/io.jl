### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 34ce3c20-6567-11eb-251e-ffb3033a2cbf
using JLD2

# ╔═╡ a35257f0-656f-11eb-1539-215c2da70ca4
using CSTParser, Catlab, FileIO

# ╔═╡ 9b1d1c00-6574-11eb-3e74-3b7ceadc6dc9
jldopen("./result2", "r") do file
	dump(file)
	result = file["result"]
end

# ╔═╡ bf005b2e-6576-11eb-0e67-1d4426a1b79a
result

# ╔═╡ Cell order:
# ╠═34ce3c20-6567-11eb-251e-ffb3033a2cbf
# ╠═a35257f0-656f-11eb-1539-215c2da70ca4
# ╠═9b1d1c00-6574-11eb-3e74-3b7ceadc6dc9
# ╠═bf005b2e-6576-11eb-0e67-1d4426a1b79a
