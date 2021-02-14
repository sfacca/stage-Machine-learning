### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 49d553e0-6d2f-11eb-071c-4f84a5704dfa
using JLD2

# ╔═╡ b1e7c140-6d32-11eb-02c7-eb9b4a45dc4c
using Catlab

# ╔═╡ 6b6028e0-6d99-11eb-27d2-471d72e43c0d
using FileIO

# ╔═╡ b4734e20-6d32-11eb-01a5-1d57875474c5
include("functions_struct.jl")

# ╔═╡ bef1d0a2-6d97-11eb-3f57-a7eba5d095a5
begin 
	result = nothing
	@load "src_cstparser.jld2" result
	data1 = result[2]
	@load "src_tokenize.jld2" result
	data2 = result[2]
	result = nothing
end

# ╔═╡ 19f0e730-6d33-11eb-24a3-57c78cfdc6c4
@load "src_cstparser.jld2" result

# ╔═╡ 754879c0-6d99-11eb-2fdb-d3c003d2cf1e
exp=load("src_tokenize.jld2")

# ╔═╡ Cell order:
# ╠═49d553e0-6d2f-11eb-071c-4f84a5704dfa
# ╠═b1e7c140-6d32-11eb-02c7-eb9b4a45dc4c
# ╠═6b6028e0-6d99-11eb-27d2-471d72e43c0d
# ╠═b4734e20-6d32-11eb-01a5-1d57875474c5
# ╠═19f0e730-6d33-11eb-24a3-57c78cfdc6c4
# ╠═bef1d0a2-6d97-11eb-3f57-a7eba5d095a5
# ╠═754879c0-6d99-11eb-2fdb-d3c003d2cf1e
