### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ a7eb6240-2daf-11eb-251e-e5a0564bfd6f
using Rmath, QuadGK

# ╔═╡ 2b8b5e20-2db0-11eb-34d7-27b8d6ccf6e8
#   Applied hierarchical modeling in ecology
#   Modeling distribution, abundance and species richness using R and BUGS
#   Volume 1: Prelude and Static models
#   Marc Kéry & J. Andy Royle
#
# Chapter 2. What are hierarchical models and how do we analyze them?
# =========================================================================


# 2.2 Random variables, probability density functions, statistical models,
#    probability, and statistical inference
# ==========================================================================

# ╔═╡ 151ae430-2db0-11eb-3847-e730bed38e33
dbinom.(0:5, 5, 0.2)

# ╔═╡ 2fcead20-2db0-11eb-20e5-1dae882e112c
pnorm(200,190,10)

# ╔═╡ 38403c80-2db0-11eb-0ee8-8fd37de770b2
pnorm(200,190,10) - pnorm(180, 190, 10)

# ╔═╡ 44a79722-2db0-11eb-28f7-3df6b21b9167
function f(x, μ, σ)
 (1 / sqrt(2*π*σ^2)) * exp( -((x-μ)^2)/(2*σ^2))
end

# ╔═╡ 7534ada0-2db1-11eb-3c5f-77d0ea741659
QuadGK.quadgk((x)->(f(x, 190,10)), 180,200)

# ╔═╡ d5f6ba70-2db1-11eb-0a47-e3294f305968
# 2.2.1 Statistical models
# ------------------------------------------------------------------------

# 2.2.2 Joint, marginal, and conditional distributions
# ------------------------------------------------------------------------

# ╔═╡ d227d820-2db1-11eb-173f-4f2803c177bf
Y = collect(0:5)   # Possible values of Y (# surveys with peregrine sightings)

# ╔═╡ da4442a0-2db1-11eb-2e73-91b16c837d81
X = collect(0:5)   # Possible values of X (# fledged young)

# ╔═╡ da4490c0-2db1-11eb-23a0-3f3f35df3e67
p = plogis.(-1.2 .+ *(X,2) ) # p as function of X

# ╔═╡ da44b7d0-2db1-11eb-053f-2588d1cdd818
round.(p; digits = 2)

# ╔═╡ 26651740-2db2-11eb-1208-59f4034c5d33
# Joint distribution [Y, X]
λ = 0.4

# ╔═╡ 2c3ac610-2db2-11eb-178c-5f91f2eeaff0
joint = Array{Float32}(undef, length(Y), length(X))

# ╔═╡ 78b5c8a0-2db2-11eb-31c7-77649ca7ce32
for i in 1:length(Y)
	joint[:,i] = round.(dbinom.(Y, 5, p[i]) * dpois(X[i], λ); digits = 3)
end

# ╔═╡ a43d9520-2db2-11eb-336a-79a14772b0b0
joint

# ╔═╡ a9f61f00-2db2-11eb-06fa-d373a19fc686
margX = round.([sum(joint[:,i]) for i in 1:(size(joint)[2])], digits = 4) 

# ╔═╡ 483a5370-2db3-11eb-2f8b-a5bda418543a
margY = round.([sum(joint[i,:]) for i in 1:(size(joint)[1])], digits = 4) 

# ╔═╡ 84cf8d90-2db4-11eb-278b-691430e67476
YgivenX = round.(	joint ./ reshape([margX[i] for j in 1:size(joint)[1], i in 1:size(joint)[2]], size(joint)[2], size(joint)[1]); digits= 2)

# ╔═╡ Cell order:
# ╠═a7eb6240-2daf-11eb-251e-e5a0564bfd6f
# ╠═2b8b5e20-2db0-11eb-34d7-27b8d6ccf6e8
# ╠═151ae430-2db0-11eb-3847-e730bed38e33
# ╠═2fcead20-2db0-11eb-20e5-1dae882e112c
# ╠═38403c80-2db0-11eb-0ee8-8fd37de770b2
# ╠═44a79722-2db0-11eb-28f7-3df6b21b9167
# ╠═7534ada0-2db1-11eb-3c5f-77d0ea741659
# ╠═d5f6ba70-2db1-11eb-0a47-e3294f305968
# ╠═d227d820-2db1-11eb-173f-4f2803c177bf
# ╠═da4442a0-2db1-11eb-2e73-91b16c837d81
# ╠═da4490c0-2db1-11eb-23a0-3f3f35df3e67
# ╠═da44b7d0-2db1-11eb-053f-2588d1cdd818
# ╠═26651740-2db2-11eb-1208-59f4034c5d33
# ╠═2c3ac610-2db2-11eb-178c-5f91f2eeaff0
# ╠═78b5c8a0-2db2-11eb-31c7-77649ca7ce32
# ╠═a43d9520-2db2-11eb-336a-79a14772b0b0
# ╠═a9f61f00-2db2-11eb-06fa-d373a19fc686
# ╠═483a5370-2db3-11eb-2f8b-a5bda418543a
# ╠═84cf8d90-2db4-11eb-278b-691430e67476
