# porting di https://github.com/mikemeredith/AHM_code/blob/master/AHM1_ch01/AHM1_01.1.R
# porting di https://github.com/mikemeredith/AHMbook/blob/master/R/simFn_AHM1_1-1_Simulate_Poisson_process.R
# da package R AHMBook
# manuale https://cran.r-project.org/web/packages/AHMbook/AHMbook.pdf

#= sim.fn: simula poisson point process

sim.fn(quad_size = 10, cell_size = 1, intensity = 1, show.plot = TRUE)
Arguments
quad_size: The length of each side of the quadrat (in arbitrary units)

cell_size: The length of each side of the cells into which the quadrat is divided. The ratio of quad_size to cell_size must be an integer.

intensity: The average number of points (animals or plants) per unit area.

show.plot: If TRUE, the results are plotted. Set to FALSE when running simulations.
=#


using Rmath #rpois, runif
using CategoricalArrays #cut
using Statistics #mean, round
using StatsPlots #plotting

include("abundanceMatrix.jl")

function sim_fn(; quad_size::Int = 10, cell_size::Int = 1, intensity::Int = 1, show_plot::Bool = true)

      
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
   exp_M::Int = intensity * quad_size^2       # Expected population size in quadrat
   breaks = collect(0:cell_size:quad_size) # boundaries of grid cells
   n_cell = (quad_size / cell_size)^2    # Number of cells in the quadrat
   mid_pt = [a + 0.5*cell_size for a in breaks[1:(end-1)]] # cell mid-points

   # Simulate three processes: point process, cell abundance summary and cell occurrence summary
   # (1) Generate and plot the mother of everything: point pattern
   M = Int(rpois(1, exp_M)[1])         # Realized population size in quadrat is Poisson
   u1 = runif(M, 0, quad_size)  # x coordinate of each individual
   u2 = runif(M, 0, quad_size)  # y coordinate of each individual

   # (2) Generate abundance data
   # Summarize point pattern per cell: abundance (N) is number of points per cell
   N = abundanceMatrix(cut(u1,breaks;extend=true),cut(u2,breaks,extend=true))

   λ  = round(mean(N);digits = 2)    # lambda: average realized abundance per cell
   σ² = var(N)              # Spatial variance of N

   # (3) Generate occurrence (= presence/absence) data
   # Summarize point pattern even more:
   # occurrence (z) is indicator for abundance greater than 0
   z = copy(N)
   # Convert abundance info to presence/absence info
   for i in 1:length(z)
      if z[i]>0
         z[i]=1
      end
   end

   #  \psi
   ψ = mean(z)              # Realized occupancy in sampled sites

   # Visualization
   if(show_plot)

      bins = Int(sqrt(n_cell))

      #point pattern
      pointPatt = Plots.plot(
         title="Point Pattern\nIntensity = $intensity, M = $M inds.",
         u1,
         u2,
         seriestype=:scatter, 
         xaxis=breaks,yaxis=breaks, gridalpha=1, gridcolor=:red,legend=false
      )

      #abundance pattern
      abundancePatt = Plots.histogram2d(
         title="Abundance pattern: \nRealized mean density =$λ\nSpatial variance =$(round(σ²;digits=2))",
         u1,
         u2,
         bins=bins,fc=:plasma,
         xaxis=breaks,yaxis=breaks, gridalpha=1
      )

      #occurrence pattern
      occurrencePatt = Plots.histogram2d(
         title="Occurrence Pattern\nRealized occupancy = $(round(ψ;digits=2)) ",	
         [a[1]-1 for a in findall(!iszero, N)],
         [a[2]-1 for a in findall(!iszero, N)],
         bins=bins,fc=:black,legend=false,
         xaxis=breaks,yaxis=breaks, gridalpha=1
      )

      #frequency of N
      freqNPlot = Plots.plot(histogram(
         reshape(N.array,length(N.array)), 
         title="Frequency of N \nmean density (red) = $λ",
         xlab = "Abundance (N)", ylab = "Number of cells", legend=false, bins=maximum(N.array)
      ))
      Plots.plot!([λ], seriestype=:vline, color=:red)

      myplot = Plots.plot(pointPatt, abundancePatt, occurrencePatt, freqNPlot, layout=(2,2))

   else
      myplot = nothing
   end
   

   # Numerical output
   return Dict([
      ("quad size",quad_size),
      ("cell size",cell_size),
      ("intensity",intensity),
      ("exp M",exp_M),
      ("breaks",breaks),
      ("number of cells",n_cell),
      ("middle points",mid_pt),
      ("M",M),
      ("x",u1),
      ("y",u2),
      ("N",N),
      ("z",z),
      ("occupancy",ψ),
      ("plot",myplot)
   ])

end #fine funzione sim_fn

