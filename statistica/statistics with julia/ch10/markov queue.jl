### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ bcc9fe20-300b-11eb-2b39-6d22be5fa1fa
using Distributions, Random, Plots; pyplot()

# ╔═╡ f3393c00-300b-11eb-04cc-3b55a96bdf41
Random.seed!(4)

# ╔═╡ f3396310-300b-11eb-3286-87eedd8266ca
function simulateMM1DoobGillespie(lambda,mu,Q0,T)
	t, Q = 0.0 , Q0
	tValues, qValues = [0.0], [Q0]
	while t<T
		if Q == 0
			t += rand(Exponential(1/lambda))
			Q = 1
		else
			t += rand(Exponential(1/(lambda+mu)))
			Q += 2(rand() < lambda/(lambda+mu)) -1
		end
		push!(tValues,t)
		push!(qValues,Q)
	end
	return [tValues, qValues]
end

# ╔═╡ d3c31060-3008-11eb-3780-294620f1d96c
function stichSteps(epochs,q)
	n = length(epochs)
	newEpochs = [ epochs[1] ]
	newQ = [ q[1] ]
	for i in 2:n
		push!(newEpochs,epochs[i])
		push!(newQ,q[i-1])
		push!(newEpochs,epochs[i])
		push!(newQ,q[i])
	end
	return [newEpochs, newQ]
end

# ╔═╡ d97c7d40-300b-11eb-0db0-85eea9b63216
lambda, mu = 0.7, 1.0

# ╔═╡ 05fd9de0-300c-11eb-05e6-cffea4104954
Tplot, Testimation = 200, 10^7

# ╔═╡ 05fdc4f0-300c-11eb-21bd-d92ad6aa822c
Q0 = 20

# ╔═╡ c792eb00-300b-11eb-23bb-1f4159580af8

eL, qL = simulateMM1DoobGillespie(lambda, mu ,Q0, Testimation)


# ╔═╡ df051d82-300b-11eb-2e46-35c0e9bb5586
meanQueueLength = (eL[2:end]-eL[1:end-1])'*qL[1:end-1]/last(eL)

# ╔═╡ cf9abc10-300b-11eb-1911-a3bd4e67ae7b
rho = lambda/mu

# ╔═╡ 0a442130-300c-11eb-2f03-cd0c02bf4621
println("Estimated mean queue length: ", meanQueueLength )

# ╔═╡ 0a444842-300c-11eb-2b4d-13e356db7357
println("Theoretical mean queue length: ", rho/(1-rho) )

# ╔═╡ 0a449660-300c-11eb-0530-c9b245dc1689
epochs, qValues = simulateMM1DoobGillespie(lambda, mu, Q0,Tplot)

# ╔═╡ 0a495150-300c-11eb-21e7-ebfeb8eb9152
epochsForPlot, qForPlot = stichSteps(epochs,qValues)

# ╔═╡ 0a4a14a0-300c-11eb-3b8a-833e4043b758
plot(epochsForPlot,qForPlot,
	c=:blue, xlims=(0,Tplot), ylims=(0,25), xlabel="Time",
	ylabel="Customers in queue", legend=:none)

# ╔═╡ Cell order:
# ╠═bcc9fe20-300b-11eb-2b39-6d22be5fa1fa
# ╠═f3393c00-300b-11eb-04cc-3b55a96bdf41
# ╠═f3396310-300b-11eb-3286-87eedd8266ca
# ╠═d3c31060-3008-11eb-3780-294620f1d96c
# ╠═d97c7d40-300b-11eb-0db0-85eea9b63216
# ╠═05fd9de0-300c-11eb-05e6-cffea4104954
# ╠═05fdc4f0-300c-11eb-21bd-d92ad6aa822c
# ╠═c792eb00-300b-11eb-23bb-1f4159580af8
# ╠═df051d82-300b-11eb-2e46-35c0e9bb5586
# ╠═cf9abc10-300b-11eb-1911-a3bd4e67ae7b
# ╠═0a442130-300c-11eb-2f03-cd0c02bf4621
# ╠═0a444842-300c-11eb-2b4d-13e356db7357
# ╠═0a449660-300c-11eb-0530-c9b245dc1689
# ╠═0a495150-300c-11eb-21e7-ebfeb8eb9152
# ╠═0a4a14a0-300c-11eb-3b8a-833e4043b758
