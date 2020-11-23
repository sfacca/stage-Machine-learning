### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 44db6642-2d8d-11eb-2ad3-3957258c62dc
include("../functions/sim_fn.jl")

# ╔═╡ 5a2df7a0-2d8e-11eb-0fb8-f76b7545ef42
sim_fn(;quad_size = 10, cell_size = 1, intensity = 1)["plot"]

# ╔═╡ 5d6fdc30-2d8e-11eb-25ad-c10330f4fb44
set.seed(82)

# ╔═╡ 5d705160-2d8e-11eb-12ad-b7cb9cd85a66
begin
	tmp = sim_fn(;quad_size = 16, cell_size = 2, intensity = 0.5)
	# Effect of grain size of study on abundance and occupancy (intensity constant)
	tmp = sim_fn(;quad_size = 10, cell_size = 1, intensity = 0.5)
	tmp = sim_fn(;quad_size = 10, cell_size = 2, intensity = 0.5)
	tmp = sim_fn(;quad_size = 10, cell_size = 5, intensity = 0.5)
	tmp = sim_fn(;quad_size = 10, cell_size = 10, intensity = 0.5)["plot"]
end

# ╔═╡ Cell order:
# ╠═44db6642-2d8d-11eb-2ad3-3957258c62dc
# ╠═5a2df7a0-2d8e-11eb-0fb8-f76b7545ef42
# ╠═5d6fdc30-2d8e-11eb-25ad-c10330f4fb44
# ╠═5d705160-2d8e-11eb-12ad-b7cb9cd85a66
