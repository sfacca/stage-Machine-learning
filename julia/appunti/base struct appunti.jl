### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 67bb6b70-19f5-11eb-1987-1b3647259d84
using LinearAlgebra

# ╔═╡ c83e3fa0-19e5-11eb-338a-e9b75f5ee6c9
md"""## 1 hot/cold vector

### 1hot vector
array 1d di n elementi i quali sono tutti 0 tranne 1   

invece di istanziare n unità di mem possiamo solo salvare il numero n e l 		indice della cella "hot" (=1)

### 1cold vector
array 1d di n elementi i quali sono tutti 1 tranne uno 0

invece di istanziare n unità di mem possiamo solo salvare il numero n e l 		indice della cella "cold" (=0)

entrambe queste strutture devono soddisfare interfaccia array
"""

# ╔═╡ f0d9a420-19f1-11eb-0f98-df80e8655934
struct OneHot <: AbstractVector{Int}
	n::Int
	k::Int
end

# ╔═╡ 0ed45ab0-19f2-11eb-3636-873a59e8f150
Base.size(x::OneHot) = (x.n, )

# ╔═╡ 1d40d420-19f2-11eb-2572-e34ce69d95cb
Base.getindex(x::OneHot, i::Int) = Int(x.k==i)

# ╔═╡ 3c11f810-19f3-11eb-1001-9d92754b30a2
myoh = OneHot(6,2)

# ╔═╡ d31f98b0-19f4-11eb-050e-110352c5b62f
md""" 
## matrici diagonali

"""

# ╔═╡ dd048e30-19f4-11eb-29bf-251e64c8bdb8
M = [1 0 0
	0 12 0
	0 0 -5]	

# ╔═╡ 4ed01b90-19f7-11eb-0387-e7d30abd0c62
md" usiamo Diagonal da linearalgebra"

# ╔═╡ ec889220-19f4-11eb-2c9e-6b90293dad1e
Diagonal(M)

# ╔═╡ 70bd2cde-19f5-11eb-1ff8-5f7d28f86600
m = Diagonal([1,12,-5])

# ╔═╡ 7ec2a720-19f5-11eb-202a-4548d4636d70
md"## sparse matrix

matrici grandi dove una buona parte dei valori sono 0 -> vogliamo salvare solo i non 0 per risparmiare

vediamo 2 strategie:

#### ij value representation

insieme di [i,j] = value per tutti i (i,j) non 0 della matrice

#### CSC/CCS format (formato std julia)

3 array:
* val: array con tutti i valori nonzero
* colptr: colptr[i] indica l'indice in val in cui iniziano i valori per la colonna i
* rowval: rowval[i] indica in che riga mettere il valore val[i]
"

# ╔═╡ bcfa8a30-19f5-11eb-1ccd-27ef60e326e8
md"
## numeri casuali

a volte ci interessano solo dati statistici come dev standard, media, etc

quindi possiamo semplicemente calcolare le caratteristiche statistiche dei dati e poi eliminare i dati stessi
"

# ╔═╡ bdd6e070-19f5-11eb-2a4c-638abb475253
md"## multiplication tables

"

# ╔═╡ c98c7a70-19f9-11eb-04b3-595c8f9e5f2e
outer(v, w) = [x * y for x in v, y in w]

# ╔═╡ e7ac1e20-19f9-11eb-1f8b-2faebe181f71
outer(1:10,1:10)

# ╔═╡ 15f3cdf0-19fa-11eb-1815-2df4aef5bbb4
outer(1:12,1:12)

# ╔═╡ 29a43d80-19fa-11eb-2b90-03bdf30be018
md" per mult table 1:k alla 1:k, basta sapere il numero k

(contesto risparmia spazio)

sapendo il k, senza salvare dati, possiamo arrivare al valore di i,j calcolandolo quando ci serve"

# ╔═╡ 74a83b00-19fb-11eb-39ad-d7bba8942bb7


# ╔═╡ Cell order:
# ╠═67bb6b70-19f5-11eb-1987-1b3647259d84
# ╟─c83e3fa0-19e5-11eb-338a-e9b75f5ee6c9
# ╠═f0d9a420-19f1-11eb-0f98-df80e8655934
# ╠═0ed45ab0-19f2-11eb-3636-873a59e8f150
# ╠═1d40d420-19f2-11eb-2572-e34ce69d95cb
# ╠═3c11f810-19f3-11eb-1001-9d92754b30a2
# ╟─d31f98b0-19f4-11eb-050e-110352c5b62f
# ╠═dd048e30-19f4-11eb-29bf-251e64c8bdb8
# ╟─4ed01b90-19f7-11eb-0387-e7d30abd0c62
# ╠═ec889220-19f4-11eb-2c9e-6b90293dad1e
# ╠═70bd2cde-19f5-11eb-1ff8-5f7d28f86600
# ╟─7ec2a720-19f5-11eb-202a-4548d4636d70
# ╟─bcfa8a30-19f5-11eb-1ccd-27ef60e326e8
# ╠═bdd6e070-19f5-11eb-2a4c-638abb475253
# ╠═c98c7a70-19f9-11eb-04b3-595c8f9e5f2e
# ╠═e7ac1e20-19f9-11eb-1f8b-2faebe181f71
# ╠═15f3cdf0-19fa-11eb-1815-2df4aef5bbb4
# ╟─29a43d80-19fa-11eb-2b90-03bdf30be018
# ╠═74a83b00-19fb-11eb-39ad-d7bba8942bb7
