### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ 73453e50-236c-11eb-23e9-2dcc677ef837
using Distributions, StatsFuns, MultivariateStats, PDMats, Optim, Roots, LinearAlgebra

# ╔═╡ 32821a60-2299-11eb-34e0-d53f629e32e2
include("auxiliary functions.jl")

# ╔═╡ 0a259f50-236c-11eb-3457-c73b4aa25a97
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
6. Roots
7. LinearAlgebra"

# ╔═╡ 29460f10-2299-11eb-3abd-eb69ed4b5d3e
mkpath("out/skewdist")

# ╔═╡ d2d722e0-2298-11eb-3e41-714f3b3bd493
download("https://github.com/STOR-i/SkewDist.jl/archive/master.zip","out/skewdist/code.zip")

# ╔═╡ 8722d640-2299-11eb-0f7e-435002636236
unzip("out/skewdist/code.zip","out/skewdist/")

# ╔═╡ 7681af30-236d-11eb-3cdf-db06a95846b7
md"SkewDist è un pacchetto che non viene aggiornato dal 2017, usa keywords di julia non i utilizzatye come immutable

bisogna quindi fare qualche cambiamento al codice"

# ╔═╡ 7f714830-236d-11eb-236c-afa402d8200b
cp("./SkewDist.jl","out/skewdist/SkewDist.jl-master/src/SkewDist.jl", force=true)

# ╔═╡ de3eff10-236d-11eb-0325-a751ed94e023
cp("./mvskewnormal.jl","out/skewdist/SkewDist.jl-master/src/mvskewnormal.jl", force=true)

# ╔═╡ 737cd9fe-2375-11eb-0094-b3f2da7f6440
cp("./mvskewtdist.jl","out/skewdist/SkewDist.jl-master/src/mvskewtdist.jl", force=true)

# ╔═╡ ef98fb80-236d-11eb-1b52-9bf18413feb2
md"possiamo ora importare il codice"

# ╔═╡ 53ca07a0-237f-11eb-3a84-0300fe44937e
same_type_numeric(x::T, y::T) where {T<:Number} = true

# ╔═╡ Cell order:
# ╟─954faea0-2299-11eb-12ac-693d240c4b87
# ╠═73453e50-236c-11eb-23e9-2dcc677ef837
# ╠═29460f10-2299-11eb-3abd-eb69ed4b5d3e
# ╠═d2d722e0-2298-11eb-3e41-714f3b3bd493
# ╠═32821a60-2299-11eb-34e0-d53f629e32e2
# ╠═8722d640-2299-11eb-0f7e-435002636236
# ╟─7681af30-236d-11eb-3cdf-db06a95846b7
# ╠═7f714830-236d-11eb-236c-afa402d8200b
# ╠═de3eff10-236d-11eb-0325-a751ed94e023
# ╠═737cd9fe-2375-11eb-0094-b3f2da7f6440
# ╟─ef98fb80-236d-11eb-1b52-9bf18413feb2
# ╠═0a259f50-236c-11eb-3457-c73b4aa25a97
# ╠═53ca07a0-237f-11eb-3a84-0300fe44937e
