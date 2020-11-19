### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ d9c5d0e0-250b-11eb-2b97-35768254f887
using Rmath

# ╔═╡ 89e055ee-29a7-11eb-1e83-117002a41478
using CategoricalArrays

# ╔═╡ c67833d0-2a87-11eb-3604-7b3c4c0d492c
using Statistics

# ╔═╡ 8dc220f0-2a8c-11eb-375f-6736eadd0169
using Plots

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

# ╔═╡ 1715fbb0-2aa1-11eb-3e5d-0d2dc2535e46


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

# ╔═╡ 4ea9f330-2a90-11eb-21c1-0769b83558ad


# ╔═╡ 00bf9ea0-2a8f-11eb-375d-153be99ed61b
titles = [string("Point pattern: \nIntensity =", intensity, ", M =", M, "inds.")
	,
	string("Abundance pattern: \nRealized mean density =", λ, "\nSpatial variance =", round(σ²;digits=2))
	,"",""]

# ╔═╡ 62e6f5e0-2a91-11eb-157d-1ffe3445f308
begin
	titlePP = ["Point pattern:", string("Intensity =", intensity, ", M =", M, "inds.")]
	titleAP = ["Abundance pattern:", string("Realized mean density =", λ, "\nSpatial variance =", round(σ²;digits=2))]
	title= [[titlePP] [titleAP]]
end

# ╔═╡ c2378dd0-2a90-11eb-372f-255c6bb8f2f0
titls = [
	[string("Point pattern:\nIntensity =", intensity, ", M =", M, "inds.")] [string("Abundance pattern:\nRealized mean density =", λ, "Spatial variance =", round(σ²;digits=2))] [string("Occurrence pattern:\nRealized occupancy =", round(ψ;digits=2))]  [string("Frequency of N\nwith mean density (blue)")] 
]

# ╔═╡ 2feae5c0-2a91-11eb-3a8c-bb298148ee85
asdf = [[1,2] [3,4] [5,6]]

# ╔═╡ 435db010-2a91-11eb-07bb-4bee14c9b362
typeof(asdf)

# ╔═╡ 7ed445ae-2a90-11eb-28c6-fde88f813a09
string("Point pattern: \nIntensity =", intensity, ", M =", M, "inds.")

# ╔═╡ cde01d90-2a96-11eb-2c3b-37af54dcaac8
l = @layout grid(2,2)

# ╔═╡ efe15750-2a8d-11eb-0648-b1bf953f2268
plot(
    N,
    layout = l, legend = false, seriestype = [:bar],
    title = titls, titleloc = :center, titlefont = font(8)
)

# ╔═╡ f03a0f90-2a96-11eb-0e0f-1fe7c0ad8ea3
plot!(z, layout=l
)

# ╔═╡ 006724c0-2a97-11eb-31d6-8b133ee4faf6
plot(
	u1, u2, seriestype = :scatter, title=string("Point pattern: \nIntensity =", intensity, ", M =", M, "inds."), legend=false, xaxis=(breaks), yaxis=(breaks)	
)

# ╔═╡ 0f3434c2-2a97-11eb-0b12-b90208c898da
plot(u1, u2, xlab = "x coord", ylab = "y coord", cex = 1, pch = 16, asp = 1,
       main = paste("Point pattern: \nIntensity =", intensity, ", M =", M, "inds."),
       xlim = c(0, quad_size), ylim = c(0, quad_size), frame = FALSE, col = "red") 
polygon(c(0, quad_size, quad_size, 0), c(0,0, quad_size, quad_size), lwd = 3,
       col = NA, border = "black")   # add border to grid boundary

    

# ╔═╡ 4bdd8bc0-2a9b-11eb-10f0-033967e81da0
rbreaks= round.(breaks;digits=3)

# ╔═╡ e5dbe3b2-2a9c-11eb-156b-572d9963ac81
N.array

# ╔═╡ 4a7740d0-2aa2-11eb-0fc8-8d86548a6609
rowcols = Int(sqrt(n_cell))

# ╔═╡ 540f9262-2aa1-11eb-0b64-4572d3d30f3b
ys = repeat(mid_pt, rowcols)

# ╔═╡ de6ba570-2aa1-11eb-0356-5bd1abff9c6e
length(ys)

# ╔═╡ a099b020-2aa1-11eb-04e5-6145cda70441
xs = [i for j in 1:rowcols, i in mid_pt]

# ╔═╡ a39d0512-2aa1-11eb-3b74-3dab2f66eae0
zs = reshape(N.array, 1, length(N))

# ╔═╡ 14067d50-2a97-11eb-3829-9d9698f11e88
plot(
	xs, ys, zs, seriestype = :scatter, title=string("Point pattern: \nIntensity =", intensity, ", M =", M, "inds."), legend=false, xaxis=(breaks), yaxis=(breaks))

# ╔═╡ 796275e0-2a9d-11eb-0383-797413583a48
mid_pt

# ╔═╡ 5b6bb6f0-2a9d-11eb-3cbe-a57484b68a2f
plot()

# ╔═╡ 7adc36e0-2a98-11eb-279a-8151c26d5a0a
z

# ╔═╡ 824bd4b0-2a9a-11eb-33ea-9d0c0b4629e5
N.dicts[1].keys

# ╔═╡ 16d358f0-2a97-11eb-051d-97108087a330
# (2) Visualize abundance pattern
    # Plot gridded point pattern with abundance per cell
    plot(u1, u2, xlab = "x coord", ylab = "y coord", cex = 1, pch = 16, asp = 1,
       main = paste("Abundance pattern: \nRealized mean density =", lambda, "\nSpatial variance =", round(var,2)),
       xlim = c(0, quad_size), ylim = c(0, quad_size), frame = FALSE, col = "red") # 

# ╔═╡ 586a1810-2a8f-11eb-15d5-f94f61ece220
["($i)" for j in 1:1, i in 1:11]

# ╔═╡ b3209900-2a8f-11eb-2ed9-b17f4789e07f
for i in 1:10, j in 1:10
	println("$i $j")
end

# ╔═╡ 1e214fe0-2a97-11eb-15e3-bd401028c909
plot point pattern
    # Overlay grid onto study area
    for(i in 1:length(breaks)){
       for(j in 1:length(breaks)){
       segments(breaks[i], breaks[j], rev(breaks)[i], breaks[j])
       segments(breaks[i], breaks[j], breaks[i], rev(breaks)[j])
       }
    }
    # Print abundance (N) into each cell

    #ottimizzabile con un singolo for in julia?
    for i in 1:length(mid_pt), j in 1:length(mid_pt)
      text(mid_pt[i],mid_pt[j],N[i,j],cex =10^(0.8-0.4*log10(n.cell)),col="blue")
    end
    polygon(c(0, quad_size, quad_size, 0), c(0,0, quad_size, quad_size), lwd = 3, col = NA, border = "black")   # add border to grid boundary

    # (3) Visualize occurrence (= presence/absence) pattern
    # Summarize point pattern even more:
    # occurrence (z) is indicator for abundance greater than 0
    plot(u1, u2, xlab = "x coord", ylab = "y coord", cex = 1, pch = 16, asp = 1,
       main = paste("Occurrence pattern: \nRealized occupancy =", round(psi,2)), xlim = c(0, quad_size),
       ylim = c(0, quad_size), frame = FALSE, col = "red") # plot point pattern
    # Overlay grid onto study area
    #ottimizzabile con un singolo for in julia?
    for(i in 1:length(breaks)){
       for(j in 1:length(breaks)){
          segments(breaks[i], breaks[j], rev(breaks)[i], breaks[j])
          segments(breaks[i], breaks[j], breaks[i], rev(breaks)[j])
       }
    }
    # Shade occupied cells (which have abundance N > 0 or occurrence z = 1)
    #ottimizzabile con un singolo for in julia?
    for(i in 1:(length(breaks)-1)){
       for(j in 1:(length(breaks)-1)){
          polygon(c(breaks[i], breaks[i+1], breaks[i+1], breaks[i]),
          c(breaks[j], breaks[j], breaks[j+1], breaks[j+1]),
          col = "black", density = z[i,j]*100)
       }
    }
    polygon(c(0, quad_size, quad_size, 0), c(0,0, quad_size, quad_size), lwd = 3, col = NA, border = "black")   # add border to grid boundary

    # (4) Visualize abundance distribution across sites
    # plot(table(N), xlab = "Abundance (N)", ylab = "Number of cells",
    # col = "black", xlim = c(0, max(N)), main = "Frequency of N with mean density (blue)", lwd = 3, frame = FALSE)
    histCount(N, NULL, xlab = "Abundance (N)", ylab = "Number of cells",
      color = "grey", main = "Frequency of N with mean density (blue)")
    abline(v = lambda, lwd = 3, col = "blue", lty=2)
    }, silent = TRUE )
    if(inherits(tryPlot, "try-error"))
      tryPlotError(tryPlot)

# ╔═╡ Cell order:
# ╠═d9c5d0e0-250b-11eb-2b97-35768254f887
# ╠═89e055ee-29a7-11eb-1e83-117002a41478
# ╠═c67833d0-2a87-11eb-3604-7b3c4c0d492c
# ╠═8dc220f0-2a8c-11eb-375f-6736eadd0169
# ╠═0631f160-2a87-11eb-1014-973e383d7d98
# ╠═0dbfd780-2a87-11eb-0009-17e7ffa9b23f
# ╠═0dbffe90-2a87-11eb-3e94-156628ebc76c
# ╠═0dc073c0-2a87-11eb-0c55-910835ca9bf1
# ╠═0dc507a0-2a87-11eb-02c1-5d0f0a883e7f
# ╠═0dc7edd0-2a87-11eb-286d-010d47fc0ae7
# ╠═0dc86300-2a87-11eb-0083-05975ecc0a92
# ╠═0dcc81b0-2a87-11eb-0458-559865ca4038
# ╠═0dd0523e-2a87-11eb-0921-676a3ac5cc10
# ╠═1715fbb0-2aa1-11eb-3e5d-0d2dc2535e46
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
# ╠═4ea9f330-2a90-11eb-21c1-0769b83558ad
# ╠═00bf9ea0-2a8f-11eb-375d-153be99ed61b
# ╠═62e6f5e0-2a91-11eb-157d-1ffe3445f308
# ╠═c2378dd0-2a90-11eb-372f-255c6bb8f2f0
# ╠═2feae5c0-2a91-11eb-3a8c-bb298148ee85
# ╠═435db010-2a91-11eb-07bb-4bee14c9b362
# ╠═7ed445ae-2a90-11eb-28c6-fde88f813a09
# ╠═cde01d90-2a96-11eb-2c3b-37af54dcaac8
# ╠═efe15750-2a8d-11eb-0648-b1bf953f2268
# ╠═f03a0f90-2a96-11eb-0e0f-1fe7c0ad8ea3
# ╠═006724c0-2a97-11eb-31d6-8b133ee4faf6
# ╠═0f3434c2-2a97-11eb-0b12-b90208c898da
# ╠═4bdd8bc0-2a9b-11eb-10f0-033967e81da0
# ╠═14067d50-2a97-11eb-3829-9d9698f11e88
# ╠═e5dbe3b2-2a9c-11eb-156b-572d9963ac81
# ╠═4a7740d0-2aa2-11eb-0fc8-8d86548a6609
# ╠═540f9262-2aa1-11eb-0b64-4572d3d30f3b
# ╠═de6ba570-2aa1-11eb-0356-5bd1abff9c6e
# ╠═a099b020-2aa1-11eb-04e5-6145cda70441
# ╠═a39d0512-2aa1-11eb-3b74-3dab2f66eae0
# ╠═796275e0-2a9d-11eb-0383-797413583a48
# ╠═5b6bb6f0-2a9d-11eb-3cbe-a57484b68a2f
# ╠═7adc36e0-2a98-11eb-279a-8151c26d5a0a
# ╠═824bd4b0-2a9a-11eb-33ea-9d0c0b4629e5
# ╠═16d358f0-2a97-11eb-051d-97108087a330
# ╠═586a1810-2a8f-11eb-15d5-f94f61ece220
# ╠═b3209900-2a8f-11eb-2ed9-b17f4789e07f
# ╠═1e214fe0-2a97-11eb-15e3-bd401028c909
