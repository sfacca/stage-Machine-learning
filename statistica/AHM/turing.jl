### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ fdb61020-5146-11eb-3237-b9c01b0c32e8
using Turing

# ╔═╡ 0b9ae2fe-5147-11eb-1419-0783f210d8b6
using StatsPlots

# ╔═╡ a05401c0-5147-11eb-08ba-e3c4d0563b1d
# Define a simple Normal model with unknown mean and variance.
@model function gdemo(x, y)
  s ~ InverseGamma(2, 3)
  m ~ Normal(0, sqrt(s))
  x ~ Normal(m, sqrt(s))
  y ~ Normal(m, sqrt(s))
end

# ╔═╡ 591314d0-5148-11eb-21a8-9582e618bc5a


# ╔═╡ a05428d0-5147-11eb-1ae9-25d824904ba2
#  Run sampler, collect results
#  Run sampler, collect results.
c1 = sample(gdemo(1.5, 2), SMC(), 1000)

# ╔═╡ 66cae440-5148-11eb-2af8-65a33e3d93fb
c2 = sample(gdemo(1.5, 2), PG(10), 1000)

# ╔═╡ 66cb0b50-5148-11eb-06de-ad7b2cd1cb55
c3 = sample(gdemo(1.5, 2), HMC(0.1, 5), 1000)

# ╔═╡ 66cb5972-5148-11eb-3dd4-ef1e97795d37
c4 = sample(gdemo(1.5, 2), Gibbs(PG(10, :m), HMC(0.1, 5, :s)), 1000)

# ╔═╡ 66cf9f30-5148-11eb-1ba5-6f7d4174d6c2
c5 = sample(gdemo(1.5, 2), HMCDA(0.15, 0.65), 1000)

# ╔═╡ 66d03b70-5148-11eb-3614-13f6baaa06f0
c6 = sample(gdemo(1.5, 2), NUTS(0.65), 1000)

# ╔═╡ a05476f0-5147-11eb-34f5-6f6c78549ce0
# Summarise results
describe(chn)

# ╔═╡ a057d250-5147-11eb-244c-a1323c8ead98
# Plot and save results
p = plot(chn)

# ╔═╡ a059ce20-5147-11eb-2e3d-c1eec88bcf84
savefig("gdemo-plot.png")

# ╔═╡ Cell order:
# ╠═fdb61020-5146-11eb-3237-b9c01b0c32e8
# ╠═0b9ae2fe-5147-11eb-1419-0783f210d8b6
# ╠═a05401c0-5147-11eb-08ba-e3c4d0563b1d
# ╠═591314d0-5148-11eb-21a8-9582e618bc5a
# ╠═a05428d0-5147-11eb-1ae9-25d824904ba2
# ╠═66cae440-5148-11eb-2af8-65a33e3d93fb
# ╠═66cb0b50-5148-11eb-06de-ad7b2cd1cb55
# ╠═66cb5972-5148-11eb-3dd4-ef1e97795d37
# ╠═66cf9f30-5148-11eb-1ba5-6f7d4174d6c2
# ╠═66d03b70-5148-11eb-3614-13f6baaa06f0
# ╠═a05476f0-5147-11eb-34f5-6f6c78549ce0
# ╠═a057d250-5147-11eb-244c-a1323c8ead98
# ╠═a059ce20-5147-11eb-2e3d-c1eec88bcf84
