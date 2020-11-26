### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 83dc3940-2feb-11eb-24d1-7d6e8f1d06f2
using DifferentialEquations, LinearAlgebra, Plots; pyplot()

# ╔═╡ b32d1780-2ff2-11eb-2ccf-a1e893025129
md"simuazionie sistemi dinamici con tempo continuo"

# ╔═╡ e4082e50-2ff0-11eb-3d11-6373249daac9
k, b, M = 1.2, 0.3, 2.0

# ╔═╡ e4085560-2ff0-11eb-2013-5177138d1c6f
A = [0 1;
	-k/M -b/M]

# ╔═╡ e408a382-2ff0-11eb-02e5-47ec7cd0e67d
initX = [8., 0.0]

# ╔═╡ e40ce940-2ff0-11eb-0138-199a45e41dc1
tEnd = 50.0

# ╔═╡ e40d5e70-2ff0-11eb-1313-7df8aa1e7482
tRange = 0:0.1:tEnd

# ╔═╡ e41092c0-2ff0-11eb-1292-9d058396c38d
manualSol = [exp(A*t)*initX for t in tRange]

# ╔═╡ e41107f0-2ff0-11eb-09a3-47e97c9c0730
linearRHS(x,Amat,t) = Amat*x

# ╔═╡ e4148a60-2ff0-11eb-2164-e910f37ee4b8
prob = ODEProblem(linearRHS, initX, (0,tEnd), A)

# ╔═╡ e416fb60-2ff0-11eb-1de0-c95ba23c3b73
sol = solve(prob)

# ╔═╡ a797a850-2ff1-11eb-04b5-f52602c7285d
begin
	p1 = plot(first.(manualSol), last.(manualSol),
		c=:blue, label="Manual trajectory")
	p1 = scatter!(first.(sol.u), last.(sol.u),
		c=:red, ms = 5, msw=0, label="DiffEq package")
	p1 = scatter!([initX[1]], [initX[2]],
		c=:black, ms=10, label="Initial state", xlims=(-7,9), ylims=(-9,7),
		ratio=:equal, xlabel="Displacement", ylabel="Velocity")
end

# ╔═╡ bbf98d90-2ff1-11eb-0f4d-1b6797a5cde5
begin
	p2 = plot(tRange, first.(manualSol),
		c=:blue, label="Manual trajectory")
	p2 = scatter!(sol.t, first.(sol.u),
		c=:red, ms = 5, msw=0, label="DiffEq package")
	p2 = scatter!([0], [initX[1]],
		c=:black, ms=10, label="Initial state", xlabel="Time",
		ylabel="Displacement")
end

# ╔═╡ e42700f0-2ff0-11eb-0ac5-1d7d165a9e01
plot(p1, p2, size=(800,400), legend=:topright)

# ╔═╡ Cell order:
# ╟─b32d1780-2ff2-11eb-2ccf-a1e893025129
# ╠═83dc3940-2feb-11eb-24d1-7d6e8f1d06f2
# ╠═e4082e50-2ff0-11eb-3d11-6373249daac9
# ╠═e4085560-2ff0-11eb-2013-5177138d1c6f
# ╠═e408a382-2ff0-11eb-02e5-47ec7cd0e67d
# ╠═e40ce940-2ff0-11eb-0138-199a45e41dc1
# ╠═e40d5e70-2ff0-11eb-1313-7df8aa1e7482
# ╠═e41092c0-2ff0-11eb-1292-9d058396c38d
# ╠═e41107f0-2ff0-11eb-09a3-47e97c9c0730
# ╠═e4148a60-2ff0-11eb-2164-e910f37ee4b8
# ╠═e416fb60-2ff0-11eb-1de0-c95ba23c3b73
# ╠═a797a850-2ff1-11eb-04b5-f52602c7285d
# ╠═bbf98d90-2ff1-11eb-0f4d-1b6797a5cde5
# ╠═e42700f0-2ff0-11eb-0ac5-1d7d165a9e01
