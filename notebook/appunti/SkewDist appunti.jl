### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ 32821a60-2299-11eb-34e0-d53f629e32e2
include("auxiliary functions.jl")

# ╔═╡ 5b51d650-229a-11eb-1ec4-af7e3cf773a3
include("out/skewdist/SkewDist.jl-master/src/SkewDist.jl")

# ╔═╡ 954faea0-2299-11eb-12ac-693d240c4b87
md"SkewDist non è pacchetto registrato

non ha project.toml, dobbiamo scaricarlo e importarlo manualmente

prima dobbiamo installare i pacchetti necessari:

1. Distributions
2. StatsFuns, 
3. MultivariateStats, 
4. PDMats, 
5. Optim, 
6. Roots"

# ╔═╡ 29460f10-2299-11eb-3abd-eb69ed4b5d3e
mkpath("out/skewdist")

# ╔═╡ d2d722e0-2298-11eb-3e41-714f3b3bd493
download("https://github.com/STOR-i/SkewDist.jl/archive/master.zip","out/skewdist/code.zip")

# ╔═╡ 8722d640-2299-11eb-0f7e-435002636236
unzip("out/skewdist/code.zip","out/skewdist/")

# ╔═╡ d17c7940-22b6-11eb-1d42-0b605381dc40


# ╔═╡ Cell order:
# ╟─954faea0-2299-11eb-12ac-693d240c4b87
# ╠═29460f10-2299-11eb-3abd-eb69ed4b5d3e
# ╠═d2d722e0-2298-11eb-3e41-714f3b3bd493
# ╠═32821a60-2299-11eb-34e0-d53f629e32e2
# ╠═8722d640-2299-11eb-0f7e-435002636236
# ╠═5b51d650-229a-11eb-1ec4-af7e3cf773a3
# ╠═d17c7940-22b6-11eb-1d42-0b605381dc40
