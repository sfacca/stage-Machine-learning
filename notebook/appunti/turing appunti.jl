### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 58a6a730-1abd-11eb-1e4b-23cf0e6cdfda
using Turing

# ╔═╡ 2d676a80-1abf-11eb-04aa-15a21d24f6e1
using StatsPlots

# ╔═╡ 3df31310-1ac2-11eb-3775-953d18b0d8ee
using InstantiateFromURL

# ╔═╡ 0d9d67a0-1abe-11eb-2a0d-e1a222b67577
md"
turing è un pacchetto per programmazione probabilistica in julia

features principali:

1. strumenti modellazione probabilistica generale <- DynamicPPL.jl
2. sampling di metodi di monte carlo per distribuzioni differenziuabili robusti ed efficienti
3. sampling su particle catene di markov per distribuzioni complesse con variabili discrete
4. inferenza composizionale
5. Advanced variational inference
"

# ╔═╡ bca5a4a0-1abf-11eb-38e0-9783e806abd1
md"
## esempi

### modellazione
1. crea modello con @model
2. condiziona modello (funzione) a dati
3. raccogli campioni con sample()
"

# ╔═╡ 79fa4562-1ac0-11eb-3d57-61f760cd9b27
@model gdemo(x, y) = begin
  s ~ InverseGamma(2, 3)
  m ~ Normal(0, sqrt(s))
  x ~ Normal(m, sqrt(s))
  y ~ Normal(m, sqrt(s))
end

# ╔═╡ c74fa260-1ac0-11eb-0f1d-21c045c686d3
md"
modello creato è una funzione con un metodo:
 
* gdemo(x, y)

~
"

# ╔═╡ 521f4480-1ad1-11eb-3415-5958d6df4dc8
md"generiamo campioni"

# ╔═╡ e5e11ab0-1ac0-11eb-2eac-514490e47a57
chn = sample(gdemo(1.5, 2), HMC(0.1, 5), 1000)

# ╔═╡ 64eb3590-1ad3-11eb-16b6-47eb9da1d8f0
md"funzione sample ritorna oggetti Chain

vedi https://github.com/TuringLang/MCMCChains.jl per informazioni ulteriori"

# ╔═╡ abe5cab0-1ad2-11eb-1e22-dbf05a79589e
md"summary:"

# ╔═╡ b8695fe0-1ad2-11eb-0eaf-613b306feca3
describe(chn)

# ╔═╡ c96de950-1ad2-11eb-0037-11ce5e7fa6a4
md"plotta:"

# ╔═╡ d5b8e250-1ad2-11eb-135d-a9386e52e9b8
p = plot(chn)

# ╔═╡ e84b85d2-1ad2-11eb-2094-ef14f91e37f0
md"possiamo usare lo stesso modello per produrre campionature diverse:"

# ╔═╡ 2c8b2430-1ad3-11eb-3b7c-fbaaabac4661
begin
	c1 = sample(gdemo(1.5, 2), SMC(), 1000)
	c2 = sample(gdemo(1.5, 2), PG(10), 1000)
	c3 = sample(gdemo(1.5, 2), HMC(0.1, 5), 1000)
	c4 = sample(gdemo(1.5, 2), Gibbs(PG(10, :m), HMC(0.1, 5, :s)), 1000)
	c5 = sample(gdemo(1.5, 2), HMCDA(0.15, 0.65), 1000)
	c6 = sample(gdemo(1.5, 2), NUTS(0.65), 1000)
end

# ╔═╡ 50db19ce-1ad3-11eb-17cc-a963410817d2
md"gli argomenti diversi sono:

* SMC: number of particles.
* PG: number of particles, number of iterations.
* HMC: leapfrog step size, leapfrog step numbers.
* Gibbs: component sampler 1, component sampler 2, …
* HMCDA: total leapfrog length, target accept ratio.
* NUTS: number of adaptation steps (optional), target accept ratio.

più info nella documentazione dell api di turing: https://turing.ml/dev/docs/library/"

# ╔═╡ e3866730-1ad3-11eb-3803-d98fdfb9fcfa
md"
#### altre basi

si possono campionare + modelli contemporaneamente (anche con multithreading/multiproc): 
* https://turing.ml/dev/docs/using-turing/guide#sampling-multiple-chains

si può generare campioni da distrib non condiz del modello passando Prior() alla fun sample:
* https://turing.ml/dev/docs/using-turing/guide#sampling-from-an-unconditional-distribution-the-prior

query su modello:
* https://turing.ml/dev/docs/using-turing/guide#querying-probabilities-from-model-or-chain

"

# ╔═╡ 33931170-1ad3-11eb-23d8-011cdc3068a6
md"* https://turing.ml/dev/docs/using-turing/guide"

# ╔═╡ Cell order:
# ╠═58a6a730-1abd-11eb-1e4b-23cf0e6cdfda
# ╠═2d676a80-1abf-11eb-04aa-15a21d24f6e1
# ╠═3df31310-1ac2-11eb-3775-953d18b0d8ee
# ╟─0d9d67a0-1abe-11eb-2a0d-e1a222b67577
# ╟─bca5a4a0-1abf-11eb-38e0-9783e806abd1
# ╠═79fa4562-1ac0-11eb-3d57-61f760cd9b27
# ╟─c74fa260-1ac0-11eb-0f1d-21c045c686d3
# ╟─521f4480-1ad1-11eb-3415-5958d6df4dc8
# ╠═e5e11ab0-1ac0-11eb-2eac-514490e47a57
# ╟─64eb3590-1ad3-11eb-16b6-47eb9da1d8f0
# ╟─abe5cab0-1ad2-11eb-1e22-dbf05a79589e
# ╠═b8695fe0-1ad2-11eb-0eaf-613b306feca3
# ╟─c96de950-1ad2-11eb-0037-11ce5e7fa6a4
# ╠═d5b8e250-1ad2-11eb-135d-a9386e52e9b8
# ╟─e84b85d2-1ad2-11eb-2094-ef14f91e37f0
# ╠═2c8b2430-1ad3-11eb-3b7c-fbaaabac4661
# ╟─50db19ce-1ad3-11eb-17cc-a963410817d2
# ╟─e3866730-1ad3-11eb-3803-d98fdfb9fcfa
# ╟─33931170-1ad3-11eb-23d8-011cdc3068a6
