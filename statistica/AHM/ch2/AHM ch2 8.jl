### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ c9eb7a90-4931-11eb-34b1-591b2f35e8b3
using Rmath

# ╔═╡ 0511e270-4933-11eb-3c46-abc23da38ec1
using Optim, NLSolversBase, ForwardDiff

# ╔═╡ c5db2790-49e3-11eb-37c5-9dc2e733642d
using DataFrames

# ╔═╡ fd864400-49e7-11eb-2897-352c3ee751de
using LinearAlgebra # diag

# ╔═╡ f7299f10-4930-11eb-3978-a9481ab025d7
#   Applied hierarchical modeling in ecology
#   Modeling distribution, abundance and species richness using R and BUGS
#   Volume 1: Prelude and Static models
#   Marc Kéry & J. Andy Royle
#
# Chapter 2. What are hierarchical models and how do we analyze them?
# =========================================================================

# ~~~~~~~ This requires results from section 2.4 ~~~~~~~~~~~~~~~~~~~~
include("AHM ch2 4.jl")
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ╔═╡ 1dfe80e2-49ec-11eb-1eb1-817ddfef7a0c
global m_vegHt = vegHt

# ╔═╡ 158624b0-4931-11eb-23d7-51bd2613128e
# 2.8 Assessment of model fit
# ===========================


# 2.8.1 Parametric bootstrapping example
# ------------------------------------------------------------------------

function sim_data(beta0 = -3, beta1 = 2, p = 0.6, x=nothing)
	# Function allows input of covariate "x", or simulates new
	M = 100
	if isnothing(x)
		global n_vegHt = runif(M, 1, 3)
	else
		global n_veght = m_vegHt
	end
	# Suppose that occupancy probability increases with vegHt
	# The relationship is described (default) by an intercept of -3 and
	#    a slope parameter of 2 on the logit scale
	# plogis is the inverse-logit (constrains us back to the [0-1] scale)
	ψ = [plogis(i) for i in (beta0 .+ beta1 .* n_vegHt)]
	
	# Now we simulated true presence/absence for 100 sites
	z = [rbinom(1, 1, i)[1] for i in ψ]

	# Now generate observations
	J = 3 # sample each site 3 times
	y = [rbinom(1, J, i)[1] for i in p .* z]

  (y = y,J =  J,vegHt = n_vegHt)
end

# ╔═╡ a612fee0-4931-11eb-230c-07dfc0639ad2
# This is the negative log-likelihood based on the marginal distribution
# of y. It is the pmf of a zero-inflated binomial random variable.
#

function negLogLikeocc(beta, y, x, J)
   beta0 = beta[1]
   beta1 = beta[2]
   p = plogis(beta[3])
   ψ = plogis.(beta0 .+ beta1*x)
   marg_likelihood = dbinom.(y, J, p) .* ψ + ifelse(y==0, 1, 0) * (1 .- ψ)
   -sum(log.(marg_likelihood))
end


# ╔═╡ f255b360-4931-11eb-1734-43233defa2b8
data = sim_data()        # Generate a data set

# ╔═╡ 7ad8c0b0-4932-11eb-32dd-f54542f6a3ee
# Let's minimize it
starting_values = [0.0, 0.0, 0.0]

# ╔═╡ 354995a0-49e7-11eb-2d9b-d96b63007a73
func = TwiceDifferentiable(
	(x)->(negLogLikeocc(x, data.y, data.vegHt, data.J)), 
	starting_values
)

# ╔═╡ 011ed650-4933-11eb-01c6-c91e4979f928
opt_out = optimize(
	func, starting_values
)

# ╔═╡ a4a235f0-49e3-11eb-3b73-bf2a8db398b2
mles = opt_out.minimizer

# ╔═╡ 8971c520-49f2-11eb-1253-fb809826f180
zz = (x)->(negLogLikeocc(x, data.y, data.vegHt, data.J))

# ╔═╡ 8f2f09f0-49f2-11eb-2236-77e292a62b82
zz(starting_values)

# ╔═╡ a3349e60-49f2-11eb-1b3d-6b910275aa12
zz(mles)

# ╔═╡ 230e8f60-49e4-11eb-192f-0500182dd99c
numerical_hessian = hessian!(func, mles)

# ╔═╡ c271bdd2-49e3-11eb-2b9c-57579cf853e8
# Make a table with estimates, SEs, and 95% CI
begin
	mle_table = DataFrame(
		Est = mles,
		SE = sqrt.(diag(numerical_hessian))		
		)
	mle_table[!, :lower] = mle_table[!, :Est] - 1.96 * mle_table[!, :SE]
	mle_table[!, :upper] = mle_table[!, :Est] + 1.96 * mle_table[!, :SE]
	mle_table
end

# ╔═╡ d2592530-49e8-11eb-39b6-6d83ac0aa657
# Define a fit statistic
function fitstat(y, Ey)
	sum((sqrt.(y) - sqrt.(Ey)))
end


# ╔═╡ f8fad300-49e8-11eb-07d9-594d5fb476d3
# Compute it for the observed data
T_obs = fitstat(
	data.y, 
	data.J .* plogis.(mles[1] .+ mles[2].*data.vegHt) .* plogis(mles[3])
)

# ╔═╡ c373e760-49ea-11eb-1b1e-8d5cbbfde1f2

# Get bootstrap distribution of fit statistic
T_boot = Array{Union{Nothing,Float64},1}(nothing, 100)

# ╔═╡ 58356dc2-49ef-11eb-33b2-25b8d6cff7f1
#ny = [rbinom(1, J, i)[1] for i in p*z]

# ╔═╡ d468b960-49ea-11eb-0005-c1074960a5b5
for i in 1:100
	# Simulate a new data set and extract the elements. Note we use
	# the previously simulated "vegHt" covariate
	new_data = sim_data(
		mles[1],
		mles[2],
		plogis(mles[3]),
		data.vegHt
	)
	# Next we fit the model
  	new_starting_values = zeros(3)
	new_func = TwiceDifferentiable(
		(x)->(negLogLikeocc(x, new_data.y, new_data.vegHt, new_data.J)), 
		new_starting_values
	)
  	new_opt_out = optimize(new_func, new_starting_values)
	new_parms = new_opt_out.minimizer
	# Obtain the fit statistic
	T_boot[i] = fitstat(
		y, 
		J .* plogis.(new_parms[1] .+ new_parms[2].*m_vegHt) .* plogis(new_parms[3])
	)
end

# ╔═╡ 5784d080-49f1-11eb-1213-f7f1f21ebc6f
T_obs

# ╔═╡ 1cb417d0-49f2-11eb-0e57-03c1f0105dd4
function 

# ╔═╡ 5d4e9870-49f1-11eb-2d9c-1f081e8cfd5f
T_boot

# ╔═╡ Cell order:
# ╠═f7299f10-4930-11eb-3978-a9481ab025d7
# ╠═c9eb7a90-4931-11eb-34b1-591b2f35e8b3
# ╠═1dfe80e2-49ec-11eb-1eb1-817ddfef7a0c
# ╠═158624b0-4931-11eb-23d7-51bd2613128e
# ╠═a612fee0-4931-11eb-230c-07dfc0639ad2
# ╠═f255b360-4931-11eb-1734-43233defa2b8
# ╠═7ad8c0b0-4932-11eb-32dd-f54542f6a3ee
# ╠═0511e270-4933-11eb-3c46-abc23da38ec1
# ╠═354995a0-49e7-11eb-2d9b-d96b63007a73
# ╠═011ed650-4933-11eb-01c6-c91e4979f928
# ╠═a4a235f0-49e3-11eb-3b73-bf2a8db398b2
# ╠═8971c520-49f2-11eb-1253-fb809826f180
# ╠═8f2f09f0-49f2-11eb-2236-77e292a62b82
# ╠═a3349e60-49f2-11eb-1b3d-6b910275aa12
# ╠═c5db2790-49e3-11eb-37c5-9dc2e733642d
# ╠═230e8f60-49e4-11eb-192f-0500182dd99c
# ╠═fd864400-49e7-11eb-2897-352c3ee751de
# ╠═c271bdd2-49e3-11eb-2b9c-57579cf853e8
# ╠═d2592530-49e8-11eb-39b6-6d83ac0aa657
# ╠═f8fad300-49e8-11eb-07d9-594d5fb476d3
# ╠═c373e760-49ea-11eb-1b1e-8d5cbbfde1f2
# ╠═58356dc2-49ef-11eb-33b2-25b8d6cff7f1
# ╠═d468b960-49ea-11eb-0005-c1074960a5b5
# ╠═5784d080-49f1-11eb-1213-f7f1f21ebc6f
# ╠═1cb417d0-49f2-11eb-0e57-03c1f0105dd4
# ╠═5d4e9870-49f1-11eb-2d9c-1f081e8cfd5f
