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
mid_pt = breaks[length(breaks)] + 0.5 * cell_size # cell mid-points

# Simulate three processes: point process, cell abundance summary and cell occurrence summary
# (1) Generate and plot the mother of everything: point pattern
M = Int(rpois(1, exp_M)[1])         # Realized population size in quadrat is Poisson
u1 = runif(M, 0, quad_size)  # x coordinate of each individual
u2 = runif(M, 0, quad_size)  # y coordinate of each individual

# (2) Generate abundance data
# Summarize point pattern per cell: abundance (N) is number of points per cell
N = cut(breaks,u1,extend=true),cut(breaks,u2,extend=true)

N <- as.matrix(table(cut(u1, breaks=breaks), cut(u2, breaks= breaks)))
#=
c
=#


lambda <- round(mean(N),2)    # lambda: average realized abundance per cell
var <- var(c(N))              # Spatial variance of N

# (3) Generate occurrence (= presence/absence) data
# Summarize point pattern even more:
# occurrence (z) is indicator for abundance greater than 0
z <- N   ;  z[z>1] <- 1     # Convert abundance info to presence/absence info
psi <- mean(z)              # Realized occupancy in sampled sites


# Visualization
if(show.plot){
  op <- par(mfrow = c(2, 2), mar = c(5,5,5,2), cex.lab = 1.5, cex.axis = 1.3, cex.main = 1.3)
  on.exit(par(op))
  tryPlot <- try( {
    # (1) Visualize point pattern
    plot(u1, u2, xlab = "x coord", ylab = "y coord", cex = 1, pch = 16, asp = 1,
       main = paste("Point pattern: \nIntensity =", intensity, ", M =", M, "inds."),
       xlim = c(0, quad_size), ylim = c(0, quad_size), frame = FALSE, col = "red") # plot point pattern
    polygon(c(0, quad_size, quad_size, 0), c(0,0, quad_size, quad_size), lwd = 3,
       col = NA, border = "black")   # add border to grid boundary

    # (2) Visualize abundance pattern
    # Plot gridded point pattern with abundance per cell
    plot(u1, u2, xlab = "x coord", ylab = "y coord", cex = 1, pch = 16, asp = 1,
       main = paste("Abundance pattern: \nRealized mean density =", lambda, "\nSpatial variance =", round(var,2)),
       xlim = c(0, quad_size), ylim = c(0, quad_size), frame = FALSE, col = "red") # plot point pattern
    # Overlay grid onto study area
    for(i in 1:length(breaks)){
       for(j in 1:length(breaks)){
       segments(breaks[i], breaks[j], rev(breaks)[i], breaks[j])
       segments(breaks[i], breaks[j], breaks[i], rev(breaks)[j])
       }
    }
    # Print abundance (N) into each cell

    #ottimizzabile con un singolo for in julia?
    for(i in 1:length(mid_pt)){
      for(j in 1:length(mid_pt)){
       text(mid_pt[i],mid_pt[j],N[i,j],cex =10^(0.8-0.4*log10(n.cell)),col="blue")
      }
    }
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
}

# Numerical output
return(list(quad_size = quad_size, cell_size = cell_size, intensity = intensity, exp.N = exp.M,
   breaks = breaks, n.cell = n.cell, mid_pt = mid_pt, M = M, u1 = u1, u2 = u2, N = N, z = z, psi = psi))
}

end #fine funzione sim_fn



#optim test
using Profile
Profile.init(delay=0.5)
Juno.@profiler sim_fn()