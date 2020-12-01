### A Pluto.jl notebook ###
# v0.12.15

using Markdown
using InteractiveUtils

# ╔═╡ d9c5d0e0-250b-11eb-2b97-35768254f887
using Rmath

# ╔═╡ 89e055ee-29a7-11eb-1e83-117002a41478
using CategoricalArrays

# ╔═╡ c67833d0-2a87-11eb-3604-7b3c4c0d492c
using Statistics

# ╔═╡ 69cb95e0-2b50-11eb-2444-8d8c901ec3ab
using StatsPlots

# ╔═╡ 0631f160-2a87-11eb-1014-973e383d7d98
include("functions/abundanceMatrix.jl")

# ╔═╡ 0dbfd780-2a87-11eb-0009-17e7ffa9b23f
quad_size = 10

# ╔═╡ 0dbffe90-2a87-11eb-3e94-156628ebc76c
cell_size = 1

# ╔═╡ 0dc073c0-2a87-11eb-0c55-910835ca9bf1
intensity = 1

# ╔═╡ 0dc507a0-2a87-11eb-02c1-5d0f0a883e7f
show_plot = true

# ╔═╡ 0dc7edd0-2a87-11eb-286d-010d47fc0ae7
# Functions for the book Applied Hierarchical Modeling in Ecology (AHM)
# Marc Kery & Andy Royle, Academic Press, 2016.

# sim.fn - AHM1 section 1.1 p4

# A function to help to understand the relationship between point patterns,
# abundance data and occurrence data (also called presence/absence or distribution data)
# (introduced in AHM1 Section 1.1)

#
# Function that simulates animal or plant locations in space according
# to a homogenous Poisson process. This process is characterized by the
# intensity, which is the average number of points per unit area.
# The resulting point pattern is then discretized to obtain abundance data and
# presence/absence (or occurrence) data. The discretization of space is
# achieved by choosing the cell size.
# Note that you must choose cell_size such that the ratio of quad_size
# to cell_size is an integer.
# Argument show.plot should be set to FALSE when running simulations
# to speed things up.

# Compute some preliminaries
exp_M = intensity * quad_size^2       # Expected population size in quadrat

# ╔═╡ 0dc86300-2a87-11eb-0083-05975ecc0a92
breaks = collect(0:cell_size:quad_size) # boundaries of grid cells

# ╔═╡ 0dcc81b0-2a87-11eb-0458-559865ca4038
n_cell = (quad_size / cell_size)^2    # Number of cells in the quadrat

# ╔═╡ 0dd0523e-2a87-11eb-0921-676a3ac5cc10
mid_pt = [a + 0.5*cell_size for a in breaks[1:(end-1)]]

# ╔═╡ 0dd22700-2a87-11eb-0c1f-8b8e85d75787
# Simulate three processes: point process, cell abundance summary and cell occurrence summary
# (1) Generate and plot the mother of everything: point pattern
M = Int(rpois(1, exp_M)[1])         # Realized population size in quadrat is Poisson

# ╔═╡ 0dd693d0-2a87-11eb-2429-a98175449d37
u1 = runif(M, 0, quad_size)  # x coordinate of each individual

# ╔═╡ 0dd73010-2a87-11eb-3095-1f6af91d4b2b
u2 = runif(M, 0, quad_size)  # y coordinate of each individual

# ╔═╡ 0ddbeb02-2a87-11eb-166c-5f9167c3664c
# (2) Generate abundance data
# Summarize point pattern per cell: abundance (N) is number of points per cell
N = abundanceMatrix(cut(u1,breaks;extend=true),cut(u2,breaks,extend=true))

# ╔═╡ e4543ed0-2a87-11eb-0dea-339ad7e3734e
λ = round(mean(N);digits = 2) 

# ╔═╡ 01be0000-2a88-11eb-2f0e-2d7c18c63dc0
σ² = var(N)

# ╔═╡ 1b52c460-2a88-11eb-3a46-f76166c780aa
z = copy(N)

# ╔═╡ 22570820-2a88-11eb-1766-73fac688b144
for i in 1:length(z)
	if z[i]>0
		z[i]=1
	end
end

# ╔═╡ 5b64bea0-2a88-11eb-3ded-e7e804d79df2
z

# ╔═╡ 30b97a00-2a89-11eb-0b6e-c359d2a90926
ψ = mean(z)

# ╔═╡ 4ae064d0-2b50-11eb-3632-2d063f183743
bins = Int(sqrt(n_cell))

# ╔═╡ 670c1a00-2b4b-11eb-18c8-f58fd8620803
#point pattern
pointPatt = Plots.plot(
	title="Point Pattern\nIntensity = $intensity, M = $M inds.",
	u1,
	u2,
	seriestype=:scatter, 
	xaxis=breaks,yaxis=breaks, gridalpha=1, gridcolor=:red,legend=false
)

# ╔═╡ 7d3ba310-2b3a-11eb-2d97-3f722f6646d5
#abundance pattern
abundancePatt = Plots.histogram2d(
	title="Abundance pattern: \nRealized mean density =$λ\nSpatial variance =$(round(σ²;digits=2))",
	u1,
	u2,
	bins=bins,fc=:plasma,
	xaxis=breaks,yaxis=breaks, gridalpha=1
)

# ╔═╡ 959438c0-2b4c-11eb-1fd7-cfd3fbb81547
#occurrence pattern
occurrencePatt = Plots.histogram2d(
	title="Occurrence Pattern\nRealized occupancy = $(round(ψ;digits=2)) ",	
	[a[1]-1 for a in findall(!iszero, N)],
	[a[2]-1 for a in findall(!iszero, N)],
	bins=bins,fc=:black,legend=false,
	xaxis=breaks,yaxis=breaks, gridalpha=1
)

# ╔═╡ 5cb87240-2b4d-11eb-3e06-4505f222afca
#frequency of N
freqNPlot = Plots.plot(histogram(
	reshape(N.array,length(N.array)), 
	title="Frequency of N \nmean density (red) = $λ",
	xlab = "Abundance (N)", ylab = "Number of cells", legend=false
))

# ╔═╡ b5a56150-2b4e-11eb-291d-4d6b827c4fed
Plots.plot!([λ], seriestype=:vline, color=:red)

# ╔═╡ 8253256e-2b4f-11eb-3ee3-1930f48ec839
Plots.plot(pointPatt, abundancePatt, occurrencePatt, freqNPlot)

# ╔═╡ Cell order:
# ╠═d9c5d0e0-250b-11eb-2b97-35768254f887
# ╠═89e055ee-29a7-11eb-1e83-117002a41478
# ╠═c67833d0-2a87-11eb-3604-7b3c4c0d492c
# ╠═69cb95e0-2b50-11eb-2444-8d8c901ec3ab
# ╠═0631f160-2a87-11eb-1014-973e383d7d98
# ╠═0dbfd780-2a87-11eb-0009-17e7ffa9b23f
# ╠═0dbffe90-2a87-11eb-3e94-156628ebc76c
# ╠═0dc073c0-2a87-11eb-0c55-910835ca9bf1
# ╠═0dc507a0-2a87-11eb-02c1-5d0f0a883e7f
# ╠═0dc7edd0-2a87-11eb-286d-010d47fc0ae7
# ╠═0dc86300-2a87-11eb-0083-05975ecc0a92
# ╠═0dcc81b0-2a87-11eb-0458-559865ca4038
# ╠═0dd0523e-2a87-11eb-0921-676a3ac5cc10
# ╠═0dd22700-2a87-11eb-0c1f-8b8e85d75787
# ╠═0dd693d0-2a87-11eb-2429-a98175449d37
# ╠═0dd73010-2a87-11eb-3095-1f6af91d4b2b
# ╠═0ddbeb02-2a87-11eb-166c-5f9167c3664c
# ╠═e4543ed0-2a87-11eb-0dea-339ad7e3734e
# ╠═01be0000-2a88-11eb-2f0e-2d7c18c63dc0
# ╠═1b52c460-2a88-11eb-3a46-f76166c780aa
# ╠═22570820-2a88-11eb-1766-73fac688b144
# ╠═5b64bea0-2a88-11eb-3ded-e7e804d79df2
# ╠═30b97a00-2a89-11eb-0b6e-c359d2a90926
# ╠═4ae064d0-2b50-11eb-3632-2d063f183743
# ╠═670c1a00-2b4b-11eb-18c8-f58fd8620803
# ╠═7d3ba310-2b3a-11eb-2d97-3f722f6646d5
# ╠═959438c0-2b4c-11eb-1fd7-cfd3fbb81547
# ╠═5cb87240-2b4d-11eb-3e06-4505f222afca
# ╠═b5a56150-2b4e-11eb-291d-4d6b827c4fed
# ╠═8253256e-2b4f-11eb-3ee3-1930f48ec839
