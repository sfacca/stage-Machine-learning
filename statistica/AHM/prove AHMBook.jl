### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ d9c5d0e0-250b-11eb-2b97-35768254f887
using Rmath

# ╔═╡ edf645e0-250b-11eb-1481-c51450c3d009
#sim_fn
quad_size = 10

# ╔═╡ 013974ae-250c-11eb-0c5c-491fde9aa346
cell_size = 1

# ╔═╡ 0139c2d0-250c-11eb-2370-c35f7e35a2ed
intensity = 1

# ╔═╡ 013a3800-250c-11eb-38e9-3b3449c65b13
how_plot = true

# ╔═╡ 02dd87c0-250c-11eb-15a8-19f5c5179d23
exp_M = intensity * quad_size^2

# ╔═╡ 0d560ab0-250c-11eb-2c1b-7fa579b60306
M = rpois(1, exp_M)

# ╔═╡ 8b52d970-250c-11eb-2885-497e3d632ac4
function seq(;from = 1, to = 1, by = 1)
	arr = from:to
	k*by >= from -> k*by <= to
	for k in 1:to/by
end
collect(from:by:to)

# ╔═╡ Cell order:
# ╠═d9c5d0e0-250b-11eb-2b97-35768254f887
# ╠═edf645e0-250b-11eb-1481-c51450c3d009
# ╠═013974ae-250c-11eb-0c5c-491fde9aa346
# ╠═0139c2d0-250c-11eb-2370-c35f7e35a2ed
# ╠═013a3800-250c-11eb-38e9-3b3449c65b13
# ╠═02dd87c0-250c-11eb-15a8-19f5c5179d23
# ╠═0d560ab0-250c-11eb-2c1b-7fa579b60306
# ╠═8b52d970-250c-11eb-2885-497e3d632ac4
