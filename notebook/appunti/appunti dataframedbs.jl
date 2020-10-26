### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 7e809d6e-1776-11eb-1095-7983f8ca2dab
using DataFrameDBs

# ╔═╡ 0a122ace-1799-11eb-1c94-4721324bd57d
md"+ https://waralex.github.io/DataFrameDBs.jl/dev/"

# ╔═╡ 5f1a7a90-1777-11eb-096a-6145ace4c19d
md"il pacchetto non è, al momento, nel sistema poacchetti julia, quindi va installato da git:"

# ╔═╡ 761e5ade-1777-11eb-38e6-61589aa6b0b0
#import Pkg; Pkg.add(Pkg.PackageSpec(url = "https://github.com/waralex/DataFrameDBs.jl.git"))

# ╔═╡ 904b67a0-1777-11eb-351d-63014d9d2214
md"creiamo e riempiamo una tabella di test"

# ╔═╡ acf7f34e-1777-11eb-2b61-4504cdbf0bfe
begin 
	t = empty_table("test_table")
	size = 3000000
	add_column!(t, :id, 1:size, show_progress = true)
	add_column!(t, :code, rand(1:1000, size), show_progress = true)
	brands = ["apple", "samsung", "huawai", "microsoft", "dell", "xbox", "sony", "intel"]
	add_column!(t, :brand, rand(brands, size), show_progress = true)
	add_column!(t, :price, rand(1.:0.1:2000., size), show_progress = true)
	table_stats(t)	
end

# ╔═╡ e3409660-1777-11eb-298c-0b425873581c
md"abbiamo creato una tabella con 4 colonne e 3 milioni di righe
pesa circa 40MB su disco e alloca circa 95MB di memoria con materializazzione completa.  

questa tabella è salvata su disco quindi può esser risllocata con: "

# ╔═╡ 1b40b7fe-1779-11eb-2bfd-9936f444a856
t2 = open_table("test_table")

# ╔═╡ 7da37520-177c-11eb-281c-4f10967e8813
md"possiamo materializzare l intera tabella:"

# ╔═╡ 9b318730-177c-11eb-0bda-978bb4137ee8
materialize(t)

# ╔═╡ a0ca5410-177c-11eb-1397-f3e63eef3e45
md"o anche solo la head della tabella"

# ╔═╡ ac549520-177c-11eb-02e7-b15d93124456
head(t)

# ╔═╡ b85ba74e-177c-11eb-0f60-f10155473703
md"## sezioni di tabella

il vantaggio di questo pacchetto è il materializzare dati solo quando ti servono:"

# ╔═╡ af9af110-177d-11eb-053c-3db4ef1a8027
view = t[:,[:brand,:price]]

# ╔═╡ b109ea60-177d-11eb-28df-dff555bb3f0a
md"view è una view pigra della tabella con solo 2 colonne  
tiene solo info su tabella di origine, regole di proiezione e selezione, ma non i dati veri e propri.

può esser materializzata con materialice()

prendiamo altre view"

# ╔═╡ efdb0ac0-177e-11eb-3c94-b952d91eb393
begin
	view1 = t[:,[:brand,:price]]
	view2 = view1[1:10:end, :]
	view1 = view1[1:5:end, :]
	view3 = view2[1:10, :]
	view4 = view3[[1,4,5], :];
end

# ╔═╡ 15ddb970-177f-11eb-06db-959a3d965d89
md"la materializzazione della view4 richiede solo le righe 1 4 e 5 della view3  
view3 sono le prime 10 righe di view2  
view2 sono le righe 1+10k  

quindi view4 sono le righe 1 31 e 41"

# ╔═╡ 9c796920-177f-11eb-26a0-218e3a43c17a
materialize(view4)

# ╔═╡ c231a480-1783-11eb-36cc-9d798860796d
md"colonne singole son rappresentati da dati di tipo (parametrico) DFColumn{T}.  
questo tipo non implementa abstractvector ma supporta iterazioni e getindex"

# ╔═╡ 1d8fb010-1784-11eb-3b18-a5493d779dc6
column = view.brand

# ╔═╡ 38379220-1784-11eb-1491-a9142674c4a0
view1[:,:brand]

# ╔═╡ 4c94e382-1784-11eb-3a96-af9695790da0
md"anche DFColumn è un tipo lazy non materializzato, si materializza con materialize"

# ╔═╡ b6b40212-178d-11eb-1b25-1fc6bfd492cc
unique(column)

# ╔═╡ bc4e5590-178d-11eb-1759-972cd544ebea
md"nell esemnpio antecedente la colonna è materializzata al volo e poi passata  a unique"

# ╔═╡ cd8a42b0-178d-11eb-3999-d92ff42d42aa
md"si può fare broadcast di colonna:"

# ╔═╡ e3eade20-178d-11eb-3618-83743dfc9876
t.price .* 10

# ╔═╡ e873c1a0-178d-11eb-23f4-67fb5268b8c4
md"durante iterazioni solo i blocchi richiesti son letti dal disco, quindi iterazione non richiede allocazione completa dei dati"

# ╔═╡ f6d25760-1798-11eb-013c-37d704a43be0
turnon_progress!(t)

# ╔═╡ 58eb32e0-179f-11eb-12b1-73ba18858d0d
md"Turn on showing progress of all read operation with this table"

# ╔═╡ ff22a320-1798-11eb-2b63-8d083131da10


# ╔═╡ Cell order:
# ╟─0a122ace-1799-11eb-1c94-4721324bd57d
# ╟─5f1a7a90-1777-11eb-096a-6145ace4c19d
# ╠═761e5ade-1777-11eb-38e6-61589aa6b0b0
# ╠═7e809d6e-1776-11eb-1095-7983f8ca2dab
# ╟─904b67a0-1777-11eb-351d-63014d9d2214
# ╠═acf7f34e-1777-11eb-2b61-4504cdbf0bfe
# ╟─e3409660-1777-11eb-298c-0b425873581c
# ╠═1b40b7fe-1779-11eb-2bfd-9936f444a856
# ╟─7da37520-177c-11eb-281c-4f10967e8813
# ╠═9b318730-177c-11eb-0bda-978bb4137ee8
# ╟─a0ca5410-177c-11eb-1397-f3e63eef3e45
# ╠═ac549520-177c-11eb-02e7-b15d93124456
# ╟─b85ba74e-177c-11eb-0f60-f10155473703
# ╠═af9af110-177d-11eb-053c-3db4ef1a8027
# ╟─b109ea60-177d-11eb-28df-dff555bb3f0a
# ╠═efdb0ac0-177e-11eb-3c94-b952d91eb393
# ╠═15ddb970-177f-11eb-06db-959a3d965d89
# ╠═9c796920-177f-11eb-26a0-218e3a43c17a
# ╟─c231a480-1783-11eb-36cc-9d798860796d
# ╠═1d8fb010-1784-11eb-3b18-a5493d779dc6
# ╠═38379220-1784-11eb-1491-a9142674c4a0
# ╟─4c94e382-1784-11eb-3a96-af9695790da0
# ╠═b6b40212-178d-11eb-1b25-1fc6bfd492cc
# ╟─bc4e5590-178d-11eb-1759-972cd544ebea
# ╟─cd8a42b0-178d-11eb-3999-d92ff42d42aa
# ╠═e3eade20-178d-11eb-3618-83743dfc9876
# ╟─e873c1a0-178d-11eb-23f4-67fb5268b8c4
# ╠═f6d25760-1798-11eb-013c-37d704a43be0
# ╟─58eb32e0-179f-11eb-12b1-73ba18858d0d
# ╠═ff22a320-1798-11eb-2b63-8d083131da10
