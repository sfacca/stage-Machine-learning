### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 82bb2d50-2ff5-11eb-0c9c-1b193763e791
using DifferentialEquations, Plots; pyplot()

# ╔═╡ 658a2f60-2ff5-11eb-3b3b-25d100065aa4
md"seir epidemic model
"

# ╔═╡ 1b6b5a60-2ff7-11eb-31d5-cb29107fab6e
beta, delta, gamma = 0.25, 0.2, 0.1

# ╔═╡ 1b6b8170-2ff7-11eb-2d07-e9e81a3ebe95
initialInfect = 0.025

# ╔═╡ 1b6bcf90-2ff7-11eb-1f04-832d90f54187
println("R0 = ", beta/gamma)

# ╔═╡ 1b706370-2ff7-11eb-3f16-71bbc25f067a
initX = [1-initialInfect, 0.0, initialInfect, 0.0]

# ╔═╡ 1b70d8a0-2ff7-11eb-3b32-a70daf270e66
tEnd = 100.0

# ╔═╡ 1b743400-2ff7-11eb-0cfe-b5dd079f83ec
RHS(x,parms,t) = [ -beta*x[1]*x[3],
	beta*x[1]*x[3] - delta*x[2],
	delta*x[2] - gamma*x[3],
	gamma*x[3] ]

# ╔═╡ 1b748220-2ff7-11eb-311e-29e2b15b7777
prob = ODEProblem(RHS, initX, (0,tEnd), 0)

# ╔═╡ 1b77dd80-2ff7-11eb-01e9-3f501e25d248
sol = solve(prob)

# ╔═╡ 1b7a7590-2ff7-11eb-24e9-738de38eddd2
println("Final infected proportion= ", sol.u[end][4])

# ╔═╡ 1b7b11d0-2ff7-11eb-1498-d57bb9605741
plot(sol.t,((x)->x[1]).(sol.u),label = "Susceptible", c=:green)

# ╔═╡ 1b7ebb50-2ff7-11eb-0634-9bdba3350d15
plot!(sol.t,((x)->x[2]).(sol.u),label = "Exposed", c=:blue)

# ╔═╡ 1b80de30-2ff7-11eb-3a3b-af0c2eb0d5b3
plot!(sol.t,((x)->x[3]).(sol.u),label = "Infected", c=:red)

# ╔═╡ 1b817a70-2ff7-11eb-1b34-131b48f4d0b6
plot!(sol.t,((x)->x[4]).(sol.u),label = "Removed", c=:yellow,
	xlabel = "Time", ylabel = "Proportion",legend = :top)

# ╔═╡ Cell order:
# ╟─658a2f60-2ff5-11eb-3b3b-25d100065aa4
# ╠═82bb2d50-2ff5-11eb-0c9c-1b193763e791
# ╠═1b6b5a60-2ff7-11eb-31d5-cb29107fab6e
# ╠═1b6b8170-2ff7-11eb-2d07-e9e81a3ebe95
# ╠═1b6bcf90-2ff7-11eb-1f04-832d90f54187
# ╠═1b706370-2ff7-11eb-3f16-71bbc25f067a
# ╠═1b70d8a0-2ff7-11eb-3b32-a70daf270e66
# ╠═1b743400-2ff7-11eb-0cfe-b5dd079f83ec
# ╠═1b748220-2ff7-11eb-311e-29e2b15b7777
# ╠═1b77dd80-2ff7-11eb-01e9-3f501e25d248
# ╠═1b7a7590-2ff7-11eb-24e9-738de38eddd2
# ╠═1b7b11d0-2ff7-11eb-1498-d57bb9605741
# ╠═1b7ebb50-2ff7-11eb-0634-9bdba3350d15
# ╠═1b80de30-2ff7-11eb-3a3b-af0c2eb0d5b3
# ╠═1b817a70-2ff7-11eb-1b34-131b48f4d0b6
