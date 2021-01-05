### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ f4844bc0-49f8-11eb-1e81-1193c6324479
using DataFrames, CategoricalArrays, Plots, GLM

# ╔═╡ e2eca800-4ad2-11eb-2fcc-d71c2c0823ce
using StatsModels

# ╔═╡ 7fc77a62-4ea2-11eb-2280-05d2861f4fb4
using MixedModels

# ╔═╡ d8d81a20-4b9a-11eb-3d16-117a74b7e431


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

# ╔═╡ dfb62e80-4b69-11eb-2e9a-174cf63f67e2
ModelMatrix(ModelFrame(@formula(wing ~ pop * body), data))

# ╔═╡ edc67e30-4b69-11eb-146f-a9e059d6b6b4
ModelMatrix(ModelFrame(@formula(wing ~ pop & body), data))

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
	

# ╔═╡ 96639870-4b92-11eb-30f7-c7ead405f68e
schem = schema(@formula(wing ~ 0 + pop & body + pop) ,data)

# ╔═╡ e58d4380-4ad2-11eb-0c5a-8d9b628ae7d6
#=
# instead of ModelMatrix(ModelFrame(f::FormulaTerm, data, model=MyModel))
sch = schema(f, data)
f = apply_schema(f, sch, MyModel)
response, predictors = modelcols(f, data)
=#
begin
	f = @formula(wing ~ 0 + pop & body + pop)
	sch = schema(f, data)
	f = apply_schema(f, sch)
	response, predictors = modelcols(f, data)
	predictors[1:3,3] = predictors[1:3,4]
	predictors = predictors[:,1:3]
	response, predictors
end

# ╔═╡ a3601910-4b90-11eb-1873-c1f3887de9a8
fit

# ╔═╡ 6ac657f0-4abd-11eb-2ec2-110df6b6676e
DM0.m[7:9,5] = DM0.m[7:9,6]                 # Combine slopes for Ar and Cat

# ╔═╡ 933b6630-4abd-11eb-288e-775a4c374260
begin
	DM1 = deepcopy(DM0)
	DM1.m = DM0.m[:, 1:5] # Delete former slope column for Cat
end

# ╔═╡ f33baad2-4ad7-11eb-1c6b-3be289ce80cc
DM1.assign

# ╔═╡ 3a5df590-4abe-11eb-1f57-1bfba5f192d0
# Fit model with partial interaction
fm4 <- lm(@formula(wing ~ DM1), data)


# ╔═╡ ebd70a80-4aca-11eb-3b8c-053386ffd555
# 3.2.3 Linear models with two factors
# ------------------------------------------------------------------------

# ╔═╡ 544556a2-4b96-11eb-0aca-4f05eded2a14
fm5 = lm(@formula(wing ~ pop + sex), data)

# ╔═╡ 9778af80-4e93-11eb-021a-83a9794dbfd1
fm6 = lm(@formula(wing ~ 0 + pop + sex), data)

# ╔═╡ ad16e550-4e93-11eb-2126-4b3a920a2f7f
# 3.2.4 Linear models with two continuous covariates and including polynomials
# ------------------------------------------------------------------------
fm7 = lm(@formula(wing ~ body + color), data)

# ╔═╡ dabc88c0-4e93-11eb-3e3b-e176341614fe
ModelMatrix(ModelFrame(@formula(wing ~  body*color), data))

# ╔═╡ 002393ae-4e94-11eb-039d-cfe417983f1d
fm8 = lm(@formula(wing ~  body*color), data)

# ╔═╡ 0a7e0750-4e94-11eb-1db7-4bb5898e6f5c

# Cubic polynomial of body in R
begin
	body2 = body .^2
	body3 = body .^3
	data[!,:body2] = body2
	data[!,:body3] = body3
	ModelMatrix(ModelFrame(@formula(wing ~ body + body2 + body3), data))
end

# ╔═╡ 30cba1b0-4e94-11eb-1afd-01595f395702
fm9 = lm(@formula(wing ~ body + body2 + body3), data)

# ╔═╡ 5825a300-4e94-11eb-2881-4fbe19a1c359

# 3.3 Generalised linear models (GLMs)
# ====================================


# ╔═╡ 62274842-4e94-11eb-1d92-1d160aa50ad1

# 3.3.1 Poisson generalised linear model (GLM) for unbounded counts
# ------------------------------------------------------------------------
fm10 = glm(@formula(mites ~ 0 + pop + body), data, Poisson())

# ╔═╡ 94523ace-4e96-11eb-2914-f110e3f4e574
# 3.3.2 Offsets in the Poisson GLM
# ------------------------------------------------------------------------
@formula(mites ~ pop-1 + wing + offset(log), data)

# ╔═╡ 10cf6710-4e9a-11eb-2894-7572b040adb6
# 3.3.5 Bernoulli GLM: logistic regression for a binary response
# ------------------------------------------------------------------------
begin
	mites_presence = [ ifelse(i>0,1,0) for i in mites]	
	data[!,:mites_presence] = mites_presence
end		

# ╔═╡ 5378bbbe-4e9f-11eb-3123-110774c7aaa3
fm11 = glm(@formula(mites_presence ~ 0 + pop + body), data, Binomial())

# ╔═╡ b08a6ac0-4e9f-11eb-0051-7b1de84686b9
# 3.3.6 Modeling a Poisson process from presence/absence data using a Bernoulli GLM with cloglog link
# ------------------------------------------------------------------------
fm11a = glm(@formula(mites_presence ~ 0 + pop + body), data, Binomial(), CloglogLink())

# ╔═╡ e4c53c70-4e9f-11eb-1be9-61633d1f821f
fm10

# ╔═╡ eaf25a10-4e9f-11eb-2698-0b31af91771d
# 3.4 Random effects (mixed) models
# =================================

# 3.4.1 Random effects for a normal data distribution: normal-normal generalised linear mixed model (GLMM)
# ------------------------------------------------------------------------
# Plot data without distinguishing sex

begin
	plot()
	scatter(body, wing, color = mapColors(
			pop[findall(x->true, sex)],colors
			), xlab = "Body length", ylab = "Wing span"
	)
end

# ╔═╡ a9e84760-4ea3-11eb-11f5-79b055f38523
begin
	f1 = @formula(mites ~ body + (1|pop))
	m1 = fit(GeneralizedLinearMixedModel, f1, data, Poisson())
end

# ╔═╡ 57bcf130-4b96-11eb-0db4-7d31c4d58c64


# ╔═╡ Cell order:
# ╠═f4844bc0-49f8-11eb-1e81-1193c6324479
# ╠═d8d81a20-4b9a-11eb-3d16-117a74b7e431
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
# ╠═dfb62e80-4b69-11eb-2e9a-174cf63f67e2
# ╠═edc67e30-4b69-11eb-146f-a9e059d6b6b4
# ╠═d160581e-4aaa-11eb-10cf-a7f69ba8a4a4
# ╠═9cffcea0-4aad-11eb-0df7-8bc9c2b26da5
# ╠═fddf88f0-4a26-11eb-2905-991b214ebb2e
# ╠═05504f10-4ab4-11eb-186f-63c5fb28a842
# ╠═49ee3a0e-4ab4-11eb-02c2-676b37039973
# ╠═52a7eea0-4ab7-11eb-2691-e5b9dcd2e2b9
# ╠═7a1231ae-4ab9-11eb-0859-073aaa1709b6
# ╠═521b5750-4abd-11eb-1d15-53e756d795ad
# ╠═96639870-4b92-11eb-30f7-c7ead405f68e
# ╠═e2eca800-4ad2-11eb-2fcc-d71c2c0823ce
# ╠═e58d4380-4ad2-11eb-0c5a-8d9b628ae7d6
# ╠═a3601910-4b90-11eb-1873-c1f3887de9a8
# ╠═6ac657f0-4abd-11eb-2ec2-110df6b6676e
# ╠═933b6630-4abd-11eb-288e-775a4c374260
# ╠═f33baad2-4ad7-11eb-1c6b-3be289ce80cc
# ╠═3a5df590-4abe-11eb-1f57-1bfba5f192d0
# ╠═ebd70a80-4aca-11eb-3b8c-053386ffd555
# ╠═544556a2-4b96-11eb-0aca-4f05eded2a14
# ╠═9778af80-4e93-11eb-021a-83a9794dbfd1
# ╠═ad16e550-4e93-11eb-2126-4b3a920a2f7f
# ╠═dabc88c0-4e93-11eb-3e3b-e176341614fe
# ╠═002393ae-4e94-11eb-039d-cfe417983f1d
# ╠═0a7e0750-4e94-11eb-1db7-4bb5898e6f5c
# ╠═30cba1b0-4e94-11eb-1afd-01595f395702
# ╠═5825a300-4e94-11eb-2881-4fbe19a1c359
# ╠═62274842-4e94-11eb-1d92-1d160aa50ad1
# ╠═94523ace-4e96-11eb-2914-f110e3f4e574
# ╠═10cf6710-4e9a-11eb-2894-7572b040adb6
# ╠═5378bbbe-4e9f-11eb-3123-110774c7aaa3
# ╠═b08a6ac0-4e9f-11eb-0051-7b1de84686b9
# ╠═e4c53c70-4e9f-11eb-1be9-61633d1f821f
# ╠═eaf25a10-4e9f-11eb-2698-0b31af91771d
# ╠═7fc77a62-4ea2-11eb-2280-05d2861f4fb4
# ╠═a9e84760-4ea3-11eb-11f5-79b055f38523
# ╠═57bcf130-4b96-11eb-0db4-7d31c4d58c64
