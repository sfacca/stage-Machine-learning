### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 75ebfdf0-4ea6-11eb-2c5d-f9bedb42c513
using Rmath

# ╔═╡ b01c05a0-4eac-11eb-2e3c-d70809635f32
using Plots

# ╔═╡ 7f5f1430-4f69-11eb-11e8-25e8dcc6943f
using StatsBase

# ╔═╡ adc0b49e-4f69-11eb-19e9-15fc780ae2c8
using FreqTables, NamedArrays

# ╔═╡ 6cd5f130-4ea6-11eb-34b4-3d91898ad7bb
#   Applied hierarchical modeling in ecology
#   Modeling distribution, abundance and species richness using R and BUGS
#   Volume 1: Prelude and Static models
#   Marc Kéry & J. Andy Royle
#
# Chapter 4. Introduction to data simulation
# =========================================================================


# 4.2 Generation of a typical point count data set
# ================================================

# 4.2.1 Initial steps: sample size and covariate values
# ------------------------------------------------------------------------
begin 
	M = 267         # Number of spatial replicates (sites)
	J = 3           # Number of temporal replicates (counts)
	elev = runif(M, -1, 1)             # Scaled elevation of a site
	forest = runif(M, -1, 1)           # Scaled forest cover at each site
	wind = reshape(runif(M*J, -1, 1), (M, J)) # Scaled wind speed
end

# ╔═╡ e6ede4a0-4ea6-11eb-291c-c11b91177a44

# 4.2.2 Simulating the ecological process and its outcome: great tit abundance
# ------------------------------------------------------------------------
begin
	mean_lambda = 2
	beta0 = log(mean_lambda)      # Same on log scale (= log-scale intercept)
	beta1 = -2                    # Effect (slope) of elevation
	beta2 = 2                     # Effect (slope) of forest cover
	beta3 = 1                     # Interaction effect (slope) of elev and forest
	log_lambda = [
		(beta1 * elev[i]) + (beta2 * forest[i]) + (beta3 * elev[i] * forest[i]) 
		for i in 1:M
	]
	lambda = exp.(log_lambda)      # Inverse link transformation
end

# ╔═╡ 8c0f5a90-4eac-11eb-18c8-99bf08af1192
begin
	p1 = plot(
		(x)->(exp(beta0 + beta1*x)), -1, 1, xlab = "Elevation", ylab = "lambda"
	)
	p2 = scatter(
		elev, lambda, xlab = "Elevation", ylab = ""
	)
	p3 = plot(
		(x)->(exp(beta0 + beta2*x)), -1, 1, xlab = "Forest cover", ylab = "lambda"
	
	)
	p4 = scatter( 
		forest, lambda, xlab = "Forest cover", ylab = ""
	)
	
	plot(p1, p2, p3, p4)
	
end

# ╔═╡ 332fee20-4ead-11eb-0dd9-e5efcd89b25b
# Compute expected abundance for a grid of elevation and forest cover
begin
	cov1 = collect(-1:(1+1)/99:1)# Values for elevation
	cov2 = deepcopy(cov1)# Values for forest cover
	lambda_matrix = Array{Float64,2}(undef, 100, 100)
	for i in 1:100
		for j in 1:100
			lambda_matrix[i,j] = exp(
				beta0 + beta1 * cov1[i] + beta2 * cov2[j] +
        beta3 * cov1[i] * cov2[j]
			)
		end
	end
end

# ╔═╡ ce413220-4ead-11eb-18ef-0df103d348a9
begin
	heatmap(cov1, cov2, lambda_matrix, xlab = "Elevation", ylab = "Forest cover")
	scatter!(elev, forest, legend = false)
end	

# ╔═╡ 37b1d752-4eae-11eb-0d94-87e07995c8a2
N = [rpois(1,i)[1] for i in lambda] # Realised abundance

# ╔═╡ 3f47fad0-4eae-11eb-36fe-5bd21427e15c
sum(N) # Total population size at M sites

# ╔═╡ 8e078530-4f69-11eb-0348-7fd6ac95aea0
summarystats(N)

# ╔═╡ ba3fa300-4f76-11eb-2872-536bfc5af71b
freqtable(N)

# ╔═╡ f584fa02-4f76-11eb-0745-754802472b51

# 4.2.3 Simulating the observation process and its outcome: point counts of great tits
# ------------------------------------------------------------------------
begin
	mean_detection = 0.3            # Mean expected detection
	alpha0 = qlogis(mean_detection) # same on logit scale (intercept)
	alpha1 = 1                      # Effect (slope) of elevation
	alpha2 = -3                     # Effect (slope) of wind speed
	alpha3 = 0                      # Interaction effect (slope) of elev and wind

	logit_p = reshape([
		 (alpha0 + (alpha1 * elev[(i%M)+1]) + (alpha2 * wind[i+1]) + (alpha3 * elev[(i%M)+1] * wind[i+1]))
		for i in 0:(M*J)-1
	], (M, J))#alpha0 + alpha1 * elev + alpha2 * wind + alpha3 * elev * wind
	p = plogis.(logit_p)             # Inverse link transform

end

# ╔═╡ 0fc17dd0-4f7c-11eb-033c-fdfbe39b6ebe
size(p)

# ╔═╡ 060d78d0-4f7b-11eb-05c2-e1be5ba7f053
size(logit_p)

# ╔═╡ e72f8e30-4f7a-11eb-0eef-0f3656209e4b
wind[2]

# ╔═╡ 4c737670-4f77-11eb-1a91-c597a7682507
mean(p)  

# ╔═╡ 56b5a720-4f77-11eb-1f09-a1065cb5f9e1
begin
	p12 = plot(
		(x)->(plogis(alpha0 + alpha1*x)), -1, 1, xlab = "Elevation", ylab = "p",
		legend=false
	)
	
	p22 = scatter(
		elev, p, xlab = "Elevation", ylab = "", 
		legend=false
	)
	
	p32 = plot(
		(x)->(plogis(alpha0 + alpha2*x)), -1, 1, xlab = "Wind speed", ylab = "p", 
		legend=false	
	)
	
	p42 = scatter(
		wind, p, xlab = "Wind speed", ylab = "p", 
		legend=false	
	)
	
	plot(p12, p22, p32, p42)	
end

# ╔═╡ 8a282a50-4f78-11eb-206e-9f7e20133c77
# Compute expected detection probability for a grid of elevation and wind speed
begin
	p_matrix = Array{Float64,2}(undef, 100, 100)# Prediction matrix which combines every value in cov 1 with every other in cov2
	for i in 1:100
		for j in 1:100
			p_matrix[i,j] = plogis(alpha0 + alpha1 * cov1[i] + alpha2 * cov2[j] + alpha3 * cov1[i] * cov2[j])			
		end
	end
		
	end

# ╔═╡ 041c6920-4f79-11eb-14af-897a4120f9de
begin
	heatmap(cov1, cov2, p_matrix)
	contour!(cov1, cov2, p_matrix)
	scatter!(elev, wind)
end

# ╔═╡ 3ba183d0-4f79-11eb-2431-7fd5fad57a0b
begin
	C = reshape([#rbinom(n = M, size = N, prob = p[,i])
	rbinom(1, N[(i%M)+1], p[i+1])[1] for i in 0:(J*M)-1
], (M, J))
end

# ╔═╡ 549e4692-4f7c-11eb-39bf-c7b8f9a224e8
rbinom(3,1,1)

# ╔═╡ 68c4d080-4f7c-11eb-2cfc-c1e942d27ad4
freqtable(reshape(C, *(size(C)...)))

# ╔═╡ 2ed9e3f0-4f7d-11eb-33c3-6380e5ead078
begin
	local p1 = scatter(
		elev, C, xlab = "Elevation", ylab = "Count (C)"
	)
	
	local p2 = scatter(
		forest, C, xlab = "Forest cover", ylab = "Count (C)"
	)
	
	local p3 = scatter(
		wind, C, xlab = "Wind speed", ylab = "Count (C)"
	)
	
	local p4 = histogram(
		C
	)
	
	plot(p1, p2, p3, p4)
end

# ╔═╡ 83918330-4f7d-11eb-3131-a9536aff099a
sum(N) # True total abundance (all sites)

# ╔═╡ 880f6a30-4f7d-11eb-0c36-59c91f18b86a
sum([ifelse(i>0,1,0) for i in C])

# ╔═╡ Cell order:
# ╠═75ebfdf0-4ea6-11eb-2c5d-f9bedb42c513
# ╠═6cd5f130-4ea6-11eb-34b4-3d91898ad7bb
# ╠═e6ede4a0-4ea6-11eb-291c-c11b91177a44
# ╠═b01c05a0-4eac-11eb-2e3c-d70809635f32
# ╠═8c0f5a90-4eac-11eb-18c8-99bf08af1192
# ╠═332fee20-4ead-11eb-0dd9-e5efcd89b25b
# ╠═ce413220-4ead-11eb-18ef-0df103d348a9
# ╠═37b1d752-4eae-11eb-0d94-87e07995c8a2
# ╠═3f47fad0-4eae-11eb-36fe-5bd21427e15c
# ╠═7f5f1430-4f69-11eb-11e8-25e8dcc6943f
# ╠═8e078530-4f69-11eb-0348-7fd6ac95aea0
# ╠═adc0b49e-4f69-11eb-19e9-15fc780ae2c8
# ╠═ba3fa300-4f76-11eb-2872-536bfc5af71b
# ╠═f584fa02-4f76-11eb-0745-754802472b51
# ╠═0fc17dd0-4f7c-11eb-033c-fdfbe39b6ebe
# ╠═060d78d0-4f7b-11eb-05c2-e1be5ba7f053
# ╠═e72f8e30-4f7a-11eb-0eef-0f3656209e4b
# ╠═4c737670-4f77-11eb-1a91-c597a7682507
# ╠═56b5a720-4f77-11eb-1f09-a1065cb5f9e1
# ╠═8a282a50-4f78-11eb-206e-9f7e20133c77
# ╠═041c6920-4f79-11eb-14af-897a4120f9de
# ╠═3ba183d0-4f79-11eb-2431-7fd5fad57a0b
# ╠═549e4692-4f7c-11eb-39bf-c7b8f9a224e8
# ╠═68c4d080-4f7c-11eb-2cfc-c1e942d27ad4
# ╠═2ed9e3f0-4f7d-11eb-33c3-6380e5ead078
# ╠═83918330-4f7d-11eb-3131-a9536aff099a
# ╠═880f6a30-4f7d-11eb-0c36-59c91f18b86a
