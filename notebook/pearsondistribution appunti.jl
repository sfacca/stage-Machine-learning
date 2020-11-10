### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ 9493c150-234c-11eb-347e-67a2c739b310
using PearsonDistribution

# ╔═╡ d819d3b0-234c-11eb-1f37-357392ae1c93
md"""PearsonDistributiion non è registrato

può esser aggiunto tramite 
* Pkg.add(url="https://github.com/bdeonovic/PearsonDistribution.jl")  
* ] add https://github.com/bdeonovic/PearsonDistribution.jl"""

# ╔═╡ 10bc935e-234d-11eb-2113-1d1fb8af2041
md"il pacchetto definiscie 7 struct:  
PearsonI, PearsonII, PearsonIII, PearsonIV, PearsonV, PearsonVI, PearsonVII
"

# ╔═╡ 9125ce40-234d-11eb-016e-c527d726b540
x = PearsonIV(1,2)

# ╔═╡ 4052d150-234f-11eb-188c-9d9f5b92b0ce
md"il pacchetto esporta anche una funzione:"

# ╔═╡ 35ab7630-234f-11eb-1805-cb5ed73e635a
fitpearson(5.0,6.0,7.0,12.0)

# ╔═╡ b25e1b40-235b-11eb-15e6-4bc2fe4c8855
md"la funzione valuta se i momenti dati sono compatibili con distr pearson, nel qual caso ritorna fitting su una pearson"

# ╔═╡ Cell order:
# ╟─d819d3b0-234c-11eb-1f37-357392ae1c93
# ╠═9493c150-234c-11eb-347e-67a2c739b310
# ╟─10bc935e-234d-11eb-2113-1d1fb8af2041
# ╠═9125ce40-234d-11eb-016e-c527d726b540
# ╟─4052d150-234f-11eb-188c-9d9f5b92b0ce
# ╠═35ab7630-234f-11eb-1805-cb5ed73e635a
# ╟─b25e1b40-235b-11eb-15e6-4bc2fe4c8855
