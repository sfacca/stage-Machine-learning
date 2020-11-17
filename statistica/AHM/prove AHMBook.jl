### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ d9c5d0e0-250b-11eb-2b97-35768254f887
using Rmath

# ╔═╡ 4412c4e0-25d3-11eb-34a2-5772272d69b6
using DataFrames

# ╔═╡ 38096490-25da-11eb-39e9-63a222b79521
using Tables

# ╔═╡ da824630-25d3-11eb-2b00-af159839340d
quad_size=10

# ╔═╡ ea334d90-25d3-11eb-3d68-ff106d9d6f97
cell_size=1

# ╔═╡ ea3374a0-25d3-11eb-0124-979af72dfac9
intensity=1

# ╔═╡ ea339bb0-25d3-11eb-2d7c-f39ec341bb47
show_plot=true

# ╔═╡ ebda1fc0-25d3-11eb-1dca-8157b5d5920f
exp_M = intensity * quad_size^2

# ╔═╡ f29f37a0-25d3-11eb-08d2-519d28d7d1e7
breaks = collect(0.0:cell_size:quad_size)
collect(0:cell_size:quad_size)

# ╔═╡ f4416a60-25dd-11eb-260a-9f3663955f39


# ╔═╡ 2855cc80-25d7-11eb-2f26-5d63abcf4070
typeof(breaks)

# ╔═╡ f29f5eb0-25d3-11eb-116f-2ded207a91ed
n_cell = (quad_size / cell_size)^2

# ╔═╡ f29facd0-25d3-11eb-03b5-fb6a47b43f05
mid_pt = breaks[length(breaks)] + 0.5 * cell_size

# ╔═╡ f2a4dcf0-25d3-11eb-3dd7-6fdaa1411807
M = Int(rpois(1, exp_M)[1])

# ╔═╡ f2a79c10-25d3-11eb-361f-4bdc84830c9d
u1 = runif(M, 0, quad_size)

# ╔═╡ f2aa3420-25d3-11eb-17ad-bbef0ae7d080
u2 = runif(M, 0, quad_size)

# ╔═╡ 67e82f22-25da-11eb-03be-aba4581a1410
cu1= cut(0.0:cell_size:quad_size,u1,extend=true)

# ╔═╡ 882d8900-28fb-11eb-00d0-1f96c1ccf5bd


# ╔═╡ 1073e40e-25de-11eb-3048-f10ffcc6f8cf
length(u1)

# ╔═╡ e0236bf0-25dd-11eb-2c84-154dcebe40cf
length(cu1)

# ╔═╡ c9536ce0-25dd-11eb-08dd-d5638d81151a
cu1

# ╔═╡ 5de81b10-25db-11eb-1ac5-23365f228756
typeof(cu1)

# ╔═╡ 8fbb62a0-25db-11eb-123b-dd9615506288
-1:0.5:1[2]

# ╔═╡ 9e63f022-25da-11eb-0be1-832defe3c38b
?cut


# ╔═╡ 85d12f3e-25d6-11eb-0da9-695d5444485d
N = (cut(u1,breaks),cut(u2,breaks))

# ╔═╡ da4aa980-25d5-11eb-0a3c-cbb233801bdd
download("https://github.com/mikemeredith/AHMbook/raw/master/R/simFn_AHM1_1-1_Simulate_Poisson_process.R","originali/sim_fn.R")

# ╔═╡ 4aadb3f0-25dd-11eb-3a25-ad07df8fc814
rpois(1,2)

# ╔═╡ 4e49c670-25dd-11eb-397c-99a533b3e3b8
typeof(rpois(1,2))

# ╔═╡ 28b39fc0-25de-11eb-3e50-f796f0021f44
begin
	u = [1.3,2.4,3.5,6.7]
	cccc = cut(breaks,u,extend=true)
end

# ╔═╡ f37b65d0-25de-11eb-3642-33d00f65a5b0
cccc

# ╔═╡ Cell order:
# ╠═d9c5d0e0-250b-11eb-2b97-35768254f887
# ╠═4412c4e0-25d3-11eb-34a2-5772272d69b6
# ╠═da824630-25d3-11eb-2b00-af159839340d
# ╠═ea334d90-25d3-11eb-3d68-ff106d9d6f97
# ╠═ea3374a0-25d3-11eb-0124-979af72dfac9
# ╠═ea339bb0-25d3-11eb-2d7c-f39ec341bb47
# ╠═ebda1fc0-25d3-11eb-1dca-8157b5d5920f
# ╠═f29f37a0-25d3-11eb-08d2-519d28d7d1e7
# ╠═f4416a60-25dd-11eb-260a-9f3663955f39
# ╠═2855cc80-25d7-11eb-2f26-5d63abcf4070
# ╠═f29f5eb0-25d3-11eb-116f-2ded207a91ed
# ╠═f29facd0-25d3-11eb-03b5-fb6a47b43f05
# ╠═f2a4dcf0-25d3-11eb-3dd7-6fdaa1411807
# ╠═f2a79c10-25d3-11eb-361f-4bdc84830c9d
# ╠═f2aa3420-25d3-11eb-17ad-bbef0ae7d080
# ╠═67e82f22-25da-11eb-03be-aba4581a1410
# ╠═882d8900-28fb-11eb-00d0-1f96c1ccf5bd
# ╠═1073e40e-25de-11eb-3048-f10ffcc6f8cf
# ╠═e0236bf0-25dd-11eb-2c84-154dcebe40cf
# ╠═c9536ce0-25dd-11eb-08dd-d5638d81151a
# ╠═5de81b10-25db-11eb-1ac5-23365f228756
# ╠═8fbb62a0-25db-11eb-123b-dd9615506288
# ╠═9e63f022-25da-11eb-0be1-832defe3c38b
# ╠═38096490-25da-11eb-39e9-63a222b79521
# ╠═85d12f3e-25d6-11eb-0da9-695d5444485d
# ╠═da4aa980-25d5-11eb-0a3c-cbb233801bdd
# ╠═4aadb3f0-25dd-11eb-3a25-ad07df8fc814
# ╠═4e49c670-25dd-11eb-397c-99a533b3e3b8
# ╠═28b39fc0-25de-11eb-3e50-f796f0021f44
# ╠═f37b65d0-25de-11eb-3642-33d00f65a5b0
