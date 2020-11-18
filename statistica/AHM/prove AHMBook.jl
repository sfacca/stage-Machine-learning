### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ d9c5d0e0-250b-11eb-2b97-35768254f887
using Rmath

# ╔═╡ 4412c4e0-25d3-11eb-34a2-5772272d69b6
using DataFrames

# ╔═╡ 89e055ee-29a7-11eb-1e83-117002a41478
using CategoricalArrays

# ╔═╡ 451cdf90-29bd-11eb-01d6-4fea20f9b859
using NamedArrays

# ╔═╡ d5aa0d10-29ab-11eb-1405-0b95c83c93a6
function pcat(a::Array{T,1},b::Array{T,1}) where {T}
    if length(a)<length(b)
        vcat([(a[i],b[i]) for i in 1:length(a)], [(nothing,b[i]) for i in length(a)+1:length(b)])
    elseif length(a)>length(b)
        vcat([(a[i],b[i]) for i in 1:length(b)], [(a[i],nothing) for i in length(b)+1:length(a)],)
    else
        [(a[i],b[i]) for i in 1:length(a)]
    end
end

# ╔═╡ c00f309e-29c1-11eb-0663-e1cd4f14db81


# ╔═╡ 65cf8a30-29bd-11eb-34e3-ebe0c54d9089
function abundanceMatrix(a::Array{T,1},b::Array{T,1}) where {T}
	aNames = unique(sort(a))
	aMap = Dict([(aNames[i],i) for i in 1:length(aNames)])
	bNames = unique(sort(b))
	bMap = Dict([(bNames[i],i) for i in 1:length(bNames)])
	res = reshape([0 for _ in 1:(length(a)*length(b))], length(a), length(b))
	for i in 1:length(a)
		res[aMap[a[i]],bMap[b[i]]] += 1
	end
	
	res	
end

# ╔═╡ 75a45a50-29ca-11eb-16be-c503775aeddc


# ╔═╡ fdb952a0-29c1-11eb-15a8-19fd1ff2b72b


# ╔═╡ dd194270-29bd-11eb-3c98-09e7a3fb8fb8
NamedArray(Int, 3, 2)

# ╔═╡ c49682f0-29c0-11eb-0544-bd3ee8de1ead
fds = ["ci","csd","dasd"]

# ╔═╡ d107a190-29c0-11eb-34b2-2d1cab6fefce
dfds = Dict([(fds[i],i) for i in 1:length(fds)])

# ╔═╡ 1895a7a0-29c1-11eb-264d-c98a20159080
dfds["ci"]

# ╔═╡ 49e1a8ae-29bf-11eb-2dc1-a9e976d2d269
a = Array{Int}(undef, 5)

# ╔═╡ 5d472c90-29bf-11eb-046f-27005f9be259
b = Array{Int}(undef, 6)

# ╔═╡ 234774f0-29bf-11eb-150b-654e21f303ab
arr = reshape([0 for _ in 1:(length(a)*length(b))], length(a),length(b))

# ╔═╡ cc3cc880-29bf-11eb-2001-b7817c64b284
asd = [3,2,1]

# ╔═╡ 46e0cf50-29c0-11eb-20bc-7ff10c27e378
sortperm(asd)

# ╔═╡ 8ad7e870-29bf-11eb-250b-6513693ce577
reshape(arr, 5,6)

# ╔═╡ c3d26510-29bf-11eb-3b0e-3349afc6aa83


# ╔═╡ 5813aace-29b7-11eb-1e68-0d47455162e5
quad_size = 10

# ╔═╡ 694ab5f2-29b7-11eb-30fd-83c9385f73e2
cell_size = 1

# ╔═╡ 694add00-29b7-11eb-28d3-5d84a1015268
intensity = 1

# ╔═╡ 694b2b1e-29b7-11eb-3148-2190de13af1f
show_plot = true

# ╔═╡ 48fb12e0-29b7-11eb-1712-932b9b0acd3c
exp_M = intensity * quad_size^2       # Expected population size in quadrat

# ╔═╡ 5579c610-29b7-11eb-1fe7-8bc9fe60038b
breaks = collect(0:cell_size:quad_size) # boundaries of grid cells

# ╔═╡ 5579ed20-29b7-11eb-35f9-913da70a0517
n_cell = (quad_size / cell_size)^2    # Number of cells in the quadrat

# ╔═╡ 557a3b40-29b7-11eb-017d-8b5c205d0dee
mid_pt = breaks[length(breaks)] + 0.5 * cell_size # cell mid-points

# ╔═╡ 557d96a0-29b7-11eb-1de1-ed4287ab30b7
# Simulate three processes: point process, cell abundance summary and cell occurrence summary
# (1) Generate and plot the mother of everything: point pattern
M = Int(rpois(1, exp_M)[1])         # Realized population size in quadrat is Poisson

# ╔═╡ 557fb980-29b7-11eb-1eeb-013e2184893a
u1 = runif(M, 0, quad_size)  # x coordinate of each individual

# ╔═╡ 55802eb2-29b7-11eb-37a0-1770329bca5c
u2 = runif(M, 0, quad_size)  # y coordinate of each individual

# ╔═╡ c09730e0-29b7-11eb-3885-855b4d5bc4f8
cu1 = cut(u1, breaks)

# ╔═╡ dff1eca0-29b7-11eb-3928-3bbcade645f8
value(cu1[1])

# ╔═╡ c9a28f40-29b7-11eb-3522-b33cdb619cb3
cuA = [cu1[i] for i in 1:length(cu1)]

# ╔═╡ c4532770-29b7-11eb-2511-37d17f2f8956
cu2 = cut(u2, breaks)

# ╔═╡ 55836300-29b7-11eb-0c1f-d38c5385347c
# (2) Generate abundance data
# Summarize point pattern per cell: abundance (N) is number of points per cell

# ╔═╡ 24f4b3f0-29b8-11eb-1160-4b2c0dd47a31
println("##############breaking")

# ╔═╡ 0c8e3662-29b8-11eb-03a6-89305368dd18
cu1[1].level

# ╔═╡ 8bcde560-29b8-11eb-1202-47bdb41c40bd
cu1[2].level

# ╔═╡ ce9b2f10-29b8-11eb-23c8-f5fbb09a0fee
cu1[1].valindex

# ╔═╡ 4cc17440-29b8-11eb-0f09-1377556e70e1
cu1.pool.invindex

# ╔═╡ 0e4343f0-29b9-11eb-33ed-e30e291c1704
cu1.pool.valindex

# ╔═╡ f3ef6abe-29b7-11eb-309e-1f96e7a7e304
dump(cu1[1])

# ╔═╡ a813c000-29b8-11eb-1fef-253a8efe678a
couples = pcat([cu1[i].level for i in 1:length(cu1)],[cu2[i].level for i in 1:length(cu2)])

# ╔═╡ 45978aa0-29b9-11eb-19ea-e79384b86003
DataFrame([cu1[i].level for i in 1:length(cu1)],[cu2[i].level for i in 1:length(cu2)])

# ╔═╡ 6ea36c8e-29b7-11eb-0c16-c191d2986514
DataFrame(pcat(cut(u1, breaks),cut(u2, breaks)))

# ╔═╡ 858c4ad0-29b7-11eb-0085-4fd9932d21df
N <- as.matrix(table(cut(u1, breaks=breaks), cut(u2, breaks= breaks)))

# ╔═╡ 23a9b930-29bf-11eb-1966-5b88344ce08d
NamedArray([1 3; 2 4], ( ["a", "b"], ["c", "d"] ))

# ╔═╡ a39ceed0-29c1-11eb-2425-410333b7620d
gggf = 5

# ╔═╡ 70c15f00-29c1-11eb-38ea-c7bbd0ba4e45
gggf += 1

# ╔═╡ Cell order:
# ╠═d9c5d0e0-250b-11eb-2b97-35768254f887
# ╠═4412c4e0-25d3-11eb-34a2-5772272d69b6
# ╠═89e055ee-29a7-11eb-1e83-117002a41478
# ╠═451cdf90-29bd-11eb-01d6-4fea20f9b859
# ╠═d5aa0d10-29ab-11eb-1405-0b95c83c93a6
# ╠═c00f309e-29c1-11eb-0663-e1cd4f14db81
# ╠═65cf8a30-29bd-11eb-34e3-ebe0c54d9089
# ╠═a39ceed0-29c1-11eb-2425-410333b7620d
# ╠═70c15f00-29c1-11eb-38ea-c7bbd0ba4e45
# ╠═75a45a50-29ca-11eb-16be-c503775aeddc
# ╠═fdb952a0-29c1-11eb-15a8-19fd1ff2b72b
# ╠═dd194270-29bd-11eb-3c98-09e7a3fb8fb8
# ╠═c49682f0-29c0-11eb-0544-bd3ee8de1ead
# ╠═d107a190-29c0-11eb-34b2-2d1cab6fefce
# ╠═1895a7a0-29c1-11eb-264d-c98a20159080
# ╠═49e1a8ae-29bf-11eb-2dc1-a9e976d2d269
# ╠═5d472c90-29bf-11eb-046f-27005f9be259
# ╠═234774f0-29bf-11eb-150b-654e21f303ab
# ╠═cc3cc880-29bf-11eb-2001-b7817c64b284
# ╠═46e0cf50-29c0-11eb-20bc-7ff10c27e378
# ╠═8ad7e870-29bf-11eb-250b-6513693ce577
# ╠═c3d26510-29bf-11eb-3b0e-3349afc6aa83
# ╠═5813aace-29b7-11eb-1e68-0d47455162e5
# ╠═694ab5f2-29b7-11eb-30fd-83c9385f73e2
# ╠═694add00-29b7-11eb-28d3-5d84a1015268
# ╠═694b2b1e-29b7-11eb-3148-2190de13af1f
# ╠═48fb12e0-29b7-11eb-1712-932b9b0acd3c
# ╠═5579c610-29b7-11eb-1fe7-8bc9fe60038b
# ╠═5579ed20-29b7-11eb-35f9-913da70a0517
# ╠═557a3b40-29b7-11eb-017d-8b5c205d0dee
# ╠═557d96a0-29b7-11eb-1de1-ed4287ab30b7
# ╠═557fb980-29b7-11eb-1eeb-013e2184893a
# ╠═55802eb2-29b7-11eb-37a0-1770329bca5c
# ╠═c09730e0-29b7-11eb-3885-855b4d5bc4f8
# ╠═dff1eca0-29b7-11eb-3928-3bbcade645f8
# ╠═c9a28f40-29b7-11eb-3522-b33cdb619cb3
# ╠═c4532770-29b7-11eb-2511-37d17f2f8956
# ╠═55836300-29b7-11eb-0c1f-d38c5385347c
# ╠═24f4b3f0-29b8-11eb-1160-4b2c0dd47a31
# ╠═0c8e3662-29b8-11eb-03a6-89305368dd18
# ╠═8bcde560-29b8-11eb-1202-47bdb41c40bd
# ╠═ce9b2f10-29b8-11eb-23c8-f5fbb09a0fee
# ╠═4cc17440-29b8-11eb-0f09-1377556e70e1
# ╠═0e4343f0-29b9-11eb-33ed-e30e291c1704
# ╠═f3ef6abe-29b7-11eb-309e-1f96e7a7e304
# ╠═a813c000-29b8-11eb-1fef-253a8efe678a
# ╠═45978aa0-29b9-11eb-19ea-e79384b86003
# ╠═6ea36c8e-29b7-11eb-0c16-c191d2986514
# ╠═858c4ad0-29b7-11eb-0085-4fd9932d21df
# ╠═23a9b930-29bf-11eb-1966-5b88344ce08d
