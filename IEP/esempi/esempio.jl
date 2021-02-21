### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 319bddbe-7456-11eb-2144-c121a33a3e86
using Pkg, Match

# ╔═╡ 571c3d10-7456-11eb-33e6-19c8bffd1ab8
using Catlab.WiringDiagrams

# ╔═╡ 442c1040-7456-11eb-199c-05e99f63c5ff
include("../src/IEP.jl")

# ╔═╡ 4008a550-7456-11eb-09e7-b762445a40f7
Pkg.activate(".")

# ╔═╡ c23e17e0-745a-11eb-1b99-afce0091b49e
raw = IEP.read_code(string(Pkg.dir("Catlab"),"/src"));

# ╔═╡ edd65f20-745a-11eb-0b5e-51dac44fe736
scr = IEP.scrape(raw)

# ╔═╡ 13570c90-745b-11eb-277e-3ddc61691544
cset = IEP.folder_to_CSet(string(Pkg.dir("Catlab"),"/src"))[2];

# ╔═╡ c446ce40-745c-11eb-36a6-db6b9c1ec49b
cset[:,:func_name]

# ╔═╡ 550893c0-7460-11eb-3f40-9b83c494e433
length(cset[:,:impl_in])# numero di implementazioni di funzioni

# ╔═╡ 5c9c6d50-7460-11eb-3507-9d6cb2fe12c7
length(cset[:,:in_set])# numero di set di input diversi

# ╔═╡ 6bdd26b0-7460-11eb-04eb-956b3178890e
length(cset[:,:func_name])# numero di noimi funzione diversi

# ╔═╡ 722630c0-7460-11eb-0076-d54f8a6a6df4
length(cset[:,:calls_set])# numero di set di calls diverse

# ╔═╡ Cell order:
# ╠═319bddbe-7456-11eb-2144-c121a33a3e86
# ╠═571c3d10-7456-11eb-33e6-19c8bffd1ab8
# ╠═4008a550-7456-11eb-09e7-b762445a40f7
# ╠═442c1040-7456-11eb-199c-05e99f63c5ff
# ╠═c23e17e0-745a-11eb-1b99-afce0091b49e
# ╠═edd65f20-745a-11eb-0b5e-51dac44fe736
# ╠═13570c90-745b-11eb-277e-3ddc61691544
# ╠═c446ce40-745c-11eb-36a6-db6b9c1ec49b
# ╠═550893c0-7460-11eb-3f40-9b83c494e433
# ╠═5c9c6d50-7460-11eb-3507-9d6cb2fe12c7
# ╠═6bdd26b0-7460-11eb-04eb-956b3178890e
# ╠═722630c0-7460-11eb-0076-d54f8a6a6df4
