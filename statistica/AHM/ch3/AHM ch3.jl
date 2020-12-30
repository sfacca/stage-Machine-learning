### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ f4844bc0-49f8-11eb-1e81-1193c6324479
using DataFrames, CategoricalArrays, Plots, GLM

# ╔═╡ e2eca800-4ad2-11eb-2fcc-d71c2c0823ce
using StatsModels

# ╔═╡ a3a2bee2-4ab5-11eb-1640-c376d219c2fd
function level(asd, i)
	return findfirst((x)->x==asd[i],levels(asd))
end

# ╔═╡ 6cc72aa0-4ab5-11eb-1638-295a1bdf5660
function lev_to_ind(arr)
	res = Array{Int,1}(undef,length(arr))
	for i in 1:length(arr)
		res[i] = level(arr, i)
	end
	CategoricalArray(res)
end
			

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
	poplevs = lev_to_ind(pop)
	sexlevs = lev_to_ind(sex)
end


# ╔═╡ 9a5e2810-4ab5-11eb-1652-d5b5ef159625
level(sex, 2)

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
	damage = damage,
	#poplevs = poplevs,
	#sexlevs = sexlevs
)

# ╔═╡ c052a500-49fc-11eb-12e1-ad0fb43b3431
# 3.2 Linear models
# =================

# 3.2.1 Linear models with main effects of one factor and one continuous covariate
# --------------------------------------------------------------------------------
fm1 = lm(@formula(wing ~ pop + body), data)

# ╔═╡ 8df3b5ce-4ad9-11eb-074f-41f520d2af2f


# ╔═╡ 9e1cfc80-49ff-11eb-1d0d-e718536b8200
fm2 = lm(@formula(wing ~ 0 + pop + body), data)# no intercept

# ╔═╡ ae5f7e60-4a13-11eb-3b60-89f77dddcacd
dump(fm1)

# ╔═╡ f4c647e0-4a26-11eb-39b2-75125641d6fb
predict(fm1)

# ╔═╡ 7617cda0-4a2c-11eb-3724-e7b94f13274f
predict(fm2)

# ╔═╡ 7d52dfc0-4aa3-11eb-1f7d-55e0c023931c
ModelMatrix(ModelFrame(@formula(wing ~ pop + body), data))

# ╔═╡ 998a7a00-4ad9-11eb-2819-292113d00a3e
lm(@formula(wing ~ pop + body), data)

# ╔═╡ a380a3d2-4aa8-11eb-1818-adbab59f41e6
ModelMatrix(ModelFrame(@formula(wing ~ 0 + pop + body), data))

# ╔═╡ d160581e-4aaa-11eb-10cf-a7f69ba8a4a4
function mapColors(arr, colors)
	res = Array{String,1}(undef, length(arr))
	lev = levels(arr)
	for i in 1:length(arr)
		for j in 1:length(lev)
			if arr[i] == lev[j]
				res[i] = colors[j]
			end
		end
	end
	res
end

# ╔═╡ 9cffcea0-4aad-11eb-0df7-8bc9c2b26da5
#[:none, :auto, :circle, :rect, :star5, :diamond, :hexagon, :cross, :xcross, :utriangle, :dtriangle, :rtriangle, :ltriangle, :pentagon, :heptagon, :octagon, :star4, :star6, :star7, :star8, :vline, :hline, :+, :x]

# ╔═╡ fddf88f0-4a26-11eb-2905-991b214ebb2e
begin
	colors = ["red","green","blue"]
	plot()
	scatter(		
		body[findall(x->x=="F", sex)], wing[findall(x->x=="F", sex)],
		color = mapColors(
			pop[findall(x->x=="F", sex)],colors
			), 
		markershape = :dtriangle,
		legend = false
	)
	scatter!(
		body[findall(x->x=="M", sex)], wing[findall(x->x=="M", sex)],
		xlab = "Body length", ylab = "Wing span", 
		color = mapColors(
			pop[findall(x->x=="M", sex)],colors
			)
	)
	Plots.abline!(coef(fm2)[4], coef(fm2)[1], color = colors[1])
	Plots.abline!(coef(fm2)[4], coef(fm2)[2], color = colors[2])# catalonia
	Plots.abline!(coef(fm2)[4], coef(fm2)[3], color = colors[3])
end

# ╔═╡ 05504f10-4ab4-11eb-186f-63c5fb28a842
# 3.2.2 Linear models with interaction between one factor and one continuous covariate
# ------------------------------------------------------------------------
ModelMatrix(ModelFrame(@formula(wing ~ pop * body), data))

# ╔═╡ 49ee3a0e-4ab4-11eb-02c2-676b37039973
ModelMatrix(ModelFrame(@formula(wing ~ 0 + pop & body + pop), data))

# ╔═╡ 52a7eea0-4ab7-11eb-2691-e5b9dcd2e2b9
fm3 = lm(@formula(wing ~ 0 + pop & body + pop), data)

# ╔═╡ 7a1231ae-4ab9-11eb-0859-073aaa1709b6
# Plot
begin
	#@colors = ["red","green","blue"]
	plot()
	scatter(		
		body[findall(x->x=="F", sex)], wing[findall(x->x=="F", sex)],
		color = mapColors(
			pop[findall(x->x=="F", sex)],colors
			), 
		markershape = :dtriangle,
		legend = false
	)
	scatter!(
		body[findall(x->x=="M", sex)], wing[findall(x->x=="M", sex)],
		xlab = "Body length", ylab = "Wing span", 
		color = mapColors(
			pop[findall(x->x=="M", sex)],colors
			)
	)
	Plots.abline!(coef(fm3)[4], coef(fm3)[1], color = colors[1])
	Plots.abline!(coef(fm3)[5], coef(fm3)[2], color = colors[2])# catalonia
	Plots.abline!(coef(fm3)[6], coef(fm3)[3], color = colors[3])
end

# ╔═╡ 521b5750-4abd-11eb-1d15-53e756d795ad
# Create new design matrix
DM0 = ModelMatrix(ModelFrame(@formula(wing ~ 0 + pop & body + pop), data))
	

# ╔═╡ e58d4380-4ad2-11eb-0c5a-8d9b628ae7d6
modelmatrix()

# ╔═╡ 6ac657f0-4abd-11eb-2ec2-110df6b6676e
DM0.m[7:9,5] = DM0.m[7:9,6]                 # Combine slopes for Ar and Cat

# ╔═╡ 933b6630-4abd-11eb-288e-775a4c374260
begin
	DM1 = deepcopy(DM0)
	DM1.m = DM0.m[:, 1:5] # Delete former slope column for Cat
end

# ╔═╡ f33baad2-4ad7-11eb-1c6b-3be289ce80cc
DM1.assign

# ╔═╡ 52fd5ea0-4ad8-11eb-02b3-f32823d34b26
DM1.m

# ╔═╡ 3a5df590-4abe-11eb-1f57-1bfba5f192d0
# Fit model with partial interaction
fm4 <- lm(@formula(wing ~ DM1), data)


# ╔═╡ ebd70a80-4aca-11eb-3b8c-053386ffd555


# ╔═╡ afb038b0-4ac0-11eb-17b5-c31eafa82bce
names(fm3).mm

# ╔═╡ dd8730f0-49f2-11eb-28d1-cd41eac67b57
#=
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
# ╠═9a5e2810-4ab5-11eb-1652-d5b5ef159625
# ╠═a3a2bee2-4ab5-11eb-1640-c376d219c2fd
# ╠═6cc72aa0-4ab5-11eb-1638-295a1bdf5660
# ╠═06c08a82-49fc-11eb-3177-9fef55e3c247
# ╠═47c8a48e-49fc-11eb-1d34-f10971aa0601
# ╠═6008ae60-49fc-11eb-3631-c78f0553dac7
# ╠═67659210-49ff-11eb-3a51-93bb33ced33f
# ╠═c052a500-49fc-11eb-12e1-ad0fb43b3431
# ╠═8df3b5ce-4ad9-11eb-074f-41f520d2af2f
# ╠═9e1cfc80-49ff-11eb-1d0d-e718536b8200
# ╠═ae5f7e60-4a13-11eb-3b60-89f77dddcacd
# ╠═f4c647e0-4a26-11eb-39b2-75125641d6fb
# ╠═7617cda0-4a2c-11eb-3724-e7b94f13274f
# ╠═7d52dfc0-4aa3-11eb-1f7d-55e0c023931c
# ╠═998a7a00-4ad9-11eb-2819-292113d00a3e
# ╠═a380a3d2-4aa8-11eb-1818-adbab59f41e6
# ╠═d160581e-4aaa-11eb-10cf-a7f69ba8a4a4
# ╠═9cffcea0-4aad-11eb-0df7-8bc9c2b26da5
# ╠═fddf88f0-4a26-11eb-2905-991b214ebb2e
# ╠═05504f10-4ab4-11eb-186f-63c5fb28a842
# ╠═49ee3a0e-4ab4-11eb-02c2-676b37039973
# ╠═52a7eea0-4ab7-11eb-2691-e5b9dcd2e2b9
# ╠═7a1231ae-4ab9-11eb-0859-073aaa1709b6
# ╠═521b5750-4abd-11eb-1d15-53e756d795ad
# ╠═e2eca800-4ad2-11eb-2fcc-d71c2c0823ce
# ╠═e58d4380-4ad2-11eb-0c5a-8d9b628ae7d6
# ╠═6ac657f0-4abd-11eb-2ec2-110df6b6676e
# ╠═933b6630-4abd-11eb-288e-775a4c374260
# ╠═f33baad2-4ad7-11eb-1c6b-3be289ce80cc
# ╠═52fd5ea0-4ad8-11eb-02b3-f32823d34b26
# ╠═3a5df590-4abe-11eb-1f57-1bfba5f192d0
# ╠═ebd70a80-4aca-11eb-3b8c-053386ffd555
# ╠═afb038b0-4ac0-11eb-17b5-c31eafa82bce
# ╠═dd8730f0-49f2-11eb-28d1-cd41eac67b57
