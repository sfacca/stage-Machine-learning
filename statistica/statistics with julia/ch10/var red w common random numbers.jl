### A Pluto.jl notebook ###
# v0.12.12

using Markdown
using InteractiveUtils

# ╔═╡ a189e162-30d4-11eb-1f84-679fbf7a459f
using Distributions, Random, Plots, LaTeXStrings; pyplot()

# ╔═╡ fca90f30-30d4-11eb-04c3-d1d3415d6247
md"#### riduzione varianza con numeri casuali comuni"

# ╔═╡ cf381050-30d4-11eb-36fe-253cd3796531
seed = 1

# ╔═╡ cf383760-30d4-11eb-11cd-535365c9851b
N = 100

# ╔═╡ cf388580-30d4-11eb-1e62-b71f030887b2
lamGrid = 0.01:0.01:0.99

# ╔═╡ cf3c7d20-30d4-11eb-1674-995fd7a9086e
theorM(lam) = mean(Uniform(0,2*lam*(1-lam)))

# ╔═╡ cf3ccb40-30d4-11eb-22ae-a9cb9b69e592
estM(lam) = mean(rand(Uniform(0,2*lam*(1-lam)),N))

# ╔═╡ cf3fff90-30d4-11eb-19c2-95eeb971fdaf
function estM(lam,seed)
	Random.seed!(seed)
	estM(lam)
end

# ╔═╡ cf404db0-30d4-11eb-2586-290b0020749d
trueM = theorM.(lamGrid)

# ╔═╡ cf438202-30d4-11eb-3838-5de089b3319d
estM0 = estM.(lamGrid)

# ╔═╡ cf466830-30d4-11eb-3645-8b2fd0f1d096
estMCRN = estM.(lamGrid,seed)

# ╔═╡ cf46dd60-30d4-11eb-27fd-4b8ba1a2d29f
plot(lamGrid,trueM,
	c=:black, label="Expected curve")

# ╔═╡ cf4a86e2-30d4-11eb-3fbc-974626106173
plot!(lamGrid,estM0,
	c=:blue, label="No CRN estiamte")

# ╔═╡ cf4cd0d0-30d4-11eb-1ca2-c7aad429d67c
plot!(lamGrid,estMCRN,
	c=:red, label="CRN estimate",
	xlims=(0,1), ylims=(0,0.4), xlabel=L"\lambda", ylabel = "Mean")

# ╔═╡ 988fcba0-30d5-11eb-09e6-f7f99d39cdd6
md"### usando + rng"

# ╔═╡ 401f430e-30d5-11eb-005d-e9270ce75d9b
K, M = 50, 10^3

# ╔═╡ 832995c0-30d5-11eb-09b1-bb87cb1d616f
lamRange = 0.01:0.01:0.99

# ╔═╡ 8329e3de-30d5-11eb-3c27-a18cb73c4b8d
prn(lambda,rng) = quantile(Poisson(lambda),rand(rng))

# ╔═╡ 832a0af0-30d5-11eb-38e9-01cf29cb8731
zDist(lam) = Uniform(0,2*(1-lam))

# ╔═╡ 832f6220-30d5-11eb-2146-b9b3880e78d4
rv(lam,rng) = sum([rand(rng,zDist(lam)) for _ in 1:prn(K*lam,rng)])

# ╔═╡ 832f8930-30d5-11eb-3695-df2556469d72
rv2(lam,rng1,rng2) = sum([rand(rng1,zDist(lam)) for _ in 1:prn(K*lam,rng2)])

# ╔═╡ 8333a7e0-30d5-11eb-187e-cd9bdcdc88a9
mEst(lam,rng) = mean([rv(lam,rng) for _ in 1:N])

# ╔═╡ 83370340-30d5-11eb-3a29-55cfa168d4e8
mEst2(lam,rng1,rng2) = mean([rv2(lam,rng1,rng2) for _ in 1:N])

# ╔═╡ 83375160-30d5-11eb-3a07-3b117ea0658f
function mGraph0(seed)
	singleRng = MersenneTwister(seed)
	[mEst(lam,singleRng) for lam in lamRange]
end

# ╔═╡ 833b9720-30d5-11eb-316b-73390e21a85e
mGraph1(seed) = [mEst(lam,MersenneTwister(seed)) for lam in lamRange]

# ╔═╡ 833f67b0-30d5-11eb-396a-63dcb2ed72e8
mGraph2(seed1,seed2) = [mEst2(lam,MersenneTwister(seed1),
		MersenneTwister(seed2)) for lam in lamRange]

# ╔═╡ 8343fb8e-30d5-11eb-3c8d-7b9e5be04b21
argMaxLam(graph) = lamRange[findmax(graph)[2]]

# ╔═╡ 834708d2-30d5-11eb-2fae-e5000577a027
std0 = std([argMaxLam(mGraph0(seed)) for seed in 1:M])

# ╔═╡ 834a6430-30d5-11eb-0354-e790a0c33834
std1 = std([argMaxLam(mGraph1(seed)) for seed in 1:M])

# ╔═╡ 834b2780-30d5-11eb-1909-b1f5646e907c
std2 = std([argMaxLam(mGraph2(seed,seed+M)) for seed in 1:M])

# ╔═╡ b650ad80-30d5-11eb-3b0c-8983018746e1
md"
Standard deviation with no CRN: $std0

Standard deviation with CRN and single RNG: $std1

Standard deviation with CRN and two RNGs: $std2
"

# ╔═╡ 8357aaa0-30d5-11eb-299f-3fa2b4b1118f
plot(lamRange,mGraph0(1987),
	c=:red, label="No CRN")

# ╔═╡ 835dec30-30d5-11eb-34d7-d36113ba4549
plot!(lamRange,mGraph1(1987),
	c=:green, label="CRN and one RNG")

# ╔═╡ 836231f0-30d5-11eb-30e1-f91fe7b16422
plot!(lamRange,mGraph2(1987,1988),
	c=:blue, label="CRN and two RNG’s", xlims=(0,1),ylims=(0,14),
	xlabel=L"\lambda", ylabel = "Mean")

# ╔═╡ Cell order:
# ╟─fca90f30-30d4-11eb-04c3-d1d3415d6247
# ╠═a189e162-30d4-11eb-1f84-679fbf7a459f
# ╠═cf381050-30d4-11eb-36fe-253cd3796531
# ╠═cf383760-30d4-11eb-11cd-535365c9851b
# ╠═cf388580-30d4-11eb-1e62-b71f030887b2
# ╠═cf3c7d20-30d4-11eb-1674-995fd7a9086e
# ╠═cf3ccb40-30d4-11eb-22ae-a9cb9b69e592
# ╠═cf3fff90-30d4-11eb-19c2-95eeb971fdaf
# ╠═cf404db0-30d4-11eb-2586-290b0020749d
# ╠═cf438202-30d4-11eb-3838-5de089b3319d
# ╠═cf466830-30d4-11eb-3645-8b2fd0f1d096
# ╠═cf46dd60-30d4-11eb-27fd-4b8ba1a2d29f
# ╠═cf4a86e2-30d4-11eb-3fbc-974626106173
# ╠═cf4cd0d0-30d4-11eb-1ca2-c7aad429d67c
# ╟─988fcba0-30d5-11eb-09e6-f7f99d39cdd6
# ╠═401f430e-30d5-11eb-005d-e9270ce75d9b
# ╠═832995c0-30d5-11eb-09b1-bb87cb1d616f
# ╠═8329e3de-30d5-11eb-3c27-a18cb73c4b8d
# ╠═832a0af0-30d5-11eb-38e9-01cf29cb8731
# ╠═832f6220-30d5-11eb-2146-b9b3880e78d4
# ╠═832f8930-30d5-11eb-3695-df2556469d72
# ╠═8333a7e0-30d5-11eb-187e-cd9bdcdc88a9
# ╠═83370340-30d5-11eb-3a29-55cfa168d4e8
# ╠═83375160-30d5-11eb-3a07-3b117ea0658f
# ╠═833b9720-30d5-11eb-316b-73390e21a85e
# ╠═833f67b0-30d5-11eb-396a-63dcb2ed72e8
# ╠═8343fb8e-30d5-11eb-3c8d-7b9e5be04b21
# ╠═834708d2-30d5-11eb-2fae-e5000577a027
# ╠═834a6430-30d5-11eb-0354-e790a0c33834
# ╠═834b2780-30d5-11eb-1909-b1f5646e907c
# ╟─b650ad80-30d5-11eb-3b0c-8983018746e1
# ╠═8357aaa0-30d5-11eb-299f-3fa2b4b1118f
# ╠═835dec30-30d5-11eb-34d7-d36113ba4549
# ╠═836231f0-30d5-11eb-30e1-f91fe7b16422
