### A Pluto.jl notebook ###
# v0.12.9

using Markdown
using InteractiveUtils

# ╔═╡ ed23ae50-2434-11eb-2340-af1ce5ecbd70
include("skewdist/SkewDist.jl")	

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

# ╔═╡ 7681af30-236d-11eb-3cdf-db06a95846b7
md"SkewDist è un pacchetto che non viene aggiornato dal 2017, usa keywords di julia non i utilizzatye come immutable

bisogna quindi fare qualche cambiamento al codice"

# ╔═╡ ef98fb80-236d-11eb-1b52-9bf18413feb2
md"possiamo ora importare il codice"

# ╔═╡ ae6c5350-243a-11eb-0e5a-0373d9a8d724
md"il pacchetto contiene funzioni:

* pdf: densità di probabilità P(X=x) con X~distribuzione univarfiata
* cdf: P(X<=x)
* dof: gradfi di libertà del modello di input
* quantile: come funzioni q[distr] di R"

# ╔═╡ Cell order:
# ╟─954faea0-2299-11eb-12ac-693d240c4b87
# ╟─7681af30-236d-11eb-3cdf-db06a95846b7
# ╟─ef98fb80-236d-11eb-1b52-9bf18413feb2
# ╠═ed23ae50-2434-11eb-2340-af1ce5ecbd70
# ╟─ae6c5350-243a-11eb-0e5a-0373d9a8d724
