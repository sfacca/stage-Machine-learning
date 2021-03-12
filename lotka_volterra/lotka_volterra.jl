### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ fbcf4282-833d-11eb-0990-3dcb60a2d5e4
using Catalyst

# ╔═╡ 35aea0e0-833e-11eb-1918-0d5c2d6c0b43
using Latexify

# ╔═╡ 5ae37840-833e-11eb-3950-35a1edbdb62f
using DifferentialEquations, Plots

# ╔═╡ 6cf2e860-8346-11eb-3f97-1d7259baf074
using Turing

# ╔═╡ fa464270-8346-11eb-05fa-e396a960d76a
using StatsPlots

# ╔═╡ 1d2a7b70-8339-11eb-1241-5ba246346668
md"## Lotka-Volterra demo
* https://twitter.com/adamlmaclean/status/1368988847397216256"

# ╔═╡ c3a39020-8354-11eb-0665-df01198bb48b
md"
🐬 fish  
eat 
🐸 frogs  
eat  
🐜 ants   "

# ╔═╡ 8d7d9040-8354-11eb-2941-c1af98a57e9a
md"Let’s set up the model.  


We’ll use Catalyst.jl to define the reactions of this model. The model reactions are automatically output: 
"

# ╔═╡ 12660922-833e-11eb-04cb-f503488df683
md"…and to convert this to a set of ODEs that define the model? Right here…"

# ╔═╡ 44a001c0-833e-11eb-10d1-575502d0bdc8
md"Ok let’s simulate this model. All you need are a set of parameters, initial conditions, and a timespan. Then turn the reaction network into a system of ODEs with:"

# ╔═╡ 61d59390-833e-11eb-29bf-bdf01fb088fc
md"Don’t like ODEs? Want instead to run some stochastic Gillespie simulations, without redefining anything? Easy."

# ╔═╡ 82a58a30-833e-11eb-3972-fbbdbc2f60ee
md"Ok, now let’s look at the steady states and stability of the ODE system. First, let's solve the ODE model at steady state symbolically (for any possible parameter values)

NB I’m using SymPy via PyCall for this, but you now also do it directly in Julia via Symbolics.jl.."

# ╔═╡ 8dd9bc00-833e-11eb-0381-2d780c791f65
import SymPy 

# ╔═╡ 836e5870-833e-11eb-175e-7951a74ab470

begin
	🐜, 🐸, 🐬 = SymPy.@vars 🐜 🐸 🐬
	α₁, α₂, δ₁, δ₂, δ₃, g₁, g₂, g₃ = SymPy.@vars α₁ α₂ δ₁ δ₂ δ₃ g₁ g₂ g₃

	rhs = [α₁*🐜*(1 - g₁*🐜 - g₂*🐸) - α₂*🐜 - δ₁*🐜,
		   α₂*🐜*(1 - g₃*🐬) - δ₂*🐸,
		   δ₂*🐸 - δ₃*🐬]

	fps = SymPy.solve(rhs, [🐜,🐸,🐬])
end

# ╔═╡ ffc69460-833d-11eb-1da3-0f8a0d3652fa
begin
	ecomodel = @reaction_network begin
    α₁*(1 - 0.01*🐜 - 0.05*🐸), 🐜 --> 2🐜
    α₂*(1 - 0.1*🐬), 🐜 --> 🐸
    δ₁, 🐜 --> ∅
    δ₂, 🐸 --> 🐬
    δ₃, 🐬 --> ∅
    end α₁ α₂ δ₁ δ₂ δ₃
end

# ╔═╡ 147ed700-833e-11eb-0727-c3228c3dda3d
begin
	odes = convert(ODESystem, ecomodel)
	latexify(odes)
end

# ╔═╡ 5116c5b0-833e-11eb-2093-3916f8b27e56
begin

	cc = ["#835C3B" "#10DA05" "#05E9FF"]

	## Parameters [α₁ α₂ δ₁ δ₂ δ₃]
	p = (0.2, 0.15, 0.05, 0.15, 0.1)
	u₀ = [20., 20., 10.]
	tspan = (0., 50.)

	# create the ODEProblem 
	ds = ODEProblem(ecomodel, u₀, tspan, p)

	sol = solve(ds, Tsit5())
	plot(sol, lw=4, lc=cc, legend=false)
end

# ╔═╡ 637030c0-833e-11eb-0dee-03c5c5fc1af8
begin
	ds_discrete = DiscreteProblem(ecomodel, [20,20,10], tspan, p)
jump_ds = JumpProblem(ecomodel, ds_discrete, Direct())

sol2 = solve(jump_ds, SSAStepper())
plot(sol2, lw=4, lc=cc, legend=false)
end

# ╔═╡ 908728c0-833e-11eb-0104-f35321f870ce
md"There are three steady states. Let’s study their linear stability…

First, calculate the Jacobian symbolically:"

# ╔═╡ 910d21a0-833e-11eb-14b6-2d237fe022bf
J = rhs.jacobian([🐜,🐸,🐬])

# ╔═╡ 25e2c710-8355-11eb-0955-95d3ebe28b1c
md"…and evaluate it at one of the steady states. We can still do this symbolically (for arbitrary parameters) - its messy! but hey, you didn’t have to write it out by hand."

# ╔═╡ a291fea0-833e-11eb-2f27-d3fefc9d8b30
begin
	## Select a fixed point
	nfp = 2

	## Substitute fixed point values [x1,x2,x3]
	J_fp = J.subs([(🐜,fps[nfp][1]),(🐸,fps[nfp][2]),(🐬,fps[nfp][3])])
end

# ╔═╡ b1617fa0-833e-11eb-2c3b-cb8a82b4ee54

rhs

# ╔═╡ b628cbb0-833e-11eb-2f13-9f738565f0d2
md"Now substitute in a set of parameter values to get a numerical Jacobian, from which we can immediately calculate the linear stability of that fixed point…"

# ╔═╡ bb870090-833e-11eb-1a45-1d27680a6456
begin
	## Substitute parameter values 
par = [0.2, 0.5, 0.5, 0.1, 0.7, 0.1, 0.05, 0.02]
J_eval = J_fp.subs([(α₁,par[1]),(α₂,par[2]),(δ₁,par[3]),(δ₂,par[4]),(δ₃,par[5]),(g₁,par[6]),(g₂,par[7]),(g₃,par[8])])
end

# ╔═╡ c4d868a0-833e-11eb-0b0d-895128f73ae9
begin
	## Calculate eigenvalues 
eigs = J_eval.eigenvals()

## Find the stability of the fixed point 
is_stable = false
if maximum(real(collect(keys(eigs)))) < 0
    is_stable = true
end
is_stable
end

# ╔═╡ e287e560-833e-11eb-0c4d-bff90cc6ec88
md"Finally, let's do Bayesian parameter inference on the ODE model! For likelihood-based methods, Waving hand Turing.jl 

(for likelihood-free methods using ABC, Waving hand GpABC.jl) 

We'll use Turing.jl here. First, generate some simulated data from the model:"

# ╔═╡ e35f3290-833e-11eb-0477-9da1e019d125
begin
	
## Parameter inference
x0_inf = [5.; 5.; 5.]
p_inf = [0.8; 0.3; 0.1; 0.5; 1.4]
tspan3 = (0.0, 50.0)

ds3 = ODEProblem(ecomodel, x0_inf, tspan3, p_inf)

sol3 = solve(ds3,Tsit5(),saveat=.9)
targetdata = Array(sol3) + 0.6*randn(size(Array(sol3)))

plot(sol3, alpha = 0.5, lc=cc, legend = false); scatter!(sol3.t, targetdata', color=cc)
end

# ╔═╡ da09a7a0-8345-11eb-39bc-610865b37eaa
md"Then define your priors and a likelihood function (in this case the ODE simulation + Normal noise) and you're ready to run some MCMC chains!"

# ╔═╡ ff7c4b50-8345-11eb-1daa-b9ebd1d0f1ed
@model function fitmodel(data, ds)
    σ ~ InverseGamma(2, 3) 
    α₁ ~ truncated(Normal(1.0,1.0),0,3)
    α₂ ~ truncated(Normal(1.0,1.0),0,3)
    δ₁ ~ truncated(Normal(1.0,1.0),0,3)
    δ₂ ~ truncated(Normal(1.0,1.0),0,3)
    δ₃ ~ truncated(Normal(1.0,1.0),0,3)

    p = [α₁,α₂,δ₁,δ₂,δ₃]
    prob = remake(ds, p=p)
    predicted = solve(prob,Tsit5(),saveat=.9)

    for i = 1:length(predicted)
        data[:,i] ~ MvNormal(predicted[i], σ)
    end
end

# ╔═╡ 71de3730-8346-11eb-3fa0-053d305787a0
model = fitmodel(targetdata, ds)

# ╔═╡ a7ad2b80-8348-11eb-1c18-1bd9697095d4
@time chain = mapreduce(c -> sample(model, NUTS(.7), 1000), chainscat, 1:4)

# ╔═╡ f9e265a0-8348-11eb-2445-d7d159908abe
md"Here are the summary plots. Four chains converged to a posterior with marginal parameter densities close to the true values. 
"

# ╔═╡ 7779f4d0-8347-11eb-11fa-a398ae04b95e
plot(chain)

# ╔═╡ Cell order:
# ╠═1d2a7b70-8339-11eb-1241-5ba246346668
# ╟─c3a39020-8354-11eb-0665-df01198bb48b
# ╠═fbcf4282-833d-11eb-0990-3dcb60a2d5e4
# ╟─8d7d9040-8354-11eb-2941-c1af98a57e9a
# ╠═ffc69460-833d-11eb-1da3-0f8a0d3652fa
# ╟─12660922-833e-11eb-04cb-f503488df683
# ╠═35aea0e0-833e-11eb-1918-0d5c2d6c0b43
# ╠═147ed700-833e-11eb-0727-c3228c3dda3d
# ╟─44a001c0-833e-11eb-10d1-575502d0bdc8
# ╠═5ae37840-833e-11eb-3950-35a1edbdb62f
# ╠═5116c5b0-833e-11eb-2093-3916f8b27e56
# ╟─61d59390-833e-11eb-29bf-bdf01fb088fc
# ╠═637030c0-833e-11eb-0dee-03c5c5fc1af8
# ╟─82a58a30-833e-11eb-3972-fbbdbc2f60ee
# ╠═8dd9bc00-833e-11eb-0381-2d780c791f65
# ╠═836e5870-833e-11eb-175e-7951a74ab470
# ╟─908728c0-833e-11eb-0104-f35321f870ce
# ╠═910d21a0-833e-11eb-14b6-2d237fe022bf
# ╟─25e2c710-8355-11eb-0955-95d3ebe28b1c
# ╠═a291fea0-833e-11eb-2f27-d3fefc9d8b30
# ╠═b1617fa0-833e-11eb-2c3b-cb8a82b4ee54
# ╟─b628cbb0-833e-11eb-2f13-9f738565f0d2
# ╠═bb870090-833e-11eb-1a45-1d27680a6456
# ╠═c4d868a0-833e-11eb-0b0d-895128f73ae9
# ╟─e287e560-833e-11eb-0c4d-bff90cc6ec88
# ╠═e35f3290-833e-11eb-0477-9da1e019d125
# ╟─da09a7a0-8345-11eb-39bc-610865b37eaa
# ╠═6cf2e860-8346-11eb-3f97-1d7259baf074
# ╠═ff7c4b50-8345-11eb-1daa-b9ebd1d0f1ed
# ╠═71de3730-8346-11eb-3fa0-053d305787a0
# ╠═a7ad2b80-8348-11eb-1c18-1bd9697095d4
# ╟─f9e265a0-8348-11eb-2445-d7d159908abe
# ╠═fa464270-8346-11eb-05fa-e396a960d76a
# ╠═7779f4d0-8347-11eb-11fa-a398ae04b95e
