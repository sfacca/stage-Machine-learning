### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ d07fa300-2ff9-11eb-22bc-85c7e2c71c9b
using LinearAlgebra, Statistics, StatsBase, Plots; pyplot()

# ╔═╡ 060c8fd0-2ffd-11eb-3243-a1038ce273be
using Random, Distributions

# ╔═╡ bf7cc740-2ff9-11eb-0554-73b5036c0271
md"catene di markov"

# ╔═╡ 17a28b30-2ffa-11eb-2076-41418e3270a1
n, N = 5, 10^6

# ╔═╡ 17a2b240-2ffa-11eb-3340-4b1ee999b385
P = diagm(-1 => fill(1/3,n-1),
	0 => fill(1/3,n),
	1 => fill(1/3,n-1))

# ╔═╡ 17a30062-2ffa-11eb-150f-a52ae482d95a
P[1,n], P[n,1] = 1/3, 1/3

# ╔═╡ 17a6d0f0-2ffa-11eb-0e46-2d67e292eeda
A = UpperTriangular(ones(n,n))

# ╔═╡ 17a71f10-2ffa-11eb-2d6a-b5b3ead29151
C = P*A

# ╔═╡ 17aaa180-2ffa-11eb-1a6c-d54ef6f68b97
function f1(x,u)
	for xNew in 1:n
		if u <= C[x+1,xNew]
			return xNew-1
		end
	end
end

# ╔═╡ 2bf184b2-2ffa-11eb-04bd-354279835479
md"The function f1() uses the transition probability matrix"

# ╔═╡ 17aaefa0-2ffa-11eb-160b-9747d4fb3c4a
f2(x,xi) = mod(x + xi , n)

# ╔═╡ 3a4aeb50-2ffa-11eb-086c-073bfe625ef5
md"the function f2() implements $f(x, u) = x + u\mod{5}$ directly"

# ╔═╡ 17ae9920-2ffa-11eb-32cf-4d8f74e80fba
function countTau(f,rnd)
	t = 0
	visits = fill(false,n)
	state = 0
	while sum(visits) < n
		state = f(state,rnd())
		visits[state+1] |= true
		t += 1
	end
	return t-1
end

# ╔═╡ 17af0e52-2ffa-11eb-0161-edb2ace4659f
data1 = [countTau(f1,rand) for _ in 1:N]

# ╔═╡ 17b242a0-2ffa-11eb-3b25-771d909232f0
data2 = [countTau(f2,()->rand([-1,0,1]) ) for _ in 1:N]

# ╔═╡ 17b528d0-2ffa-11eb-16bb-05d675b9bb5b
est1, est2 = mean(data1), mean(data2)

# ╔═╡ 17b5c510-2ffa-11eb-1e4e-79f2be6dad50
c1, c2 = counts(data1)/N,counts(data2)/N

# ╔═╡ c42b17a0-2ffa-11eb-2ecd-a737edc7fe00
md"Estimated mean value of tau using f1: $est1"

# ╔═╡ 17bd8d3e-2ffa-11eb-2a8d-618f21ea7a64
md"Estimated mean value of tau using f2: $est2"

# ╔═╡ e93eab60-2ffa-11eb-376d-395cece298b1
P

# ╔═╡ 17c380b0-2ffa-11eb-2a58-4956fdc251df
scatter(4:33,c1[1:30],
	c=:blue, ms=5, msw=0,
	label="Transition probability matrix")

# ╔═╡ 17c5caa0-2ffa-11eb-20cd-873bb475d1c3
scatter!(4:33,c2[1:30],
	c=:red, ms=5, msw=0, shape=:cross,
	label="Stochastic recursive formula", xlabel="Time", ylabel="Probability")

# ╔═╡ efaf9de0-2ffc-11eb-1e5f-7b07798a49b1
md"##### cat and mouse game estimation"

# ╔═╡ f4c4bbd0-2ffc-11eb-117f-232fe1aa06f6
Random.seed!(1)

# ╔═╡ 58d50940-2ffd-11eb-0a71-c1b6f35f8f23
function cmHitTime()
	catIndex, mouseIndex, t = 1, 5, 0
	while catIndex != mouseIndex
		catIndex += catIndex == 1 ? 1 : rand([-1,1])
		mouseIndex += mouseIndex == 5 ? -1 : rand([-1,1])
		t += 1
	end
	return t
end

# ╔═╡ 58d55760-2ffd-11eb-3b32-35389fdbd9b9
function mcTraj(P,initState,T,stopState=0)
	n = size(P)[1]
	state = initState
	traj = [state]
	for t in 1:T-1
		state = sample(1:n,weights(P[state,:]))
		push!(traj,state)
		if state == stopState
			break
		end
	end
	return traj
end

# ╔═╡ 58d5a580-2ffd-11eb-1dae-d94918ceac16
N2 = 10^6

# ╔═╡ 58db71e0-2ffd-11eb-1f23-d9daefb4b893
P2 = [ 0 1 0 0 0;
	1/4 0 1/4 1/4 1/4;
	0 1/2 0 0 1/2;
	0 1/2 0 0 1/2;
	0 0 0 0 1]

# ╔═╡ 58df1b60-2ffd-11eb-207c-458c3aa4ee73
theor = [1 0 0 0] * (inv(I - P2[1:4,1:4])*ones(4))

# ╔═╡ 58e2ebf0-2ffd-11eb-2554-f5fcd5cb061c
est12 = mean([cmHitTime() for _ in 1:N2])

# ╔═╡ 58e36120-2ffd-11eb-29af-af7821ed206d
est22 = mean([length(mcTraj(P2,1,10^6,5))-1 for _ in 1:N2])

# ╔═╡ 58e86a30-2ffd-11eb-2cac-65b6d2c58fbe
P2[5,:] = [1 0 0 0 0]

# ╔═╡ 58ec13b0-2ffd-11eb-2313-db6e40251656
pi5 = sum(mcTraj(P2,1,N2) .== 5)/N2

# ╔═╡ 58f03260-2ffd-11eb-166a-d16229969fb9
est3 = 1/pi5 - 1

# ╔═╡ 58f08080-2ffd-11eb-1961-7bdd4ec7ee4e
md"Theoretical: $theor

Estimate 1: $est12

Estimate 2: $est22

Estimate 3: $est3"

# ╔═╡ 3672ce4e-3007-11eb-2929-b9a4320bc5d0
Random.seed!(1)

# ╔═╡ 96df8f30-3007-11eb-1ade-89d5c6b771a8
function crudeSimulation(deltaT,T,Q,initProb)
	n = size(Q)[1]
	Pdelta = I + Q*deltaT
	state = sample(1:n,weights(initProb))
	t = 0.0
	while t < T
		t += deltaT
		state = sample(1:n,weights(Pdelta[state,:]))
	end
	return state
end

# ╔═╡ 96dfdd50-3007-11eb-38c4-01cc3fdffa78
function doobGillespie(T,Q,initProb)
	n = size(Q)[1]
	Pjump = (Q-diagm(0 => diag(Q)))./-diag(Q)
	lamVec = -diag(Q)
	state = sample(1:n,weights(initProb))
	sojournTime = rand(Exponential(1/lamVec[state]))
	t = 0.0
	while t + sojournTime < T
		t += sojournTime
		state = sample(1:n,weights(Pjump[state,:]))
		sojournTime = rand(Exponential(1/lamVec[state]))
	end
	return state
end

# ╔═╡ 96e582a0-3007-11eb-00b6-5b79196d6596
begin
	T, N3 = 0.25, 10^5
	Q = [-3 1 2
		1 -2 1
		0 1.5 -1.5]
	p0 = [0.4 0.5 0.1]
	crudeSimEst = counts([crudeSimulation(10^-3., T, Q, p0) for _ in 1:N3])/N3
	doobGillespieEst = counts([doobGillespie(T, Q, p0) for _ in 1:N3])/N3
	explicitEst = p0*exp(Q*T)
end

# ╔═╡ 96ea3d90-3007-11eb-0b66-532f24210519
md"CrudeSim:  $crudeSimEst

Doob Gillespie Sim:  $doobGillespieEst

Explicit:  $explicitEst

"

# ╔═╡ Cell order:
# ╟─bf7cc740-2ff9-11eb-0554-73b5036c0271
# ╠═d07fa300-2ff9-11eb-22bc-85c7e2c71c9b
# ╠═060c8fd0-2ffd-11eb-3243-a1038ce273be
# ╠═17a28b30-2ffa-11eb-2076-41418e3270a1
# ╠═17a2b240-2ffa-11eb-3340-4b1ee999b385
# ╠═17a30062-2ffa-11eb-150f-a52ae482d95a
# ╠═17a6d0f0-2ffa-11eb-0e46-2d67e292eeda
# ╠═17a71f10-2ffa-11eb-2d6a-b5b3ead29151
# ╠═17aaa180-2ffa-11eb-1a6c-d54ef6f68b97
# ╟─2bf184b2-2ffa-11eb-04bd-354279835479
# ╠═17aaefa0-2ffa-11eb-160b-9747d4fb3c4a
# ╟─3a4aeb50-2ffa-11eb-086c-073bfe625ef5
# ╠═17ae9920-2ffa-11eb-32cf-4d8f74e80fba
# ╠═17af0e52-2ffa-11eb-0161-edb2ace4659f
# ╠═17b242a0-2ffa-11eb-3b25-771d909232f0
# ╠═17b528d0-2ffa-11eb-16bb-05d675b9bb5b
# ╠═17b5c510-2ffa-11eb-1e4e-79f2be6dad50
# ╟─c42b17a0-2ffa-11eb-2ecd-a737edc7fe00
# ╟─17bd8d3e-2ffa-11eb-2a8d-618f21ea7a64
# ╠═e93eab60-2ffa-11eb-376d-395cece298b1
# ╠═17c380b0-2ffa-11eb-2a58-4956fdc251df
# ╠═17c5caa0-2ffa-11eb-20cd-873bb475d1c3
# ╟─efaf9de0-2ffc-11eb-1e5f-7b07798a49b1
# ╠═f4c4bbd0-2ffc-11eb-117f-232fe1aa06f6
# ╠═58d50940-2ffd-11eb-0a71-c1b6f35f8f23
# ╠═58d55760-2ffd-11eb-3b32-35389fdbd9b9
# ╠═58d5a580-2ffd-11eb-1dae-d94918ceac16
# ╠═58db71e0-2ffd-11eb-1f23-d9daefb4b893
# ╠═58df1b60-2ffd-11eb-207c-458c3aa4ee73
# ╠═58e2ebf0-2ffd-11eb-2554-f5fcd5cb061c
# ╠═58e36120-2ffd-11eb-29af-af7821ed206d
# ╠═58e86a30-2ffd-11eb-2cac-65b6d2c58fbe
# ╠═58ec13b0-2ffd-11eb-2313-db6e40251656
# ╠═58f03260-2ffd-11eb-166a-d16229969fb9
# ╟─58f08080-2ffd-11eb-1961-7bdd4ec7ee4e
# ╠═3672ce4e-3007-11eb-2929-b9a4320bc5d0
# ╠═96df8f30-3007-11eb-1ade-89d5c6b771a8
# ╠═96dfdd50-3007-11eb-38c4-01cc3fdffa78
# ╠═96e582a0-3007-11eb-00b6-5b79196d6596
# ╟─96ea3d90-3007-11eb-0b66-532f24210519
