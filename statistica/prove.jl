### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ b0d494c0-2e82-11eb-2469-51ad14e734d2
using StatsModels, RDatasets, DataFrames, GLM, Random

# ╔═╡ dbdc82e0-2e82-11eb-13f7-695f5da12cd2
Random.seed!(0)

# ╔═╡ dbdcd100-2e82-11eb-3b95-738605158cd3
n = 30

# ╔═╡ dbdd1f22-2e82-11eb-368a-694bfa8b7883
begin
	df = dataset("MASS", "cpus")[1:n,:]
	df.Freq = map( x->10^9/x , df.CycT)
	df = df[:, [:Perf, :MMax, :Cach, :ChMax, :Freq]]
	df.Junk1 = rand(n)
	df.Junk2 = rand(n)
end

# ╔═╡ dbe890d0-2e82-11eb-1aa7-fb328bbbc996
function stepReg(df, reVar, pThresh)
	predVars = setdiff(propertynames(df), [reVar])
 	numVars = length(predVars)
 	model = nothing
  	while numVars > 0
 		fm = term(reVar) ~ term.((1, predVars...))
  		model = lm(fm, df)
 		pVals = coeftable(model).cols[4][2:end]
 		println("Variables: ", predVars)
 		println("P-values = ", round.(pVals,digits = 3))
 		pVal, knockout = findmax(pVals)
 		pVal < pThresh && break
 		println("\tRemoving the variable ", predVars[knockout],
 					" with p-value = ", round(pVal,digits=3))
 		deleteat!(predVars,knockout)
 		numVars = length(predVars)
 	end
 	 model
end

# ╔═╡ e983a1c0-2e88-11eb-0872-6d1d40e617a0
model = stepReg(df, :Perf, 0.05)

# ╔═╡ ecbdbe1e-2e88-11eb-26bb-11a5271cbb27
println(model)

# ╔═╡ Cell order:
# ╠═b0d494c0-2e82-11eb-2469-51ad14e734d2
# ╠═dbdc82e0-2e82-11eb-13f7-695f5da12cd2
# ╠═dbdcd100-2e82-11eb-3b95-738605158cd3
# ╠═dbdd1f22-2e82-11eb-368a-694bfa8b7883
# ╠═dbe890d0-2e82-11eb-1aa7-fb328bbbc996
# ╠═e983a1c0-2e88-11eb-0872-6d1d40e617a0
# ╠═ecbdbe1e-2e88-11eb-26bb-11a5271cbb27
