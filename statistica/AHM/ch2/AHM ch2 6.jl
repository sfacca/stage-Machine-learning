### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 07b13360-45db-11eb-18bd-117fba75f242
using Rmath

# ╔═╡ c5404a70-45ee-11eb-01a4-d1e3cbed9979
using Statistics

# ╔═╡ e1e36ad0-45ef-11eb-194e-53933896022e
using Plots

# ╔═╡ 6559c82e-45fc-11eb-3335-0b72269bbb37
using KernelDensity, Distributions

# ╔═╡ 131c2330-4929-11eb-2e13-23c404fe031c
using StatPlots

# ╔═╡ 8cb407b0-45e8-11eb-3da7-d5f640306dee
include("AHM ch2 4.jl")

# ╔═╡ 7a1d6c90-45e8-11eb-378d-65dcc8bb06db


# ╔═╡ 8a193890-45e8-11eb-3ead-c93dad96bec7
#   Applied hierarchical modeling in ecology
#   Modeling distribution, abundance and species richness using R and BUGS
#   Volume 1: Prelude and Static models
#   Marc Kéry & J. Andy Royle
#
# Chapter 2. What are hierarchical models and how do we analyze them?
# =========================================================================

# ~~~~~~~ This requires results from section 2.4 ~~~~~~~~~~~~~~~~~~~~

# ╔═╡ 7fd13b80-45e8-11eb-3eb0-659f44d4a33e
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 2.6 Basic Markov chain Monte Carlo (MCMC)
# =========================================

# 2.6.1 Metropolis-Hastings algorithm (no code)

# 2.6.2 Illustration: using MH for a binomial model
# ------------------------------------------------------------------------
# Simulate data

# ╔═╡ 64881062-45e8-11eb-25bc-5b36bf4cf8c3
y = rbinom(2, 10, 0.5)

# ╔═╡ fa2e4e40-45e8-11eb-276a-81e70a6fd40d
# Define the joint distribution (= likelihood) which we will maximize
function jointdis(data, K, p)
   prod(dbinom.(data, K, p))
end

# ╔═╡ 5f54d130-45ea-11eb-0333-5fc131a9e9ce
# Posterior is proportional to likelihood times prior
function posterior(p, data, K, a, b)
   prod(dbinom.(data, K, p)) * dbeta.(p, a, b)
end

# ╔═╡ 7ec70c90-45ea-11eb-36f6-4de3033e834a
# Do 100,000 MCMC iterations using Metropolis algorithm
# Assume vague prior which is beta(1,1) = Unif(0,1)
mcmc_iters = 100000

# ╔═╡ 9f4d7710-45ea-11eb-0cee-752264ce4b27
out = Array{Float64,1}(undef, mcmc_iters)

# ╔═╡ d5298160-4605-11eb-35b0-e7d7c6dad1e4
# Starting value
p1 = 0.2

# ╔═╡ fbba48a0-45ec-11eb-1df8-4589bca628c1
# Begin the MCMC loop
for i in 1:mcmc_iters
	
   	# Use a uniform candidate generator (not efficient)
   	p_cand = runif(1, 0, 1)

	# Alternative: random walk proposal
	# p.cand <- rnorm(1, p, .05)  # Need to reject if > 1 or < 0
	# if(p.cand < 0 | p.cand > 1 ) next

   	r = posterior(p_cand, y, 10, 1, 1) / posterior(p1, y, 10, 1, 1)
	   # Generate a uniform r.v. and compare with "r", this imposes the
	   #    correct probability of acceptance
	#rs[i] = r[1]
	if (runif(1)[1] < r[1])
			p1 = p_cand[1]
	end

   # Save the current value of p
   out[i] = p1
end

# ╔═╡ c26d2d42-45ee-11eb-0a9e-977c931ae9ed
mean(out)

# ╔═╡ cde40d60-45ee-11eb-049e-a192bf774dd0
std(out)

# ╔═╡ de37bd60-45ee-11eb-3413-0bc2f79dcf19
quantile(out, [0.025, 0.975])

# ╔═╡ eb7839f0-45ee-11eb-1249-711fbefdd5a8
# Evaluate likelihood for a grid of values of p
begin
	p_grid = collect(0.1:(0.9-0.1)/(200-1):0.9)
	likelihood = Array{Float64,1}(undef, 200)
end

# ╔═╡ 6da34910-45ef-11eb-376f-239bc0491636
for i in 1:200
	likelihood[i] = jointdis(y, 10, p_grid[i])
end

# ╔═╡ e544e550-45ef-11eb-3ab6-57acb6484fc9
begin
	plot(
		p_grid,
		likelihood,
		xlab="", ylab="Likelihood", xlim=[0,1], ty = "l", title = "Likelihood function", legend=false
	)
	p_hat = p_grid[argmax(likelihood)]
	plot!([p_hat,p_hat],[0.0,maximum(likelihood)])
end

# ╔═╡ 108022fe-45f1-11eb-3038-cfe7dabba638
md"
MLE = $(round(p_hat, digits=3))

"

# ╔═╡ 57301ff0-4603-11eb-2e9a-31f4ea2c7b26
begin
	kde_out = kde(out)
	plot(collect(kde_out.x), kde_out.density)
	p_mean = mean(out)
	plot!([p_mean,p_mean],[0.0,maximum(kde_out.density)])
end
	

# ╔═╡ 0fca7780-4605-11eb-0a12-81cc97e750eb
md"
Post. mean = $(round(p_mean, digits = 3))
"

# ╔═╡ 71b0c390-4606-11eb-2b71-174ed44b222f
# 2.6.3 Metropolis algorithm for multi-parameter models
# ----------------------------------------------------------------------------------------
function log_posterior(beta0, beta1, z, vegHt)
	# Note: "z" and "vegHt" must be input
   loglike = -1 * negLogLike([beta0, beta1], z, vegHt)
   logprior = dnorm.([beta0, beta1], 0.0, 10.0, true)

   return (loglike + logprior[1] + logprior[2])
end

# ╔═╡ a9aa23de-4606-11eb-1fb4-c1bd6f8b72a2
begin
	niter = 50000
	out2 = Array{Float64,2}(undef, niter, 2)
end

# ╔═╡ f1aff200-4606-11eb-1296-8b97f68385c6
# Initialize parameters
beta0, beta1 = rnorm(2)	

# ╔═╡ 02d745b0-4607-11eb-031b-29cb5640d721
# Current value of the log(posterior)
logpost_curr = log_posterior(beta0, beta1, z, vegHt)

# ╔═╡ 460bb8d0-460b-11eb-0fd1-71906159180c
# Run MCMC algorithm
for i in 1:niter
      # Update intercept (beta0)
      # Propose candidate values of beta
      # If the proposal was not symmetric, would be Metrop-*Hastings*
	beta0_cand = rnorm(1, beta0, 0.3)[1] # 0.3 is tuning parameter
	# Evaluate the log(posterior)
	logpost_cand = log_posterior(beta0_cand, beta1, z, vegHt)
	# Compute Metropolis acceptance probability, r
	r = exp(logpost_cand - logpost_curr)
	# Keep candidate if it meets criterion (u < r)
	if (runif(1)[1] < r)
		beta0 = beta0_cand
		logpost_curr = logpost_cand
	end

	# Update slope (beta1)
	beta1_cand = rnorm(1, beta1, 0.3)[1] # 0.3 is tuning parameter
	# Evaluate the log(posterior)
	logpost_cand = log_posterior(beta0, beta1_cand, z, vegHt)

	# Compute Metropolis acceptance probability
	r = exp(logpost_cand - logpost_curr)
	# Keep candidate if it meets criterion (u < r)
	if (runif(1)[1] < r)
		beta1 = beta1_cand
		logpost_curr = logpost_cand
	end
	
	out2[i,:] = [beta0, beta1] # Save samples for iteration
end

# ╔═╡ a0ff7460-460c-11eb-2273-19f5046fe2cb
#Plot
begin
	
	plot1 = plot(out2[:,1], type="l", xlab="Iteration", ylab="beta0")
	plot2 = plot(out2[:,2], type="l", xlab="Iteration", ylab="beta1")
	
	out_beta0_kde = kde(out2[:,1])
	out_beta1_kde = kde(out2[:,2])
	
	plot3 = plot(
		collect(out_beta0_kde.x), out_beta0_kde.density, xlab="beta0")
	
	plot4 = plot(
		collect(out_beta1_kde.x), out_beta1_kde.density, xlab="beta1")
	
	plot(
		plot1,
		plot2,
		plot3,
		plot4
	)

end

# ╔═╡ 7c91ca50-461c-11eb-3bfb-557cdc476ec9
begin
	# 2.6.7 Bayesian analysis of hierarchical models
	# ------------------------------------------------------------------------

	# The occupancy model
	# '''''''''''''''''''

	# Simulate the data set
	
	bM = 100                        # number of sites
	bvegHt = runif(bM, 1, 3)         # uniform from 1 to 3
	global bpsi = plogis.(-3 .+ 2 .* bvegHt)     # occupancy probability
	bz = [rbinom(1, 1, i)[1] for i in bpsi] # realised presence/absence
	#bz = rbinom.(bM, 1, bpsi)          
	bp = 0.6                        # detection probability
	bJ = 3                          # sample each site 3 times
	by = [rbinom(1, bJ, i)[1] for i in bp*bz]
	#rbinom(bM, bJ, bp*bz)           # observed detection frequency

	# Number of MCMC iterations to to
	bniter = 50000

	# Matrix to hold the simulated values
	bout = Array{Float64,2}(undef, bniter, 3)
	
	bz = [ifelse(i>0, 1, 0) for i in by]
	# Initialize parameters, likelihood, and priors
	bstarting_values = [0, 0]
	global bbeta0 = bstarting_values[1]
	global bbeta1 = bstarting_values[2]
	
	global bp = 0.2
	
	# NOTE: using logistic reg. likelihood function here!
	global loglike = -1 * negLogLike([bbeta0, bbeta1], bz, bvegHt)	
	global logprior = dnorm.([bbeta0, bbeta1], 0, 10, true)
	# Run MCMC algorithm
	for i in 1:bniter
		# PART 1 of algorithm -- same as before
		# Update intercept (beta0)
		# propose candidate values of beta
		bbeta0_cand = rnorm(1, bbeta0, 0.3)[1] # 0.3 is tuning parameter
		# evaluate likelihood and priors for candidates
		bloglike_cand = -1 * negLogLike([bbeta0_cand, bbeta1], bz, bvegHt)
		blogprior_cand = dnorm(bbeta0_cand, 0, 10, true)
		# Compute Metropolis acceptance probability (r)
		br = exp((bloglike_cand+blogprior_cand) - (loglike + logprior[1]))
		# Keep candidate if it meets the criterion

		if runif(1)[1] < br
			global bbeta0 = bbeta0_cand
			global loglike = bloglike_cand
			global logprior[1] = blogprior_cand
		end

		# Update slope (beta1)
		bbeta1_cand = rnorm(1, bbeta1, 0.3)[1] # 0.3 is tuning parameter
		# evaluate likelihood and priors for candidates
		bloglike_cand = - negLogLike([bbeta0,bbeta1_cand], bz, bvegHt)
		blogprior_cand = dnorm(bbeta1_cand, 0, 10, true)
		# Compute Metropolis acceptance probability r
		br = exp((bloglike_cand+blogprior_cand) - (loglike + logprior[2]))
		# Keep the candidates if they meet the criterion

		if runif(1)[1] < br
			global bbeta1 = bbeta1_cand
			global loglike = bloglike_cand
			global logprior[2] = blogprior_cand
		end

		# Part 2 of the algorithm
		# update z. Note we only need to update z if y=0.
		# The full conditional has known form
		
		global bpsi = plogis.(bbeta0 .+ bbeta1 .* bvegHt)
		bpsi_cond = dbinom(0,bJ,bp) .* bpsi /(dbinom(0, bJ, bp) .* bpsi + (1 .- bpsi))
		#println("zeros in by at: $(findall((x)->(x==0),by))")
		bz[findall((x)->(x==0),by)] = [
			rbinom(1, 1, i)[1] for i in bpsi_cond[findall((x)->(x==0),by)]
			]	
		
		loglike = -1 * negLogLike([bbeta0, bbeta1], bz, bvegHt)

		# Part 3: update p
		## The commented code will update p using Metropolis
		## loglike.p <- sum(log(dbinom(y[z==1],J,p)))
		## p.cand <- runif(1, 0, 1)
		## loglike.p.cand <- sum(log(dbinom(y[z==1], J, p.cand)))
		## if(runif(1) < exp(loglike.p.cand-loglike.p))
		##    p<-p.cand
		## This bit draws p directly from its full conditional
		
		global bp = rbeta(1, 1+ sum(by), sum(bz)*bJ +1 - sum(by) )[1]

		# Save MCMC samples
		#=
		println("===========================================")
		println("out row $i : $(out[i,:])")
		println("result of comput: $([bbeta0,bbeta1,bp])")
		println("===========================================")
		=#
		bout[i,:] = [bbeta0,bbeta1,bp]
	end
end

# ╔═╡ 2ba91be0-4926-11eb-171f-8310280d17c7
# Plot bivariate representation of joint posterior

corrplot(bout)

# ╔═╡ Cell order:
# ╠═7a1d6c90-45e8-11eb-378d-65dcc8bb06db
# ╠═07b13360-45db-11eb-18bd-117fba75f242
# ╠═8a193890-45e8-11eb-3ead-c93dad96bec7
# ╠═8cb407b0-45e8-11eb-3da7-d5f640306dee
# ╠═7fd13b80-45e8-11eb-3eb0-659f44d4a33e
# ╠═64881062-45e8-11eb-25bc-5b36bf4cf8c3
# ╠═fa2e4e40-45e8-11eb-276a-81e70a6fd40d
# ╠═5f54d130-45ea-11eb-0333-5fc131a9e9ce
# ╠═7ec70c90-45ea-11eb-36f6-4de3033e834a
# ╠═9f4d7710-45ea-11eb-0cee-752264ce4b27
# ╠═d5298160-4605-11eb-35b0-e7d7c6dad1e4
# ╠═fbba48a0-45ec-11eb-1df8-4589bca628c1
# ╠═c5404a70-45ee-11eb-01a4-d1e3cbed9979
# ╠═c26d2d42-45ee-11eb-0a9e-977c931ae9ed
# ╠═cde40d60-45ee-11eb-049e-a192bf774dd0
# ╠═de37bd60-45ee-11eb-3413-0bc2f79dcf19
# ╠═eb7839f0-45ee-11eb-1249-711fbefdd5a8
# ╠═6da34910-45ef-11eb-376f-239bc0491636
# ╠═e1e36ad0-45ef-11eb-194e-53933896022e
# ╠═e544e550-45ef-11eb-3ab6-57acb6484fc9
# ╟─108022fe-45f1-11eb-3038-cfe7dabba638
# ╠═6559c82e-45fc-11eb-3335-0b72269bbb37
# ╠═57301ff0-4603-11eb-2e9a-31f4ea2c7b26
# ╟─0fca7780-4605-11eb-0a12-81cc97e750eb
# ╠═71b0c390-4606-11eb-2b71-174ed44b222f
# ╠═a9aa23de-4606-11eb-1fb4-c1bd6f8b72a2
# ╠═f1aff200-4606-11eb-1296-8b97f68385c6
# ╠═02d745b0-4607-11eb-031b-29cb5640d721
# ╠═460bb8d0-460b-11eb-0fd1-71906159180c
# ╠═a0ff7460-460c-11eb-2273-19f5046fe2cb
# ╠═7c91ca50-461c-11eb-3bfb-557cdc476ec9
# ╠═131c2330-4929-11eb-2e13-23c404fe031c
# ╠═2ba91be0-4926-11eb-171f-8310280d17c7
