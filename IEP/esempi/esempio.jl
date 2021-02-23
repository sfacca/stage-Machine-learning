### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 319bddbe-7456-11eb-2144-c121a33a3e86
using Pkg, Match

# ╔═╡ 571c3d10-7456-11eb-33e6-19c8bffd1ab8
using Catlab.WiringDiagrams

# ╔═╡ b86f2c00-75c6-11eb-06ad-916b90ff532d
using AlgebraicRelations, AlgebraicRelations.Presentations

# ╔═╡ a114c9f0-7497-11eb-1c00-5195cce34cd8
using Catlab

# ╔═╡ 442c1040-7456-11eb-199c-05e99f63c5ff
include("../src/IEP.jl")

# ╔═╡ 4008a550-7456-11eb-09e7-b762445a40f7
Pkg.activate(".")

# ╔═╡ c23e17e0-745a-11eb-1b99-afce0091b49e
raw = IEP.read_code(string(Pkg.dir("Catlab"),"/src"));

# ╔═╡ 6cd369c0-74b1-11eb-3a09-99306a8a359e
raw[1]

# ╔═╡ 825ce670-74ae-11eb-088f-a5bd4d7b8253
md"read code parsa ogni jl nella cartella in input e in ogni sottocartella, mantenendo path al file"

# ╔═╡ 5c41db80-74b3-11eb-25d3-77432dc27d33
 Catlab.CategoricalAlgebra.AbstractACSetType

# ╔═╡ edd65f20-745a-11eb-0b5e-51dac44fe736
scr = IEP.scrape(raw);

# ╔═╡ f8deda80-74b1-11eb-21ed-fd52b85c7d69
scr[17]

# ╔═╡ fedde340-74b1-11eb-1196-7578e3f28bb0
md"scrape raccoglie dichiarazioni di funzione con informazioni principali e documentazione"

# ╔═╡ 13570c90-745b-11eb-277e-3ddc61691544
res = IEP.folder_to_CSet(string(Pkg.dir("Catlab"),"/src"));

# ╔═╡ a4e51790-74b2-11eb-2d8e-1714fccb68bd
cset = res[2];

# ╔═╡ 3f9ebb20-74b2-11eb-1030-4ffee1ad3648
md"folder to cset crea direttamente il cset"

# ╔═╡ 53ac65e0-74b2-11eb-3eec-3178f1f55ce9
res[1]

# ╔═╡ 0b4f9a40-75c7-11eb-21bb-c53d76ecdc09
cset[:, :asd]

# ╔═╡ b1dd3210-75c6-11eb-3600-5d01242a6b85
md"struttura cset:"

# ╔═╡ c7bdef20-75c6-11eb-25f8-67ca3e2225b4
begin
	present = Presentation()
	Implementation, Calls, Inputs, Function = add_types!(present, [
		(:Implementation, String),
		(:Calls, String),
		(:Inputs, String),
		(:Function, String)]);
	impl_in, impl_fun, impl_calls = add_processes!(present, [
		(:impl_in, Implementation, Inputs),
		(:impl_fun, Implementation, Function),
		(:impl_calls, Implementation, Calls),
		]);
	draw_schema(present)
end

# ╔═╡ 53944a00-74b2-11eb-33e3-918248a2b9df
md"questo cset definisce oggetti :Function, :Implementation, :Inputs, :Calls"

# ╔═╡ c7d5cb52-74b2-11eb-38ac-d706839ab9aa
md"gli attributi sono  

* :impl\_code -> codice
* :impl_expr -> expr foglia dell implementazione
* :impl_docs -> documentazione
* :in_set -> tipi del inputs set
* :calls_set -> chiamate del calls set
* :func_name -> nome funzione"

# ╔═╡ be2b0330-74b3-11eb-0b25-69a72abfed80
md"le relazioni sono 
* :impl\_in -> input set dell'implementazione
* :impl\_fun -> funzione implementata
* :impl\_calls -> chiamate interne all implementazione"

# ╔═╡ eaa8c870-74b3-11eb-3524-319af923e6f4
cset[17,:impl_code]

# ╔═╡ 84bac4e0-74b4-11eb-1d7a-01cce428185a
md"possiamo cercare funzioni che abbiano un determinato tipo di input, in questo caso  AbstractACSet"

# ╔═╡ 3cea76c0-7495-11eb-36c3-3d69d099188d
inps = [IEP.getName(x) for x in cset[:,:in_set]]

# ╔═╡ eb9acfc0-7496-11eb-00e9-799fdd238e00
in_sets = findall((x)->("AbstractACSet" in x), inps)

# ╔═╡ b72eb940-74b4-11eb-269b-ab1cb1f438d0
length(in_sets)

# ╔═╡ 9fdc91e0-74b4-11eb-311f-a7f5f2dafb2e
md"avendo gli id di tutti gli input set contenenti AbstractACSet possiamo trovare tutte le implementazioni con quel input set"

# ╔═╡ 0b1dd400-7497-11eb-1fcf-ff1f6fad85ca
impls = findall((x)->(x in in_sets), cset[:,:impl_in])

# ╔═╡ bfd03240-74b4-11eb-0cb0-570cf8eef3d0
length(impls)

# ╔═╡ c7ea2bc0-74b4-11eb-2af9-f3da7e0d9b47
md"dalle impls possiamo risalire alle funzioni da esse implementate"

# ╔═╡ 3d6401a0-7497-11eb-0542-616282cc7a9f
funcs = unique(cset[cset[impls,:impl_fun],:func_name])#all names of Catlab functions that have AbstractACSet in input

# ╔═╡ cc705022-74b4-11eb-3f17-814cb49fac01
length(funcs)

# ╔═╡ ada5f3b0-7497-11eb-0250-8b6a2c48ba85
cset[impls,:impl_docs][1:26]

# ╔═╡ e482e780-7497-11eb-3389-f36c6b3eb36c
cset[impls,:impl_docs][27:end]

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
# ╠═6cd369c0-74b1-11eb-3a09-99306a8a359e
# ╟─825ce670-74ae-11eb-088f-a5bd4d7b8253
# ╠═5c41db80-74b3-11eb-25d3-77432dc27d33
# ╠═edd65f20-745a-11eb-0b5e-51dac44fe736
# ╠═f8deda80-74b1-11eb-21ed-fd52b85c7d69
# ╟─fedde340-74b1-11eb-1196-7578e3f28bb0
# ╠═13570c90-745b-11eb-277e-3ddc61691544
# ╠═a4e51790-74b2-11eb-2d8e-1714fccb68bd
# ╟─3f9ebb20-74b2-11eb-1030-4ffee1ad3648
# ╠═53ac65e0-74b2-11eb-3eec-3178f1f55ce9
# ╠═0b4f9a40-75c7-11eb-21bb-c53d76ecdc09
# ╠═b1dd3210-75c6-11eb-3600-5d01242a6b85
# ╠═b86f2c00-75c6-11eb-06ad-916b90ff532d
# ╟─c7bdef20-75c6-11eb-25f8-67ca3e2225b4
# ╟─53944a00-74b2-11eb-33e3-918248a2b9df
# ╟─c7d5cb52-74b2-11eb-38ac-d706839ab9aa
# ╟─be2b0330-74b3-11eb-0b25-69a72abfed80
# ╠═eaa8c870-74b3-11eb-3524-319af923e6f4
# ╟─84bac4e0-74b4-11eb-1d7a-01cce428185a
# ╠═3cea76c0-7495-11eb-36c3-3d69d099188d
# ╠═eb9acfc0-7496-11eb-00e9-799fdd238e00
# ╠═b72eb940-74b4-11eb-269b-ab1cb1f438d0
# ╟─9fdc91e0-74b4-11eb-311f-a7f5f2dafb2e
# ╠═0b1dd400-7497-11eb-1fcf-ff1f6fad85ca
# ╠═bfd03240-74b4-11eb-0cb0-570cf8eef3d0
# ╟─c7ea2bc0-74b4-11eb-2af9-f3da7e0d9b47
# ╠═3d6401a0-7497-11eb-0542-616282cc7a9f
# ╠═cc705022-74b4-11eb-3f17-814cb49fac01
# ╠═ada5f3b0-7497-11eb-0250-8b6a2c48ba85
# ╠═e482e780-7497-11eb-3389-f36c6b3eb36c
# ╠═a114c9f0-7497-11eb-1c00-5195cce34cd8
# ╠═68f3a0e0-7498-11eb-040b-ef167672630b
# ╠═841b3a40-7498-11eb-2066-a140c575e8a0
# ╠═c4239790-7498-11eb-3e6e-2b58967c1a4c
# ╠═44786010-7499-11eb-00ec-a53a3cf0c62a
# ╠═712891e0-7497-11eb-0fb8-8f53b799dfce
# ╠═791b2d3e-7497-11eb-36be-cb94b2a57e8b
# ╠═2d417e50-7498-11eb-241d-193d002f7940
# ╠═89873550-7499-11eb-0848-99303511aa1d
# ╠═8ead9150-7499-11eb-3bdf-5bbf50736eb2
# ╠═550893c0-7460-11eb-3f40-9b83c494e433
# ╠═5c9c6d50-7460-11eb-3507-9d6cb2fe12c7
# ╠═6bdd26b0-7460-11eb-04eb-956b3178890e
# ╠═722630c0-7460-11eb-0076-d54f8a6a6df4
