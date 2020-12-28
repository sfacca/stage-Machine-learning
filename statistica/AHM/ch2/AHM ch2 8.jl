### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ c9eb7a90-4931-11eb-34b1-591b2f35e8b3
using Rmath

# ╔═╡ 0511e270-4933-11eb-3c46-abc23da38ec1
using Optim 

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

# ╔═╡ 158624b0-4931-11eb-23d7-51bd2613128e
# 2.8 Assessment of model fit
# ===========================


# 2.8.1 Parametric bootstrapping example
# ------------------------------------------------------------------------

function sim_data(beta0 = -3, beta1 = 2, p = 0.6, x=nothing)
	# Function allows input of covariate "x", or simulates new
	M = 100
	if isnothing(x)
		vegHt = runif(M, 1, 3)
	end
	# Suppose that occupancy probability increases with vegHt
	# The relationship is described (default) by an intercept of -3 and
	#    a slope parameter of 2 on the logit scale
	# plogis is the inverse-logit (constrains us back to the [0-1] scale)
	ψ = [plogis(i) for i in (beta0 .+ beta1 .* vegHt)]
	
	# Now we simulated true presence/absence for 100 sites
	z = [rbinom(1, 1, i)[1] for i in ψ]

	# Now generate observations
	J = 3 # sample each site 3 times
	y = [rbinom(1, J, i)[1] for i in p .* z]

  (y = y,J =  J,vegHt = vegHt)
end

# ╔═╡ c5766d30-4931-11eb-0881-0d9db3c3ab6f
plogis(1)

# ╔═╡ d50d0ebe-4931-11eb-1a74-5f8b712cd5b4
ifelse(false, 1, 2)

# ╔═╡ a612fee0-4931-11eb-230c-07dfc0639ad2
# This is the negative log-likelihood based on the marginal distribution
# of y. It is the pmf of a zero-inflated binomial random variable.
#

function negLogLikeocc(beta, y, x, J)
   beta0 = beta[1]
   beta1 = beta[2]
   p = plogis(beta[3])
   ψ = plogis(beta0 + beta1*x)
   marg_likelihood = dbinom(y, J, p) * ψ + ifelse(y==0, 1, 0) * (1-ψ)
   -sum(log(marg_likelihood))
end


# ╔═╡ f255b360-4931-11eb-1734-43233defa2b8
data = sim_data()        # Generate a data set

# ╔═╡ 7ad8c0b0-4932-11eb-32dd-f54542f6a3ee
# Let's minimize it
starting_values = [0, 0, 0]

# ╔═╡ e1f435d0-4933-11eb-2a3d-bd14ad4ae128
negLogLikeocc(starting_values, data.y, data.vegHt, data.J)

# ╔═╡ 011ed650-4933-11eb-01c6-c91e4979f928
opt_out = optimize(
	(x)->(negLogLikeocc(x, data.y, data.vegHt, data.J)), starting_values
)

# ╔═╡ 15ff4c50-4931-11eb-30eb-ad0d052b6fe9
#=

# Let's minimize it
starting.values <- c(beta0=0, beta1=0, logitp=0)
opt.out <- optim(starting.values, negLogLikeocc, y=data$y, x=data$vegHt,
    J=data$J, hessian=TRUE)
(mles <- opt.out$par)

# Make a table with estimates, SEs, and 95% CI
mle.table <- data.frame(Est=mles,
                        SE = sqrt(diag(solve(opt.out$hessian))))
mle.table$lower <- mle.table$Est - 1.96*mle.table$SE
mle.table$upper <- mle.table$Est + 1.96*mle.table$SE
mle.table


# Define a fit statistic
fitstat <- function(y, Ey){
  sum((sqrt(y) - sqrt(Ey)))
}
# Compute it for the observed data
T.obs <- fitstat(y, J*plogis(mles[1] + mles[2]*vegHt)*plogis(mles[3]))

# Get bootstrap distribution of fit statistic
T.boot <- rep(NA, 100)
for(i in 1:100){
  # Simulate a new data set and extract the elements. Note we use
  # the previously simulated "vegHt" covariate
  data <- sim.data(beta0=mles[1],beta1=mles[2],p=plogis(mles[3]),x=vegHt)
  # Next we fit the model
  starting.values <- c(0,0,0)
  opt.out <- optim(starting.values, negLogLikeocc, y=data$y, x= data$vegHt, J=data$J, hessian=TRUE)
  (parms <- opt.out$par)
  # Obtain the fit statistic
  T.boot[i]<- fitstat(y, J*plogis(parms[1] + parms[2]*vegHt)*plogis(parms[3]) )
}

(T.obs)

summary(T.boot)


=#

# ╔═╡ Cell order:
# ╠═f7299f10-4930-11eb-3978-a9481ab025d7
# ╠═c9eb7a90-4931-11eb-34b1-591b2f35e8b3
# ╠═158624b0-4931-11eb-23d7-51bd2613128e
# ╠═c5766d30-4931-11eb-0881-0d9db3c3ab6f
# ╠═d50d0ebe-4931-11eb-1a74-5f8b712cd5b4
# ╠═a612fee0-4931-11eb-230c-07dfc0639ad2
# ╠═f255b360-4931-11eb-1734-43233defa2b8
# ╠═7ad8c0b0-4932-11eb-32dd-f54542f6a3ee
# ╠═0511e270-4933-11eb-3c46-abc23da38ec1
# ╠═e1f435d0-4933-11eb-2a3d-bd14ad4ae128
# ╠═011ed650-4933-11eb-01c6-c91e4979f928
# ╠═15ff4c50-4931-11eb-30eb-ad0d052b6fe9
