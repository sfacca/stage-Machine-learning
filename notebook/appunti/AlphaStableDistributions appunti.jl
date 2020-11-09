### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ 642ea670-22a1-11eb-2083-3dd01eb1dd00
using AlphaStableDistributions

# ╔═╡ 082776b0-22ae-11eb-261c-053a87221aca
using Plots

# ╔═╡ 9c647380-22a1-11eb-23d9-f7df7fb800df
md"AlphaStableDistributions è wrapper per ARL Python Tools (arlpy)

* https://github.com/org-arl/arlpy

* https://arlpy.readthedocs.io/en/latest/

il pacchetto wrappa solo funzioni rand e fit per distribuzioni alfa stabile e alfa sub gaussiana con memoria

"

# ╔═╡ 701cbbf0-22ad-11eb-2cd6-6d41d30051e4
d1 = AlphaStable()

# ╔═╡ dbd1d2de-22ad-11eb-148c-79f07ab18d0d
AlphaStable{Float64}(α=1.5, β=0.0, scale=1.0, location=0.0)

# ╔═╡ dbd29630-22ad-11eb-2584-c96558417de6
s = rand(d1, 100000);

# ╔═╡ dbd70300-22ad-11eb-0610-5363f84c278b
AlphaStable{Float64}(α=1.4748701622930906, β=0.0, scale=1.006340087707924, location=-0.0036724481641865715)

# ╔═╡ dbd7c650-22ad-11eb-0bb0-8f29fb2b1d54
x = rand(AlphaSubGaussian(n=9600));

# ╔═╡ dbdad390-22ad-11eb-111b-c515e36288ff
plot(x)

# ╔═╡ Cell order:
# ╠═642ea670-22a1-11eb-2083-3dd01eb1dd00
# ╟─9c647380-22a1-11eb-23d9-f7df7fb800df
# ╠═701cbbf0-22ad-11eb-2cd6-6d41d30051e4
# ╠═dbd1d2de-22ad-11eb-148c-79f07ab18d0d
# ╠═dbd29630-22ad-11eb-2584-c96558417de6
# ╠═dbd70300-22ad-11eb-0610-5363f84c278b
# ╠═dbd7c650-22ad-11eb-0bb0-8f29fb2b1d54
# ╠═082776b0-22ae-11eb-261c-053a87221aca
# ╠═dbdad390-22ad-11eb-111b-c515e36288ff
