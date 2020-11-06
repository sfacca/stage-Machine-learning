### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ 0eb96fa0-2048-11eb-0827-59285a4ec3c0
using StatsFuns

# ╔═╡ c8b5bda0-2048-11eb-1975-e30af4f9e70c
md"statsfuns contiene costanti e funzioni per statistica

vediamo alcuni esempi:

### costanti

#### π"

# ╔═╡ f9738110-2049-11eb-2c6c-113244d032ea
twoπ

# ╔═╡ fee6c492-2049-11eb-1e5c-4dee6e7259f3
quartπ

# ╔═╡ 0a054b80-204a-11eb-3ffb-edcd2ac4c2c4
sqrtπ

# ╔═╡ 2bd8f680-204a-11eb-1a9e-0fc2cf535bc4
logπ

# ╔═╡ 3464767e-204a-11eb-3225-2d855a1c34ed
md"#### log"

# ╔═╡ 461d34c0-204a-11eb-37ed-179c8b8d94f3
loghalf

# ╔═╡ 4d705bd0-204a-11eb-01ae-f51970d253df
logtwo

# ╔═╡ 50630ef0-204a-11eb-1a72-1bb21eb2aa27
md"
### funzioni

#### log"

# ╔═╡ 6a01be60-204a-11eb-07c7-31194be77508
logit(0.2)

# ╔═╡ 7ee49370-204a-11eb-1109-87416614ebd7
logaddexp(2,3)

# ╔═╡ 8c8fdfc0-204a-11eb-3c70-27a353cc89b2
md"
#### funzioni su distribuzioni

cdf -> p

pdf -> d

ci sono funzioni per le distribuzioni maggiori, anche con alcune trasformazioni logaritmiche
"

# ╔═╡ 978756b0-204a-11eb-1eab-4103f2c15496
betalogcdf(0.2,0.3,0.4)

# ╔═╡ d0d4fc60-204a-11eb-0578-9fae696d2141
nfdistpdf(0.2,0.3,0.5,0.4)

# ╔═╡ Cell order:
# ╠═0eb96fa0-2048-11eb-0827-59285a4ec3c0
# ╟─c8b5bda0-2048-11eb-1975-e30af4f9e70c
# ╠═f9738110-2049-11eb-2c6c-113244d032ea
# ╠═fee6c492-2049-11eb-1e5c-4dee6e7259f3
# ╠═0a054b80-204a-11eb-3ffb-edcd2ac4c2c4
# ╠═2bd8f680-204a-11eb-1a9e-0fc2cf535bc4
# ╟─3464767e-204a-11eb-3225-2d855a1c34ed
# ╠═461d34c0-204a-11eb-37ed-179c8b8d94f3
# ╠═4d705bd0-204a-11eb-01ae-f51970d253df
# ╟─50630ef0-204a-11eb-1a72-1bb21eb2aa27
# ╠═6a01be60-204a-11eb-07c7-31194be77508
# ╠═7ee49370-204a-11eb-1109-87416614ebd7
# ╟─8c8fdfc0-204a-11eb-3c70-27a353cc89b2
# ╠═978756b0-204a-11eb-1eab-4103f2c15496
# ╠═d0d4fc60-204a-11eb-0578-9fae696d2141
