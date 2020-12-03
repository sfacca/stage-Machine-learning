### A Pluto.jl notebook ###
# v0.12.15

using Markdown
using InteractiveUtils

# ╔═╡ f7a04e50-2e58-11eb-37b3-cffa98a875d5
using Rmath, Optim

# ╔═╡ 5e9798a0-30d6-11eb-005b-95de85ee73ca
using NamedArrays, Plots

# ╔═╡ 422a3030-33f4-11eb-0527-a966ea0f1910
using GLM, DataFrames

# ╔═╡ 8207c870-33fe-11eb-29ec-d96ea2479e8e
using LinearAlgebra

# ╔═╡ 3013e7b0-2e59-11eb-0a53-1b101c374842
#   Applied hierarchical modeling in ecology
#   Modeling distribution, abundance and species richness using R and BUGS
#   Volume 1: Prelude and Static models
#   Marc Kéry & J. Andy Royle
#
# Chapter 2. What are hierarchical models and how do we analyze them?
# =========================================================================

# 2.4 Classical inference based on likelihood
# ===========================================

# 2.4.1 The frequentist interpretation (no code)
# 2.4.2 Properties of MLEs (no code)
# 2.4.3 Delta approximation (no code)

# 2.4.4 Example: Classical inference for logistic regression
# ------------------------------------------------------------------------
# Simulate a covariate called vegHt for 100 sites

# ╔═╡ 383bc3e0-2e59-11eb-0f19-7797017090fa
M = 100        # Number of sites surveyed

# ╔═╡ 3d419f90-2e59-11eb-11ab-5f865ae24e9d
vegHt = runif(M, 1, 3) # uniform from 1 to 3

# ╔═╡ 8011b2f2-2e5a-11eb-2c37-cd96c02524b2
# Suppose that occupancy probability increases with vegHt
# The relationship is described by an intercept of -3 and
#    a slope parameter of 2 on the logit scale
β⁰ = -3

# ╔═╡ ac2c70a0-2e5a-11eb-07fd-0b498ddd2921
β¹ = 2

# ╔═╡ ac2c97b0-2e5a-11eb-2a8f-35091c8349e0
ψ = plogis.(β⁰.+β¹*vegHt) # apply inverse logit

# ╔═╡ 482444ee-34ba-11eb-1583-c5c74770651a
plogis(0.1)

# ╔═╡ 26987782-2e5b-11eb-248f-1382d65c6351
# Now we go to 100 sites and observe presence or absence
z = [rbinom(M, 1, i) for i in ψ][1]

# ╔═╡ 34761e6e-2e5b-11eb-230d-5f0169661a3a
# Definition of negative log-likelihood.
function negLogLikeDBINOM(β, y, x)
	ψ = plogis.(β[1].+β[2]*x)
	likelihood = dbinom.(y, 1, ψ)
    return (-sum(log.(likelihood)))
end

# ╔═╡ 11b6baf2-349d-11eb-169b-9d828f167bdd
# Definition of negative log-likelihood.
function negLogLike(β, y, x)
	ψ = plogis.(β[1].+β[2]*x)
	likelihood = ψ.^y .* (1 .- ψ).^(1 .- y)
    return ((-sum(log.(likelihood))))
end

# ╔═╡ 573d34b0-2e5c-11eb-37f5-b5ac9ddeb580
# Look at (negative) log-likelihood for 2 parameter sets
negLogLike([0.0,0.0], z, vegHt)

# ╔═╡ 9aca085e-2e5d-11eb-2bb7-c7e6a7c6f41e
negLogLike([-3.0,2.0], z, vegHt) # Lower is better!

# ╔═╡ c96eb810-34ba-11eb-20de-2384ef21a8b8


# ╔═╡ a9285100-2e5d-11eb-1477-69f5b204fa6e
# Let's minimize it formally by function minimisation
starting_values = [0.0, 0.0]

# ╔═╡ eed94af0-2e63-11eb-184c-7716a5cd1eee
function auxNegLogLike(a)
	negLogLike(a, z, vegHt)
end

# ╔═╡ 1db45780-33fe-11eb-2b9c-95a084577202
func = TwiceDifferentiable(x->auxNegLogLike(x), [1.0,1.0])

# ╔═╡ f8b48e60-2e61-11eb-1e4f-517eda5ff288
opt_out = optimize(func, [0.0,0.0], NelderMead())

# ╔═╡ 0081e6d0-34aa-11eb-3834-3712252a4fdb


# ╔═╡ 2783e6f0-2e71-11eb-3e53-a595a3084f34
mles = opt_out.minimizer # MLEs are pretty close to truth

# ╔═╡ 92493470-34b8-11eb-1a0e-35cc202315f2
negLogLike(mles,z,vegHt)

# ╔═╡ b68fed80-2e71-11eb-10f0-fb7a9f245357
# Alternative 1: Brute-force grid search for MLEs
mat = reshape(collect(Base.product(collect(-10:0.1:10) , collect(-10:0.1:10))),201*201,1)# above: Can vary resolution

# ╔═╡ adba0090-2e7d-11eb-337c-45f3aec503bd
nll = [negLogLike([mat[i]...], z, vegHt) for i in 1:size(mat)[1]]

# ╔═╡ b7a716f0-2e7e-11eb-00bb-5756264de346
minimum(nll)

# ╔═╡ c304c9c0-2e7e-11eb-0f73-c5c82045efd5
mat[argmin(nll)]

# ╔═╡ fd6e3fb2-2e7e-11eb-092f-a327f4ad4b9d
# Produce a likelihood surface, shown in Fig. 2-2.


# ╔═╡ ba936000-33e5-11eb-25a0-37c89fd7b5f6
matr = NamedArray(
	Array{typeof(nll[1]),2}(
		undef,
		length(unique([a[2] for a in mat])),
		length(unique([a[1] for a in mat]))
		),
	(
		unique([a[2] for a in mat]), 
		unique([a[1] for a in mat])
		),
	("Y","X")
)

# ╔═╡ 7bc30d80-33e5-11eb-3ba4-51998e273543
for i in 1:length(mat)
	matr[mat[i][2],mat[i][1]]=nll[i]
end

# ╔═╡ d996fe40-33e9-11eb-3293-b9f717138dae
matr

# ╔═╡ 0a95d770-33ed-11eb-0e60-c70b9f18158a
gr()

# ╔═╡ 585cfe80-33ec-11eb-2414-978569726031
heatmap(
	matr.dicts[1].keys,
	matr.dicts[2].keys,
	matr.array,
	c=[:grey, :yellow, :red], 
	title="Negative log-likelihood",
	xlabel="Intercept (beta0)",
	ylabel="Slope (beta1)")

# ╔═╡ f20b2150-33f2-11eb-39c0-0f8bf6e05614
contour!(matr.dicts[1].keys,matr.dicts[2].keys,matr.array,levels=50:100:2000, linecolor=:black, contour_labels = true)

# ╔═╡ b5fecfc0-34c1-11eb-3103-b19eb5a48fe3
scatter!([-3],[2], legend=false)

# ╔═╡ 45a39f80-33f4-11eb-27ad-7992d5784788
# Alternative 2: Use glm as a shortcut

# ╔═╡ a8a19292-33f4-11eb-20be-f3acb0924c9b
length(z)

# ╔═╡ aadbf230-33f4-11eb-1adf-5f2c6b2ebf78
length(vegHt)

# ╔═╡ 7af22b20-33f4-11eb-2ca7-6f5773a99002
glm_df = DataFrame(z=z,vegHt=vegHt)

# ╔═╡ d04f0080-33f3-11eb-3f7b-49914ecd7b6c
fm = glm(@formula(z ~ vegHt), glm_df, Binomial())

# ╔═╡ b30d4ece-33f5-11eb-2fe5-edab8ebc26a0
md" Add 3 sets of MLEs into plot   
1. Add MLE from function minimisation"

# ╔═╡ b72d5e5e-33f5-11eb-27ec-a99eb622ea09
scatter!(
	[mles[1]], 
	[mles[2]],
	color=:black,
	legend=false
)

# ╔═╡ 4cb3c2c0-33f7-11eb-2c49-d9e43807a870
plot!([-10,10],[mles[2],mles[2]],color=:black)

# ╔═╡ 2bdd6e10-33f8-11eb-38a7-fd09899b6684
plot!([mles[1],mles[1]],[-10,10],color=:black)

# ╔═╡ 690814f0-33fa-11eb-3d0b-09835bd7a9c9
md"
2. Add MLE from grid search
"

# ╔═╡ 6a183750-33f8-11eb-1fbb-e3b15654dd27

scatter!(
	[mat[argmin(nll)][1]],[mat[argmin(nll)][2]],markersize=1,color=:green
)

# ╔═╡ 76dbf7e2-33fa-11eb-38d9-61aa3949d7cf
md"
3. Add MLE from glm function
"

# ╔═╡ 6f2fa9c0-33f9-11eb-2c95-911802794722

scatter!([coef(fm)[1]], [coef(fm)[2]],markersize=1.0,color=:red)


# ╔═╡ 35520af0-34bb-11eb-30a1-3fcd0d737e7b
coef(fm)[1]

# ╔═╡ 3726079e-34bb-11eb-07bd-7939ed6d150d
coef(fm)[2]

# ╔═╡ 3c721410-34bb-11eb-110a-2f6716186c83
mles

# ╔═╡ 43d698ee-33fa-11eb-1b2b-99609807848d
md"
Note they are essentially all the same (as they should be)
"

# ╔═╡ 301977d0-33fd-11eb-1c80-f1a19d5202c1
Vc = inv(Optim.hessian!(func, starting_values))# Get variance-covariance matrix

# ╔═╡ 5053a1a0-33fe-11eb-1b6c-cdc80b7379da
ASE = sqrt.(diag(Vc))# Extract asymptotic SEs

# ╔═╡ b66c6940-33fe-11eb-09ed-d561e2b9c9d6
fm

# ╔═╡ 414b08a0-3495-11eb-16dd-41deffb5677a
md"
Make a table with estimates, SEs, and 95% CI
"

# ╔═╡ 5c8db540-33ff-11eb-2b3a-8bdbbf095416
mle_table = DataFrame(
	Est=mles,
	ASE = ASE
)

# ╔═╡ 58c85eb0-3495-11eb-203d-6f862ce74439
mle_table[:, :lower] = mle_table[:,:Est] - 1.96*mle_table[:,:ASE]

# ╔═╡ a74f84f0-3495-11eb-11ae-91b491e2f71e
mle_table[:, :upper] = mle_table[:,:Est] + 1.96*mle_table[:,:ASE]

# ╔═╡ c0956600-3495-11eb-0e92-797d8df4b37a
mle_table

# ╔═╡ c616da50-3495-11eb-28cb-4f68de8e06f6
md"
 Plot the actual and estimated response curves
"

# ╔═╡ cc9d6290-3495-11eb-1433-f1da26204477
scatter(vegHt, z, xlab="Vegetation height", ylab="Occurrence probability", legend=false)

# ╔═╡ f53c8e10-3495-11eb-0cd0-85e32c5ad13f
plot!(
	(x)->(plogis(β⁰ + β¹ * x)), 1.1, 3, color=:black
)

# ╔═╡ 485140d0-3498-11eb-18d9-e31539175590
plot!(
	(x)->(plogis(mles[1] + (mles[2]*x))), 1.1, 3, color=:blue
)

# ╔═╡ fb2bf7ae-349b-11eb-35f4-4bd134594d0a


# ╔═╡ 352df610-3498-11eb-3558-d9a33909b8bb
mles

# ╔═╡ 29c75b30-2e59-11eb-2abb-1514bd995fd2


# Plot the actual and estimated response curves
plot(vegHt, z, xlab="Vegetation height", ylab="Occurrence probability")
plot(function(x) plogis(beta0 + beta1 * x), 1.1, 3, add=TRUE, lwd=2)
plot(function(x) plogis(mles[1] + mles[2] * x), 1.1, 3, add=TRUE,
     lwd=2, col="blue")
legend(1.1, 0.9, c("Actual", "Estimate"), col=c("black", "blue"), lty=1,
       lwd=2)


# 2.4.5 Bootstrapping
# ------------------------------------------------------------------------
nboot <- 1000   # Obtain 1000 bootstrap samples
boot.out <- matrix(NA, nrow=nboot, ncol=3)
dimnames(boot.out) <- list(NULL, c("beta0", "beta1", "psi.bar"))

for(i in 1:1000){
   # Simulate data
   psi <- plogis(mles[1] + mles[2] * vegHt)
   z <- rbinom(M, 1, psi)

   # Fit model
   tmp <- optim(mles, negLogLike, y=z, x=vegHt, hessian=TRUE)$par
   psi.mean <- plogis(tmp[1] + tmp[2] * mean(vegHt))
   boot.out[i,] <- c(tmp, psi.mean)
}

SE.boot <- sqrt(apply(boot.out, 2, var))  # Get bootstrap SE
names(SE.boot) <- c("beta0", "beta1", "psi.bar")

# 95% bootstrapped confidence intervals
apply(boot.out,2,quantile,c(0.025,0.975))

# Boostrap SEs
SE.boot

# Compare these with the ASEs for regression parameters
mle.table


# 2.4.6 Likelihood analysis of hierarchical models (no code)
# ------------------------------------------------------------------------

# 2.4.6.1 Discrete random variable
# ------------------------------------------------------------------------
set.seed(2014)
M <- 100                             # number of sites
vegHt <- runif(M, 1, 3)              # uniform from 1 to 3
psi <- plogis(beta0 + beta1 * vegHt) # occupancy probability
z <- rbinom(M, 1, psi)               # realised presence/absence
p <- 0.6                             # detection probability
J <- 3                               # sample each site 3 times
y <-rbinom(M, J, p*z)                # observed detection frequency

# Define negative log-likelihood.
negLogLikeocc <- function(beta, y, x, J) {
    beta0 <- beta[1]
    beta1 <- beta[2]
    p <- plogis(beta[3])
    psi <- plogis(beta0 + beta1*x)
    marg.likelihood <- dbinom(y, J, p)*psi + ifelse(y==0,1,0)*(1-psi)
    return(-sum(log(marg.likelihood)))
}

starting.values <- c(beta0=0, beta1=0,logitp=0)
(opt.out <- optim(starting.values, negLogLikeocc, y=y, x=vegHt,J=J,
                 hessian=TRUE))

sqrt(diag(solve(opt.out$hessian)))


# 2.4.6.2 A continuous latent variable
# ------------------------------------------------------------------------
# ~~~~ Following code not executable as is: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# marg <- rep(NA, J+1)
# for(j in 0:J){
# marg[j] <- integrate(
   # function(x){
      # dbinom(j, J, plogis(x)) * dnorm(x, mu, sigma)},
      # lower=-Inf,upper=Inf)$value
   # }
# }
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# nx = encounter frequencies, number inds. encountered 1, 2, ..., 14 times
nx <- c(34, 16, 10, 4, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0)
nind <- sum(nx)      # Number of individuals observed
J <- 14              # Number of sample occasions

# Model Mh likelihood
Mhlik <- function(parms){
   mu <- parms[1]
   sigma <- exp(parms[2])
   # n0 = number of UNobserved individuals: N = nind + n0
   n0 <- exp(parms[3])

  # Compute the marginal probabilities for each possible value j=0,..,14
   marg <- rep(NA,J+1)
   for(j in 0:J){
      marg[j+1] <- integrate(
      function(x){dbinom(j, J, plogis(x)) * dnorm(x, mu, sigma)},
       lower=-Inf,upper=Inf)$value
   }

  # The negative log likelihood involves combinatorial terms computed
  # using lgamma()
  -1*(lgamma(n0 + nind + 1) - lgamma(n0 + 1) + sum(c(n0, nx) * log(marg)))
}
(tmp <- nlm(Mhlik, c(-1, 0, log(10)), hessian=TRUE))


(SE <- sqrt( (exp(tmp$estimate[3])^2)* diag(solve(tmp$hessian))[3] ) )


# 2.4.7 The R package ‘unmarked’ (no code)
# ------------------------------------------------------------------------


# ╔═╡ Cell order:
# ╠═f7a04e50-2e58-11eb-37b3-cffa98a875d5
# ╠═3013e7b0-2e59-11eb-0a53-1b101c374842
# ╠═383bc3e0-2e59-11eb-0f19-7797017090fa
# ╠═3d419f90-2e59-11eb-11ab-5f865ae24e9d
# ╠═8011b2f2-2e5a-11eb-2c37-cd96c02524b2
# ╠═ac2c70a0-2e5a-11eb-07fd-0b498ddd2921
# ╠═ac2c97b0-2e5a-11eb-2a8f-35091c8349e0
# ╠═482444ee-34ba-11eb-1583-c5c74770651a
# ╠═26987782-2e5b-11eb-248f-1382d65c6351
# ╠═34761e6e-2e5b-11eb-230d-5f0169661a3a
# ╠═11b6baf2-349d-11eb-169b-9d828f167bdd
# ╠═573d34b0-2e5c-11eb-37f5-b5ac9ddeb580
# ╠═9aca085e-2e5d-11eb-2bb7-c7e6a7c6f41e
# ╠═c96eb810-34ba-11eb-20de-2384ef21a8b8
# ╠═a9285100-2e5d-11eb-1477-69f5b204fa6e
# ╠═eed94af0-2e63-11eb-184c-7716a5cd1eee
# ╠═1db45780-33fe-11eb-2b9c-95a084577202
# ╠═f8b48e60-2e61-11eb-1e4f-517eda5ff288
# ╠═92493470-34b8-11eb-1a0e-35cc202315f2
# ╠═0081e6d0-34aa-11eb-3834-3712252a4fdb
# ╠═2783e6f0-2e71-11eb-3e53-a595a3084f34
# ╠═b68fed80-2e71-11eb-10f0-fb7a9f245357
# ╠═adba0090-2e7d-11eb-337c-45f3aec503bd
# ╠═b7a716f0-2e7e-11eb-00bb-5756264de346
# ╠═c304c9c0-2e7e-11eb-0f73-c5c82045efd5
# ╠═fd6e3fb2-2e7e-11eb-092f-a327f4ad4b9d
# ╠═5e9798a0-30d6-11eb-005b-95de85ee73ca
# ╠═ba936000-33e5-11eb-25a0-37c89fd7b5f6
# ╠═7bc30d80-33e5-11eb-3ba4-51998e273543
# ╠═d996fe40-33e9-11eb-3293-b9f717138dae
# ╠═0a95d770-33ed-11eb-0e60-c70b9f18158a
# ╠═585cfe80-33ec-11eb-2414-978569726031
# ╠═f20b2150-33f2-11eb-39c0-0f8bf6e05614
# ╠═b5fecfc0-34c1-11eb-3103-b19eb5a48fe3
# ╠═45a39f80-33f4-11eb-27ad-7992d5784788
# ╠═422a3030-33f4-11eb-0527-a966ea0f1910
# ╠═a8a19292-33f4-11eb-20be-f3acb0924c9b
# ╠═aadbf230-33f4-11eb-1adf-5f2c6b2ebf78
# ╠═7af22b20-33f4-11eb-2ca7-6f5773a99002
# ╠═d04f0080-33f3-11eb-3f7b-49914ecd7b6c
# ╠═b30d4ece-33f5-11eb-2fe5-edab8ebc26a0
# ╠═b72d5e5e-33f5-11eb-27ec-a99eb622ea09
# ╠═4cb3c2c0-33f7-11eb-2c49-d9e43807a870
# ╠═2bdd6e10-33f8-11eb-38a7-fd09899b6684
# ╟─690814f0-33fa-11eb-3d0b-09835bd7a9c9
# ╠═6a183750-33f8-11eb-1fbb-e3b15654dd27
# ╟─76dbf7e2-33fa-11eb-38d9-61aa3949d7cf
# ╠═6f2fa9c0-33f9-11eb-2c95-911802794722
# ╠═35520af0-34bb-11eb-30a1-3fcd0d737e7b
# ╠═3726079e-34bb-11eb-07bd-7939ed6d150d
# ╠═3c721410-34bb-11eb-110a-2f6716186c83
# ╟─43d698ee-33fa-11eb-1b2b-99609807848d
# ╠═301977d0-33fd-11eb-1c80-f1a19d5202c1
# ╠═8207c870-33fe-11eb-29ec-d96ea2479e8e
# ╠═5053a1a0-33fe-11eb-1b6c-cdc80b7379da
# ╠═b66c6940-33fe-11eb-09ed-d561e2b9c9d6
# ╟─414b08a0-3495-11eb-16dd-41deffb5677a
# ╠═5c8db540-33ff-11eb-2b3a-8bdbbf095416
# ╠═58c85eb0-3495-11eb-203d-6f862ce74439
# ╠═a74f84f0-3495-11eb-11ae-91b491e2f71e
# ╠═c0956600-3495-11eb-0e92-797d8df4b37a
# ╟─c616da50-3495-11eb-28cb-4f68de8e06f6
# ╠═cc9d6290-3495-11eb-1433-f1da26204477
# ╠═f53c8e10-3495-11eb-0cd0-85e32c5ad13f
# ╠═485140d0-3498-11eb-18d9-e31539175590
# ╠═fb2bf7ae-349b-11eb-35f4-4bd134594d0a
# ╠═352df610-3498-11eb-3558-d9a33909b8bb
# ╠═29c75b30-2e59-11eb-2abb-1514bd995fd2
