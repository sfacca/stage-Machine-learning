### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 2bf8b250-5104-11eb-3c70-9d786ff49228
using StatsBase

# ╔═╡ aec4a640-510d-11eb-366d-a5c6d6700677
using Plots

# ╔═╡ 1288cf80-510e-11eb-15eb-037d031695a3
using CSV, Turing, Rmath

# ╔═╡ a1b9b040-511b-11eb-38a7-a5fd8e2468e3
using Optim

# ╔═╡ 58f99630-5144-11eb-057a-e354bee56cf9
using Pkg

# ╔═╡ 5ffc7a60-5144-11eb-208e-53157e95399e
using BAT

# ╔═╡ 7b1456d0-5048-11eb-1190-5128552c6d30
#   Applied hierarchical modeling in ecology
#   Modeling distribution, abundance and species richness using R and BUGS
#   Volume 1: Prelude and Static models
#   Marc Kéry & J. Andy Royle
#
# Chapter 5. Fitting models using the Bayesian modeling software BUGS and JAGS
# =========================================================================
include("../functions/data_fn.jl")
# 5.3 Linear model with normal response (normal GLM): multiple linear regression
# ==============================================================================

# ╔═╡ 9b4b09b0-5103-11eb-0b7c-77cc850f54bd
# Generate data with data.fn from chapter 4
data = data_fn()

# ╔═╡ 30f05d30-5104-11eb-0ff8-7302a50e87c1

# Summarize data by taking mean at each site and plot
Cmean = [mean(data.C[i,:]) for i in 1:data.M]

# ╔═╡ 9645beb0-510d-11eb-2abf-5b760a0dda13
plot(histogram(Cmean,legend=false), scatter(data.elev, Cmean, legend=false), scatter(data.forest, Cmean, legend=false))

# ╔═╡ f4b61350-510d-11eb-371a-53b2834954ce
# Package the data needed in a bundle
win_data = (Cmean = Cmean, M = length(Cmean), elev = data.elev, forest = data.forest)

# ╔═╡ 4f2440a0-510e-11eb-0be7-41dc4dddbf18
@model function multiple_linear_regression_model(alpha0, alpha1, alpha2, alpha3)
	alpha0 ~ Normal(0, 1.0*10^(-6)) # Prior for intercept
	alpha1 ~ Normal(0, 1.0*10^(-6)) # Prior for slope of elev
	alpha2 ~ Normal(0, 1.0*10^(-6)) # Prior for slope of forest
	alpha3 ~ Normal(0, 1.0*10^(-6)) # Prior for slope of interaction
	
	tau ~ sd^-2  # Precision tau = 1/(sd^2)
	sd ~ Uniform(0, 1000) # Prior for dispersion on sd scale
	
	# likelihood
	for i in 1:win_data.M
		Cmean[i] ~ Normal(mu[i], tau) # dispersion tau is precision (1/variance)
		mu[i] = alpha0 + alpha1*win_data.elev[i] + alpha2*win_data.forest[i] + alpha3*win_data.elev[i]*win_data.forest[i]
	end
	
	 # Derived quantities
	for i in 1:win_data.M
		resi[i] ~ Cmean[i] - mu[i]
	end
end

# ╔═╡ 798b3c60-5125-11eb-1dc8-f7cc97071d15
exp(2, -2)

# ╔═╡ 445b4830-5118-11eb-1160-d39c3bd912dd
#=

# Write text file with model description in BUGS language
cat(file = "multiple_linear_regression_model.txt",
"   # --- Code in BUGS language starts with this quotation mark ---
model {

  # Priors
  alpha0 ~ dnorm(0, 1.0E-06)           # Prior for intercept
  alpha1 ~ dnorm(0, 1.0E-06)           # Prior for slope of elev
  alpha2 ~ dnorm(0, 1.0E-06)           # Prior for slope of forest
  alpha3 ~ dnorm(0, 1.0E-06)           # Prior for slope of interaction
  tau <- pow(sd, -2)                   # Precision tau = 1/(sd^2)
  sd ~ dunif(0, 1000)                  # Prior for dispersion on sd scale

  # Likelihood
  for (i in 1:M){
    Cmean[i] ~ dnorm(mu[i], tau)      # dispersion tau is precision (1/variance)
    mu[i] <- alpha0 + alpha1*elev[i] + alpha2*forest[i] + alpha3*elev[i]*forest[i]
  }

  # Derived quantities
  for (i in 1:M){
    resi[i] <- Cmean[i] - mu[i]
  }
}"#  --- Code in BUGS language ends on this line ---
)
=#

# ╔═╡ 648f8920-511a-11eb-13e7-89650b0b8f98
# Initial values (have to give for at least some estimands)
function inits()
	[rnorm(1,0,10)[1], rnorm(1,0,10)[1],
    rnorm(1,0,10)[1], rnorm(1,0,10)[1]]
end

# ╔═╡ 5b4e26a2-511a-11eb-28aa-89774b71d68c
# Parameters monitored (i.e., for which estimates are saved)
params = ["alpha0", "alpha1", "alpha2", "alpha3", "sd", "resi"]

# ╔═╡ 9a922280-511a-11eb-356a-692cc392fb68
# MCMC settings
begin
	ni = 6000
	nt = 1
	nb = 1000
	nc = 3
end

# ╔═╡ 5c25cfe0-5144-11eb-061c-3549d18e327a
Pkg.add("BAT")

# ╔═╡ 21082fb0-5145-11eb-1d52-19e260d07c7e


# ╔═╡ 45c24ae0-511b-11eb-223a-3dd74e16cbab
model = multiple_linear_regression_model(inits())

# ╔═╡ 96746dce-5123-11eb-324c-6979409a2ffc
optimize(model, MLE())

# ╔═╡ b89c9b10-511b-11eb-15dd-afa4b4374c38
# Generate a MLE estimate.
mle_estimate = optimize(model, MLE())


# ╔═╡ 9cb53d82-5102-11eb-0e85-d98ab46f70b2
#=



# Call WinBUGS from R (approximate run time (ART) <1 min)
library(R2WinBUGS)
bugs.dir <- "C:/WinBUGS14/"          # Place where your WinBUGS installed
out1B <- bugs(win.data, inits, params, "multiple_linear_regression_model.txt",
  n.chains = nc, n.thin = nt, n.iter = ni, n.burnin = nb,
  # debug = TRUE, bugs.directory = bugs.dir, working.directory = getwd())
  debug = FALSE, bugs.directory = bugs.dir) # ~~~~~ for autotesting


# Overview of the object created by bugs
names(out1B)
str(out1B, 1)


# Call OpenBUGS from R (ART <1 min)
library(R2OpenBUGS)
out1OB <- bugs(data=win.data, inits=inits, parameters.to.save = params,
    model.file = "multiple_linear_regression_model.txt",
    n.chains = nc, n.thin = nt, n.iter = ni, n.burnin = nb,
    # debug = TRUE, working.directory = getwd())
    debug = FALSE) # ~~~~~ for autotesting
detach("package:R2OpenBUGS", unload=TRUE)  # Otherwise R2WinBUGS is 'masked'


# Call JAGS from R (ART <1 min)
library(jagsUI)
?jags                 # Look at main function
out1J <- jags(win.data, inits, params, "multiple_linear_regression_model.txt",
    n.chains = nc, n.thin = nt, n.iter = ni, n.burnin = nb)

out1J <- jags(win.data, inits, params, parallel = TRUE,
    "multiple_linear_regression_model.txt", n.chains = nc,
    n.thin = nt, n.iter = ni, n.burnin = nb)


op <- par(mfrow = c(3,2))
traceplot(out1J, param = c('alpha1', 'alpha2', 'resi[c(1,3, 5:6)]')) # Subset
# traceplot(out1J)                  # All params
par(op)

# Overview of object created by jags()
names(out1J)

# Summarize posteriors from WinBUGS run
print(out1B, 2)

# Summarize posteriors from JAGS run
print(out1J, 2)

n <- 10                   # maximum lag
op <- par(mfrow = c(2, 3), mar = c(5,4,2,2), cex.main = 1)
for(k in 1:5){
  matplot(0:n, autocorr.diag(as.mcmc(out1B$sims.array[,,k]), lags = 0:n),
      type = "l", lty = 1, xlab = "lag (n)", ylab = "autocorrelation",
      main = colnames(out1B$sims.matrix)[k], lwd = 2)
  abline(h = 0)
}

# plot(out1B)              # For WinBUGS analysis from R2WinBUGS
plot(out1J)              # For JAGS analysis from jagsUI
par(op)

op <- par(mfrow = c(1, 2), mar = c(5,4,2,2), cex.main = 1)
whiskerplot(out1J, param = c('alpha0', 'alpha1', 'alpha2', 'alpha3', 'sd',
    'resi[c(1,3, 5:7)]'))    # For JAGS analysis from jagsUI
library(denstrip)      # Similar, but more beautiful, with package denstrip
plot(out1J$alpha0, xlim=c(-4, 4), ylim=c(1, 5), xlab="", ylab="", type="n",
    axes = FALSE, main = "Density strip plots")
axis(1)
axis(2, at = 1:5, labels = c('alpha0','alpha1','alpha2','alpha3','sd'), las = 1)
abline(v = c(-4,-2,2,4), col = "grey")  ;  abline(v = 0)
for(k in 1:5){
   denstrip(unlist(out1J$sims.list[k]), at = k, ticks = out1J$summary[k, c(3,5,7)])
}
par(op)

(fm <- summary(lm(Cmean ~ elev*forest)))


print(cbind(out1B$summary[1:5, 1:2], out1J$summary[1:5, 1:2],
    rbind(fm$coef[,1:2], c(fm$sigma, NA))), 4)

plot(lm(Cmean ~ elev*forest))

# Compute the posterior mean of mu
mu <- out1B$mean$alpha0 + out1B$mean$alpha1 * elev +
    out1B$mean$alpha2 * forest + out1B$mean$alpha3 * elev * forest

op <- par(mfrow = c(2, 2), mar = c(5,4,2,2), cex.main = 1)
plot(1:M, out1B$summary[6:272, 1], xlab = "Order of values",
    ylab = "Residual", frame.plot = FALSE, ylim = c(-10, 15))
abline(h = 0, col = "red", lwd = 2)
segments(1:267, out1B$summary[6:272, 3], 1:267, out1B$summary[6:272, 7], col = "grey")
text(10, 14, "A", cex = 1.5)
hist(out1B$summary[6:272, 1], xlab = "Residual", main = "", breaks = 50,
    col = "grey", xlim = c(-10, 15))
abline(v = 0, col = "red", lwd = 2)
text(-9, 48, "B", cex = 1.5)
qq <- qnorm(seq(0,0.9999,,data$M), mean = 0, sd = out1B$summary[5, 1])
plot(sort(qq), sort(out1B$summary[6:272, 1]), xlab = "Theoretical quantile",
    ylab = "Residual", frame.plot = FALSE, ylim = c(-10, 15)) # could also use qqnorm()
abline(0, 1, col = "red", lwd = 2)
text(-4.5, 14, "C", cex = 1.5)
plot(mu, out1B$summary[6:272, 1], xlab = "Predicted values",
    ylab = "Residual", frame.plot = FALSE, ylim = c(-10, 15))
abline(h = 0, col = "red", lwd = 2)
segments(mu, out1B$summary[6:272, 3], mu, out1B$summary[6:272, 7], col = "grey")
text(-1, 14, "D", cex = 1.5)
par(op)

fm

confint(lm(Cmean ~ elev*forest))

op <- par(mfrow = c(2, 2), mar = c(5,4,2,2), cex.main = 1)
hist(out1B$sims.list$alpha1, main = "", breaks = 100, col = "grey", freq=FALSE)
abline(v = quantile(out1B$sims.list$alpha1, prob = c(0.025, 0.975)), col = "red", lwd = 2)
text(-2.4, 1.8, "A", cex = 1.5)
hist(out1B$sims.list$alpha2, main = "", breaks = 100, col = "grey", freq=FALSE)
abline(v = quantile(out1B$sims.list$alpha2, prob = c(0.025, 0.975)), col = "red", lwd = 2)
text(1.7, 2, "B", cex = 1.5)
hist(out1B$sims.list$alpha3, main = "", breaks = 100, col = "grey", freq=FALSE)
abline(v = quantile(out1B$sims.list$alpha3, prob = c(0.025, 0.975)), col = "red", lwd = 2)
text(-2.2, 1.2, "C", cex = 1.5)
hist(out1B$sims.list$sd, main = "", breaks = 100, col = "grey", freq=FALSE)
abline(v = quantile(out1B$sims.list$sd, prob = c(0.025, 0.975)), col = "red", lwd = 2)
text(1.6, 4.9, "D", cex = 1.5)
par(op)

HPDinterval(as.mcmc(out1B$sims.list$sd), prob = 0.95)  # HPDI
quantile(out1B$sims.list$sd, prob = c(0.025, 0.975))   # Percentile-based CRI


cbind(confint(lm(Cmean ~ elev*forest))[2:4,], out1B$summary[2:4, c(3,7)])

mean(out1B$sims.list$alpha1 < -1.6)
mean(out1B$sims.list$alpha1 < -1.6 & out1B$sims.list$alpha1 > -1.8)

plot(out1B$sims.list$alpha1, out1B$sims.list$alpha2)
abline(h = c(2.5, 2.8), col = "red", lwd = 2)
abline(v = c(-1.9, -1.6), col = "red", lwd = 2)


mean(out1B$sims.list$alpha1 < -1.6 & out1B$sims.list$alpha1 > -1.9 &
    out1B$sims.list$alpha2 > 2.5 & out1B$sims.list$alpha2 < 2.8)

crazy.ratio <- out1B$sims.list$alpha2 / abs(out1B$sims.list$alpha1)
hist(crazy.ratio, main = "", breaks = 100, col = "grey", freq = FALSE)
abline(v = quantile(crazy.ratio, prob = c(0.025, 0.975)), col = "red", lwd = 3)


mean(abs(out1B$sims.list$alpha2 / out1B$sims.list$alpha1) > 1)


# Compute expected abundance for a grid of elevation and forest cover
elev.pred <- seq(-1, 1,,100)                       # Values of elevation
forest.pred <- seq(-1,1,,100)                      # Values of forest cover
pred.matrix <- array(NA, dim = c(100, 100)) # Prediction matrix
for(i in 1:100){
  for(j in 1:100){
    pred.matrix[i, j] <- out1J$mean$alpha0 + out1J$mean$alpha1 * elev.pred[i] +
        out1J$mean$alpha2 * forest.pred[j] + out1J$mean$alpha3 * elev.pred[i] * forest.pred[j]
  }
}

op <- par(mfrow = c(1, 3), mar = c(5,5,3,2), cex.main = 1.6, cex.axis = 1.5, cex.lab = 1.5)
mapPalette <- colorRampPalette(c("grey", "yellow", "orange", "red"))
image(x=elev.pred, y= forest.pred, z=pred.matrix, col = mapPalette(100),
    xlab = "Elevation", ylab = "Forest cover")
contour(x=elev.pred, y=forest.pred, z=pred.matrix, add = TRUE, lwd = 1, cex = 1.5)
title(main = "A")
matpoints(elev, forest, pch="+", cex=1.5)
abline(h = c(-1, -0.5, 0, 0.5, 1))

# Predictions for elev. at specific values of forest cover (-1,-0.5,0,0.5,1)
pred1 <- out1J$mean$alpha0 + out1J$mean$alpha1 * elev.pred +
    out1J$mean$alpha2 * (-1) + out1J$mean$alpha3 * elev.pred * (-1)
pred2 <- out1J$mean$alpha0 + out1J$mean$alpha1 * elev.pred +
    out1J$mean$alpha2 * (-0.5) + out1J$mean$alpha3 * elev.pred * (-0.5)
pred3 <- out1J$mean$alpha0 + out1J$mean$alpha1 * elev.pred +
    out1J$mean$alpha2 * 0 + out1J$mean$alpha3 * elev.pred * 0
# pred3b <- out1J$mean$alpha0 + out1J$mean$alpha1 * elev.pred   # same
pred4 <- out1J$mean$alpha0 + out1J$mean$alpha1 * elev.pred +
    out1J$mean$alpha2 * 0.5 + out1J$mean$alpha3 * elev.pred * 0.5
pred5 <- out1J$mean$alpha0 + out1J$mean$alpha1 * elev.pred +
    out1J$mean$alpha2 * 1 + out1J$mean$alpha3 * elev.pred * 1
matplot(seq(-1, 1,,100), cbind(pred1, pred2, pred3, pred4, pred5),
    type = "l", lty= 1, col = "blue", ylab = "Prediction of mean count",
    xlab = "Elevation", ylim = c(-1.5, 7), lwd = 2)
title(main = "B")


pred.mat <- array(dim = c(length(elev.pred), length(out1J$sims.list$alpha0)))
for(j in 1:length(out1J$sims.list$alpha0)){
   pred.mat[,j] <- out1J$sims.list$alpha0[j] + out1J$sims.list$alpha1[j] * elev.pred +
      out1J$sims.list$alpha2[j] * 0.5 + out1J$sims.list$alpha3[j] * elev.pred * 0.5
}

CL <- apply(pred.mat, 1, function(x){quantile(x, prob = c(0.025, 0.975))})
plot(seq(-1, 1,,100), pred4, type = "l", lty= 1, col = "blue",
    ylab = "Prediction of mean count at forest = -0.5",
    xlab = "Elevation", las =1, ylim = c(-1.5, 7), lwd = 3)
matlines(seq(-1, 1,,100), t(CL), lty = 1, col = "blue", lwd = 2)
title(main = "C")

pred <- predict(lm(Cmean ~ elev*forest),
    newdata = data.frame(elev = seq(-1, 1,,100), forest = 0.5),
    se.fit = TRUE, interval = "confidence")
lines(seq(-1, 1,,100), pred$fit[,1], lty= 2, col = "red", lwd = 3)
matlines(seq(-1, 1,,100), pred$fit[,2:3], lty = 2, col = "red", lwd = 2)
par(op)

# 5.4 The R package rjags
# =======================

library(rjags)
load.module("glm")     # Careful with that package, see JAGS discussion list
load.module("dic")

# Have to explicitly list the deviance if want samples
params <- c("alpha0", "alpha1", "alpha2", "alpha3", "sd", "deviance")

# Adaptative phase to maximize MCMC efficiency
model <- jags.model(file = "multiple_linear_regression_model.txt",
    data = win.data, inits = inits, n.chains = nc, n.adapt = 1000)

# Burnin
update(model, nb)

# Generate posterior samples
samples <- coda.samples(model = model, variable.names = params,
    n.iter = ni - nb, thin = nt)

# Get the summary statistics for the posterior samples
summfit <- summary(samples)
print(summfit, 2)

# Traceplots and posterior densities
plot(samples[,1:4])

# Compute the Brooks-Gelman-Rubin statistic (R-hat)
gelman.diag(samples)

# Compute the effective sample size
effectiveSize(samples)


# Secondary burnin can be applied (e.g. another 500 samples tossed out)
#samples <- window(samples, start = nb + 500 + 1, end = ni)

# More samples can be drawn (starting where the old chains stopped, not starting from 0)
newsamples <- coda.samples(model = model, variable.names = params,
    n.iter = 1500, thin = nt)

# Combine the new samples with the old ones (ugly but works)
mc1 <- as.mcmc(rbind(samples[[1]], newsamples[[1]]))
mc2 <- as.mcmc(rbind(samples[[2]], newsamples[[2]]))
mc3 <- as.mcmc(rbind(samples[[3]], newsamples[[3]]))
allsamples <- as.mcmc.list(list(mc1, mc2, mc3))

# Mean deviance
Dbar <- summfit$statistics["deviance","Mean"]

# Variance of the deviance
varD <- summfit$statistics["deviance","SD"]^2

# Compute pD and DIC (according to A. Gelman, implemented in R2jags)
pD <- varD/2
DIC <- Dbar + pD

# Another DIC computation (according to M. Plummer). DIC = Penalized deviance
(dic.pD <- dic.samples(model, 2000, "pD"))

=#

# ╔═╡ Cell order:
# ╠═7b1456d0-5048-11eb-1190-5128552c6d30
# ╠═9b4b09b0-5103-11eb-0b7c-77cc850f54bd
# ╠═2bf8b250-5104-11eb-3c70-9d786ff49228
# ╠═30f05d30-5104-11eb-0ff8-7302a50e87c1
# ╠═aec4a640-510d-11eb-366d-a5c6d6700677
# ╠═9645beb0-510d-11eb-2abf-5b760a0dda13
# ╠═f4b61350-510d-11eb-371a-53b2834954ce
# ╠═1288cf80-510e-11eb-15eb-037d031695a3
# ╠═4f2440a0-510e-11eb-0be7-41dc4dddbf18
# ╠═798b3c60-5125-11eb-1dc8-f7cc97071d15
# ╠═445b4830-5118-11eb-1160-d39c3bd912dd
# ╠═648f8920-511a-11eb-13e7-89650b0b8f98
# ╠═5b4e26a2-511a-11eb-28aa-89774b71d68c
# ╠═9a922280-511a-11eb-356a-692cc392fb68
# ╠═a1b9b040-511b-11eb-38a7-a5fd8e2468e3
# ╠═58f99630-5144-11eb-057a-e354bee56cf9
# ╠═5c25cfe0-5144-11eb-061c-3549d18e327a
# ╠═5ffc7a60-5144-11eb-208e-53157e95399e
# ╠═21082fb0-5145-11eb-1d52-19e260d07c7e
# ╠═45c24ae0-511b-11eb-223a-3dd74e16cbab
# ╠═96746dce-5123-11eb-324c-6979409a2ffc
# ╠═b89c9b10-511b-11eb-15dd-afa4b4374c38
# ╠═9cb53d82-5102-11eb-0e85-d98ab46f70b2
