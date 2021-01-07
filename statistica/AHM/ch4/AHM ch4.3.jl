### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 8f555890-4f82-11eb-3433-e7d19630d983
using Rmath, Statistics, Plots

# ╔═╡ e2092ad0-4f7d-11eb-11c5-59bb33e51532

#   Applied hierarchical modeling in ecology
#   Modeling distribution, abundance and species richness using R and BUGS
#   Volume 1: Prelude and Static models
#   Marc Kéry & J. Andy Royle
# Chapter 4. Introduction to data simulation
# =========================================================================

# 4.3 Packaging everything in a function
# ======================================
# Function definition with set of default values
function data_fn(;
		M = 267, 
		J = 3, 
		mean_lambda = 2, 
		beta1 = -2,
		beta2 = 2, 
		beta3 = 1, 
		mean_detection = 0.3, 
		alpha1 = 1, 
		alpha2 = -3,
		alpha3 = 0, 
		show_plot = true
	)
	#
	# Function to simulate point counts replicated at M sites during J occasions.
	# Population closure is assumed for each site.
	# Expected abundance may be affected by elevation (elev),
	# forest cover (forest) and their interaction.
	# Expected detection probability may be affected by elevation,
	# wind speed (wind) and their interaction.
	# Function arguments:
	#     M: Number of spatial replicates (sites)
	#     J: Number of temporal replicates (occasions)
	#     mean.lambda: Mean abundance at value 0 of abundance covariates
	#     beta1: Main effect of elevation on abundance
	#     beta2: Main effect of forest cover on abundance
	#     beta3: Interaction effect on abundance of elevation and forest cover
	#     mean.detection: Mean detection prob. at value 0 of detection covariates
	#     alpha1: Main effect of elevation on detection probability
	#     alpha2: Main effect of wind speed on detection probability
	#     alpha3: Interaction effect on detection of elevation and wind speed
	#     show.plot: if TRUE, plots of the data will be displayed;
	#        set to FALSE if you are running simulations.

	# Create covariates
	elev = runif(M, -1, 1)                         # Scaled elevation
	forest = runif(M, -1, 1)                       # Scaled forest cover
	wind = reshape(runif(M*J, -1, 1), (M, J)) 		# Scaled wind speed
		
	# Model for abundance
	beta0 = log(mean_lambda)               # Mean abundance on link scale
	lambda = [
		exp(beta0 + beta1*elev[i] + beta2*forest[i] + beta3*elev[i]*forest[i]) for i in 1:M
	]
	N = [rpois(1, i)[1] for i in lambda]      # Realised abundance
	Ntotal = sum(N) 	# Total abundance (all sites)
	psi_true = mean(filter((x)->(x>0),N)) # True occupancy in sample
	
	
	
	# Model for observations
	alpha0 = qlogis(mean_detection)        # mean detection on link scale
	p = reshape([plogis(alpha0 + alpha1*elev[i%M+1] + alpha2*wind[i+1] + alpha3*elev[i%M+1]*wind[i+1]) for i in 0:M*J-1], (M, J))
	C = reshape([
		rbinom(1, N[i%M+1], p[i+1])[1] for i in 0:M*J-1	
	], (M, J))# Generate counts by survey
	summaxC = sum([maximum(C[i,:]) for i in 1:M])   # Sum of max counts (all sites)
	psi_obs = mean(filter((x)->(x>0),[maximum(C[i,:]) for i in 1:M])) # Observed occupancy in sample
	
	# Plots
	if (show_plot)
		
		pl = [
			plot((x)->(exp(beta0 + beta1*x)), -1, 1, xlab = "Scaled elevation"), 
			scatter(elev, lambda, xlab = "Scaled elevation",legend=false), 
			plot((x)->(exp(beta0 + beta2*x)), -1, 1, xlab = "Scaled forest cover",legend=false), 
			scatter(forest, lambda, xlab = "Scaled forest cover",legend=false)
			]
		
		pl2 = [
			
			plot((x)->(plogis(alpha0 + alpha1*x)), -1, 1, title="Relationship p-elevation \nat average wind speed", xlab = "Scaled elevation",legend=false),
			
			scatter(elev, p, xlab = "Scaled elevation", title = "Relationship p-elevation\n at observed wind speed",legend=false),
			
			plot((x)->(plogis(alpha0 + alpha2*x)), -1, 1, color = "red", title = "Relationship p-wind speed \n at average elevation", xlab = "Scaled wind speed",legend=false),
			
			scatter(wind, p, xlab = "Scaled wind speed", title = "Relationship p-wind speed \nat observed elevation",legend=false),
			
			scatter(elev, C, xlab = "Scaled elevation", title = "Relationship counts and elevation",legend=false),
			
			scatter(forest, C, xlab = "Scaled forest cover", title = "Relationship counts and forest cover",legend=false),
			
			scatter(wind, C, xlab = "Scaled wind speed", title = "Relationship counts and wind speed",legend=false)
			
		]	
		
		plots = [pl, pl2]
	else
		plots = [plot(), plot()]
	end
	
	return (M = M, J = J, mean_lambda = mean_lambda, beta0 = beta0, beta1 = beta1,
    beta2 = beta2, beta3 = beta3, mean_detection = mean_detection, alpha0 = alpha0,
    alpha1 = alpha1, alpha2 = alpha2, alpha3 = alpha3, elev = elev, forest = forest,
    wind = wind, lambda = lambda, N = N, p = p, C = C, Ntotal = Ntotal,
    psi_true = psi_true, summaxC = summaxC, psi_obs = psi_obs, plots = plots)
end
	

	

# ╔═╡ ce4d27a0-502f-11eb-0bc8-e3776e016aff
begin
	simrep = 10000
	NTOTAL = zeros(simrep)
	SUMMAXC = zeros(simrep)
	for i in 1:simrep
		dat = data_fn(show_plot=false)
		NTOTAL[i] = dat.Ntotal
		SUMMAXC[i] = dat.summaxC
	end
	plot(scatter(SUMMAXC[sortperm(NTOTAL)], color="blue", legend=false),
	plot(sort(NTOTAL), ylab = "", xlab = "Simulation", color="red", legend=false))
end

# ╔═╡ Cell order:
# ╠═8f555890-4f82-11eb-3433-e7d19630d983
# ╠═e2092ad0-4f7d-11eb-11c5-59bb33e51532
# ╠═ce4d27a0-502f-11eb-0bc8-e3776e016aff
