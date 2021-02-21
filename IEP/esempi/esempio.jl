### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 319bddbe-7456-11eb-2144-c121a33a3e86
using Pkg, Match

# ╔═╡ 571c3d10-7456-11eb-33e6-19c8bffd1ab8
using Catlab.WiringDiagrams

# ╔═╡ a114c9f0-7497-11eb-1c00-5195cce34cd8
using Catlab

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

# ╔═╡ f4048c60-7495-11eb-36ff-939f00ca1278
typeof(cset)

# ╔═╡ 3cea76c0-7495-11eb-36c3-3d69d099188d
inps = [IEP.getName(x) for x in cset[:,:in_set]]

# ╔═╡ eb9acfc0-7496-11eb-00e9-799fdd238e00
in_sets = findall((x)->("AbstractACSet" in x), inps)

# ╔═╡ 0b1dd400-7497-11eb-1fcf-ff1f6fad85ca
impls = findall((x)->(x in in_sets), cset[:,:impl_in])

# ╔═╡ 3d6401a0-7497-11eb-0542-616282cc7a9f
funcs = unique(cset[cset[impls,:impl_fun],:func_name])#all names of Catlab functions that have AbstractACSet in input

# ╔═╡ ada5f3b0-7497-11eb-0250-8b6a2c48ba85
unique(cset[impls,:impl_docs])[1:26]

# ╔═╡ e482e780-7497-11eb-3389-f36c6b3eb36c
unique(cset[impls,:impl_docs])[27:end]

# ╔═╡ 947c4d30-7497-11eb-1978-efc9bc0ddbea
Catlab.pretty_tables(cset)

# ╔═╡ 68f3a0e0-7498-11eb-040b-ef167672630b
findall((x)->(x == "pretty_tables"),cset[:,:func_name])

# ╔═╡ 841b3a40-7498-11eb-2066-a140c575e8a0
codes = cset[findall((x)->(x == 20),cset[:,:impl_fun]), :impl_code]

# ╔═╡ c4239790-7498-11eb-3e6e-2b58967c1a4c
[x.source for x in filter((x)->(IEP.getName(x.func.name)=="pretty_tables"),scr)]

# ╔═╡ 44786010-7499-11eb-00ec-a53a3cf0c62a
Catlab.CategoricalAlgebra.pretty_tables(cset)

# ╔═╡ 712891e0-7497-11eb-0fb8-8f53b799dfce
funcs[1:30]

# ╔═╡ 791b2d3e-7497-11eb-36be-cb94b2a57e8b
funcs[31:60]

# ╔═╡ 2d417e50-7498-11eb-241d-193d002f7940
funcs[61:end]

# ╔═╡ 934f7b10-7499-11eb-0abe-d5bba4d68a03
Catlab.pretty_tables(cset)

# ╔═╡ 89873550-7499-11eb-0848-99303511aa1d
[x.source for x in filter((x)->(IEP.getName(x.func.name)=="pretty_tables"),scr)]

# ╔═╡ 8ead9150-7499-11eb-3bdf-5bbf50736eb2
Catlab.CategoricalAlgebra.pretty_tables(cset)#trovato

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
# ╠═f4048c60-7495-11eb-36ff-939f00ca1278
# ╠═13570c90-745b-11eb-277e-3ddc61691544
# ╠═3cea76c0-7495-11eb-36c3-3d69d099188d
# ╠═eb9acfc0-7496-11eb-00e9-799fdd238e00
# ╠═0b1dd400-7497-11eb-1fcf-ff1f6fad85ca
# ╠═3d6401a0-7497-11eb-0542-616282cc7a9f
# ╠═ada5f3b0-7497-11eb-0250-8b6a2c48ba85
# ╠═e482e780-7497-11eb-3389-f36c6b3eb36c
# ╠═a114c9f0-7497-11eb-1c00-5195cce34cd8
# ╠═947c4d30-7497-11eb-1978-efc9bc0ddbea
# ╠═68f3a0e0-7498-11eb-040b-ef167672630b
# ╠═841b3a40-7498-11eb-2066-a140c575e8a0
# ╠═c4239790-7498-11eb-3e6e-2b58967c1a4c
# ╠═44786010-7499-11eb-00ec-a53a3cf0c62a
# ╠═712891e0-7497-11eb-0fb8-8f53b799dfce
# ╠═791b2d3e-7497-11eb-36be-cb94b2a57e8b
# ╠═2d417e50-7498-11eb-241d-193d002f7940
# ╠═934f7b10-7499-11eb-0abe-d5bba4d68a03
# ╠═89873550-7499-11eb-0848-99303511aa1d
# ╠═8ead9150-7499-11eb-3bdf-5bbf50736eb2
# ╠═550893c0-7460-11eb-3f40-9b83c494e433
# ╠═5c9c6d50-7460-11eb-3507-9d6cb2fe12c7
# ╠═6bdd26b0-7460-11eb-04eb-956b3178890e
# ╠═722630c0-7460-11eb-0076-d54f8a6a6df4
