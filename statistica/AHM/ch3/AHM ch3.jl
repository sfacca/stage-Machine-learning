### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ f4844bc0-49f8-11eb-1e81-1193c6324479
using DataFrames, CategoricalArrays, Plots, GLM

# ╔═╡ 3d7c02ae-49f3-11eb-3d83-d93c5c67b7f0
#   Applied hierarchical modeling in ecology
#   Modeling distribution, abundance and species richness using R and BUGS
#   Volume 1: Prelude and Static models
#   Marc Kéry & J. Andy Royle
# Chapter 3 Linear models, generalised linear models (GLMs) and random effects models:
#    the components of hierarchical models
# =========================================================================

# 3.1 Introduction
# ================

# Define data
begin
	pop = CategoricalArray(
		vcat(
			vcat(repeat(["Navarra"], 3), repeat(["Aragon"], 3)), 
			repeat(["Catalonia"], 3) )
		)# Population
	wing = [10.5, 10.6, 11.0, 12.1, 11.7, 13.5, 11.4, 13.0, 12.9]# Wing span
	body = [6.8, 8.3, 9.2, 6.9, 7.7, 8.9, 6.9, 8.2, 9.2] # Body length 
	sex = CategoricalArray(["M","F","M","F","M","F","M","F","M"])
	mites = [0, 3, 2, 1, 0, 7, 0, 9, 6] # Number of ectoparasites
	color = [0.45, 0.47, 0.54, 0.42, 0.54, 0.46, 0.49, 0.42, 0.57] # Color intensity
	damage = [0,2,0,0,4,2,1,0,1]                 # Number of wings damaged
	
end


# ╔═╡ 06c08a82-49fc-11eb-3177-9fef55e3c247
begin
	scatter(body[findall(x->x=="M",sex)], wing[findall(x->x=="M",sex)], color="blue")
	scatter!(body[findall(x->x=="F",sex)], wing[findall(x->x=="F",sex)], color="red", xlab = "Body length", ylab = "Wing span")
end

# ╔═╡ 47c8a48e-49fc-11eb-1d34-f10971aa0601
begin
	scatter(body[findall(x->x=="M",sex)], mites[findall(x->x=="M",sex)], color="blue",
    xlab = "Body length", ylab = "Parasite load")
	scatter!(body[findall(x->x=="F",sex)], mites[findall(x->x=="F",sex)], color="red")
end

# ╔═╡ 6008ae60-49fc-11eb-3631-c78f0553dac7
begin
	scatter(body[findall(x->x=="M",sex)], damage[findall(x->x=="M",sex)], color="blue", xlab = "Body length", ylab = "Damaged wings")
	scatter!(body[findall(x->x=="F",sex)], damage[findall(x->x=="F",sex)], color="red")
end

# ╔═╡ 67659210-49ff-11eb-3a51-93bb33ced33f
data = DataFrame(
	pop = pop,
	wing = wing,
	body = body,
	sex = sex,
	mites = mites,
	color = color,
	damage = damage
)

# ╔═╡ c052a500-49fc-11eb-12e1-ad0fb43b3431
# 3.2 Linear models
# =================

# 3.2.1 Linear models with main effects of one factor and one continuous covariate
# --------------------------------------------------------------------------------
fm1 = lm(@formula(wing ~ pop + body), data)

# ╔═╡ 9e1cfc80-49ff-11eb-1d0d-e718536b8200
fm2 = lm(@formula(wing ~ 0 + pop + body), data)# no intercept

# ╔═╡ ae5f7e60-4a13-11eb-3b60-89f77dddcacd
dump(fm1)

# ╔═╡ f4c647e0-4a26-11eb-39b2-75125641d6fb
predict(fm1)

# ╔═╡ 7617cda0-4a2c-11eb-3724-e7b94f13274f
predict(fm2)

# ╔═╡ fddf88f0-4a26-11eb-2905-991b214ebb2e
wing

# ╔═╡ dd8730f0-49f2-11eb-28d1-cd41eac67b57
#=


# 3.2 Linear models
# =================

# 3.2.1 Linear models with main effects of one factor and one continuous covariate
# --------------------------------------------------------------------------------
summary(fm1 <- lm(wing ~ pop + body))

summary(fm2 <- lm(wing ~ pop-1 + body))

cbind(model.matrix(~pop+body) %*% fm1$coef, predict(fm1)) # Compare two solutions

model.matrix(~ pop + body) # Effects parameterisation

model.matrix(~ pop-1 + body) # Means parameterization

op <- par(mfrow = c(1, 3), mar = c(5,4,2,2), cex = 1.2, cex.main = 1)
plot(body[sex == "M"], wing[sex == "M"], col = colorM, xlim = c(6.5, 9.5),
    ylim = c(10, 14), lwd = 2, frame.plot = FALSE, las = 1, pch = 17,
    xlab = "Body length", ylab = "Wing span")
points(body[sex == "F"], wing[sex == "F"], col = colorF, pch = 16)
abline(coef(fm2)[1], coef(fm2)[4], col = "red", lwd = 2)
abline(coef(fm2)[2], coef(fm2)[4], col = "blue", lwd = 2)
abline(coef(fm2)[3], coef(fm2)[4], col = "green", lwd = 2)
text(6.8, 14, "A", cex = 1.5)


# 3.2.2 Linear models with interaction between one factor and one continuous covariate
# ------------------------------------------------------------------------

model.matrix(~ pop*body)  # Effects parameterisation

model.matrix(~ pop*body-1-body)  # Means parameterisation

summary(fm3 <- lm(wing ~ pop*body-1-body))

# Plot
plot(body[sex == "M"], wing[sex == "M"], col = colorM, xlim = c(6.5, 9.5),
    ylim = c(10, 14), lwd = 2, frame.plot = FALSE, las = 1, pch = 17,
    xlab = "Body length", ylab = "")
points(body[sex == "F"], wing[sex == "F"], col = colorF, pch = 16)
abline(coef(fm3)[1], coef(fm3)[4], col = "red", lwd = 2)
abline(coef(fm3)[2], coef(fm3)[5], col = "blue", lwd = 2)
abline(coef(fm3)[3], coef(fm3)[6], col = "green", lwd = 2)
text(6.8, 14, "B", cex = 1.5)

# Create new design matrix
(DM0 <- model.matrix(~ pop*body-1-body)) # Original DM for means param
DM0[7:9,5] <- DM0[7:9,6]                 # Combine slopes for Ar and Cat
(DM1 <- DM0[, -6])                       # Delete former slope column for Cat

# Fit model with partial interaction
summary(fm4 <- lm(wing ~ DM1-1))

# Do significance test
anova(fm3, fm4)             # F test between two models

# Plot
plot(body[sex == "M"], wing[sex == "M"], col = colorM, xlim = c(6.5, 9.5),
    ylim = c(10, 14), lwd = 2, frame.plot = FALSE, las = 1, pch = 17,
    xlab = "Body length", ylab = "")
points(body[sex == "F"], wing[sex == "F"], col = colorF, pch = 16)
abline(coef(fm4)[1], coef(fm4)[4], col = "red", lwd = 2)
abline(coef(fm4)[2], coef(fm4)[5], col = "blue", lwd = 2)
abline(coef(fm4)[3], coef(fm4)[5], col = "green", lwd = 2)
text(6.8, 14, "C", cex = 1.5)
par(op)

# 3.2.3 Linear models with two factors
# ------------------------------------------------------------------------
model.matrix(~ pop+sex)  # Design matrix of main-effects 2-way ANOVA

# Fit linear model with that design matrix
summary(fm5 <- lm(wing ~ pop + sex))

model.matrix(~ pop+sex-1)  # Design matrix of the main-effects 2-way ANOVA

# Fit linear model with that design matrix
summary(fm6 <- lm(wing ~ pop + sex-1))

# Variant 1: Effects parameterisation (R default)
model.matrix(~ pop*sex)
#model.matrix(~ pop + sex + pop:sex)     # Same

# Variant 2: Means param. for pop, effects param. for sex
model.matrix(~ pop*sex-1)

# Variant 3 (output slightly trimmed): full means parameterisation
model.matrix(~ pop:sex-1)


# 3.2.4 Linear models with two continuous covariates and including polynomials
# ------------------------------------------------------------------------
model.matrix(~ body + color)  # main-effects of covariates

summary(fm7 <- lm(wing ~ body + color))  # Fit that model

model.matrix(~ body*color)  # Interaction between two covariates

summary(fm8 <- lm(wing ~ body*color))  # Fit that model

# Cubic polynomial of body in R
body2 <- body^2           # Squared body length
body3 <- body^3           # Cubed body length
model.matrix(~ body + body2 + body3)

summary(fm9 <- lm(wing ~ body + body2 + body3))  # Fit that model
# summary(fm9 <- lm(wing ~ body + I(body^2) + I(body^3))) # same



# 3.3 Generalised linear models (GLMs)
# ====================================

# 3.3.1 Poisson generalised linear model (GLM) for unbounded counts
# ------------------------------------------------------------------------
summary(fm10 <- glm(mites ~ pop-1 + body, family = poisson))


# 3.3.2 Offsets in the Poisson GLM
# ------------------------------------------------------------------------
summary(fm10a <- glm(mites ~ pop-1 + wing, offset = log(body), family = poisson))
# summary(fm10a <- glm(mites ~ offset(log(body)) + pop-1 + wing, family = poisson))     # same


# 3.3.3 Overdispersion and underdispersion (no code)
# 3.3.4 Zero-inflation (no code)

# 3.3.5 Bernoulli GLM: logistic regression for a binary response
# ------------------------------------------------------------------------
presence <- ifelse(mites > 0, 1, 0)  # convert abundance to presence/absence
summary(fm11 <- glm(presence ~ pop-1 + body, family = binomial))

# 3.3.6 Modeling a Poisson process from presence/absence data using a Bernoulli GLM with cloglog link
# ------------------------------------------------------------------------
summary(fm11a <- glm(presence ~ pop-1 + body, family = binomial(link = "cloglog")))

summary(fm10)

# 3.3.7 Binomial GLM: logistic regression for bounded counts
# -------------------------------------------------------------------------
summary(fm12 <- glm(cbind(damage, 4-damage) ~ pop + body -1, family = binomial))


# 3.3.8 The GLM as the quintessential statistical model (no code)

# 3.4 Random effects (mixed) models
# =================================

# 3.4.1 Random effects for a normal data distribution: normal-normal generalised linear mixed model (GLMM)
# ------------------------------------------------------------------------
# Plot data without distinguishing sex
plot(body, wing, col = rep(c("red", "blue", "green"), each = 3), xlim = c(6.5, 9.5),
    ylim = c(10, 14), cex = 1.5, lwd = 2, frame.plot = FALSE, las = 1, pch = 16,
    xlab = "Body length", ylab = "Wing span")

summary(lm <- lm(wing ~ pop-1 + body))     # Same as fm2

library(lme4)
summary(lmm1 <- lmer(wing ~ (1|pop) + body))  # Fit the model
ranef(lmm1)                                   # Print random effects

alpha_j <- fixef(lmm1)[1]+ranef(lmm1)$pop[,1]
cbind(fixed = coef(lm)[1:3], random = alpha_j)

op <- par(lwd = 3)
abline(lm$coef[1], lm$coef[4], col = "red", lty = 2)
abline(lm$coef[2], lm$coef[4], col = "blue", lty = 2)
abline(lm$coef[3], lm$coef[4], col = "green", lty = 2)
abline(alpha_j[1], fixef(lmm1)[2], col = "red")
abline(alpha_j[2], fixef(lmm1)[2], col = "blue")
abline(alpha_j[3], fixef(lmm1)[2], col = "green")
abline(fixef(lmm1), col = "black")
legend(6.5, 14, c("Catalonia", "Aragon", "Navarra"), col=c("blue", "green", "red"),
    lty = 1, pch = 16, bty = "n", cex = 1.5)
par(op)

summary(lmm2 <- lmer(wing ~ body + (1|pop) + (0+body|pop)))

# 3.4.2 Random effects for a Poisson data distribution: normal-Poisson generalised linear mixed model (GLMM)
# ------------------------------------------------------------------------
summary(glmm <- glmer(mites ~ body + (1|pop), family = poisson))

# 3.5 Summary and outlook (no code)

# 3.6 Exercises
# =============

# Define and plot data (10 times larger data set than the toy data set)
clone.size <- 10               # clone size
pop <- factor(rep(c(rep("Navarra", 3), rep("Aragon", 3), rep("Catalonia", 3)),
    levels = c("Navarra", "Aragon", "Catalonia"), clone.size))
wing <- rep(c(10.5, 10.6, 11.0, 12.1, 11.7, 13.5, 11.4, 13.0, 12.9), clone.size)
body <- rep(c(6.8, 8.3, 9.2, 6.9, 7.7, 8.9, 6.9, 8.2, 9.2), clone.size)
sex <- rep(factor(c("M","F","M","F","M","F","M","F","M"), levels = c("M", "F")), clone.size)
mites <- rep(c(0, 3, 2, 1, 0, 7, 0, 9, 6), clone.size)
color <- rep(c(0.45, 0.47, 0.54, 0.42, 0.54, 0.46, 0.49, 0.42, 0.57), clone.size)
damage <- rep(c(0,2,0,0,4,2,1,0,1), clone.size)

=#

# ╔═╡ Cell order:
# ╠═f4844bc0-49f8-11eb-1e81-1193c6324479
# ╠═3d7c02ae-49f3-11eb-3d83-d93c5c67b7f0
# ╠═06c08a82-49fc-11eb-3177-9fef55e3c247
# ╠═47c8a48e-49fc-11eb-1d34-f10971aa0601
# ╠═6008ae60-49fc-11eb-3631-c78f0553dac7
# ╠═67659210-49ff-11eb-3a51-93bb33ced33f
# ╠═c052a500-49fc-11eb-12e1-ad0fb43b3431
# ╠═9e1cfc80-49ff-11eb-1d0d-e718536b8200
# ╠═ae5f7e60-4a13-11eb-3b60-89f77dddcacd
# ╠═f4c647e0-4a26-11eb-39b2-75125641d6fb
# ╠═7617cda0-4a2c-11eb-3724-e7b94f13274f
# ╠═fddf88f0-4a26-11eb-2905-991b214ebb2e
# ╠═dd8730f0-49f2-11eb-28d1-cd41eac67b57
