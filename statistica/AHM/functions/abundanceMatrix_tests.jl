### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ f4879cf0-2a84-11eb-1173-cb74606b7f80
using CategoricalArrays, Rmath, LinearAlgebra

# ╔═╡ 675f06f0-2a85-11eb-3510-3beaea6a21ef
include("abundanceMatrix.jl")

# ╔═╡ d9f2e2e0-29c2-11eb-356f-5143a84c77b0
md"example:

"

# ╔═╡ bcea10f0-29c3-11eb-06d7-e3deb3882fd9
a=[1,3,3,2,5]

# ╔═╡ c0f49cb2-29c3-11eb-0978-d77863cd3c6a
b=[2,4,4,3,2]

# ╔═╡ 9f297d30-29c3-11eb-158e-011d0ab2d34a
N = abundanceMatrix(a,b)

# ╔═╡ 45440e3e-29cb-11eb-08e6-351753ad6be0
c1= ["ciao","asd","asd","foo"]

# ╔═╡ 4f9f452e-29cb-11eb-06c3-83a3d4aa67d7
c2= ["int","ciao","rew","asd"]

# ╔═╡ 5ef24e10-29cb-11eb-17c7-3d16db1e7619
abundanceMatrix(c1,c2,c1,c2)

# ╔═╡ 04203960-29cc-11eb-3273-ad4f5a658afc
abundanceMatrix(c1,c2)

# ╔═╡ d80ad09e-2a80-11eb-293a-b35ccae3b96a
M=Int(rpois(1, 100)[1])

# ╔═╡ 045ec390-2a7d-11eb-1dd4-4988721458ab
u1 = runif(M,0,10)

# ╔═╡ 0c1feeb0-2a7d-11eb-230e-0df60a85dd6a
u2 = runif(M,0,10)

# ╔═╡ 69e7f560-2a7d-11eb-0841-2fe5d43e5666
max=maximum([maximum(u1),maximum(u2)])

# ╔═╡ 6d326570-2a7d-11eb-343d-6fd6350ca635
maximum(u2)

# ╔═╡ 1daabf20-2a7d-11eb-1712-991add1fa8a9
breaks= collect(0:max/10:max)

# ╔═╡ 0f0e8320-2a7d-11eb-233c-55372dc25e84
abM = abundanceMatrix(cut(u1,breaks;extend = true),cut(u2,breaks;extend = true))

# ╔═╡ a5014110-2a82-11eb-289a-898bdf435411
size(abM)

# ╔═╡ 5058af40-2a7d-11eb-14b9-e147e0bcb50b
maximum

# ╔═╡ 859e44c0-2a7e-11eb-3e17-db48bfe42942
length(cut(u1,breaks))

# ╔═╡ ba76a40e-2a80-11eb-17fb-9d727cabf9b7
println("###################### marker ####################")

# ╔═╡ fbdcc400-2a7d-11eb-2f19-1301574ab4ed


# ╔═╡ aa6cb930-2a7e-11eb-162d-e7032f1b7e6b
cu1 = cut(u1, breaks)

# ╔═╡ bdc6e080-2a80-11eb-0f56-c51693a8e8b9
length(cu1)

# ╔═╡ c0d72dc0-2a80-11eb-1e06-7b2ab2a2ea52
cu1[102]

# ╔═╡ ba927b60-2a7e-11eb-00d5-61d053ee1bc2
asd = [cu1[i].level for i in 1:length(cu1)]

# ╔═╡ 8b504980-2a7f-11eb-1b66-efdb2c969533
typeof(asd)

# ╔═╡ af521f20-2a7f-11eb-15af-91b431fce3d9
typeof(cu1[1])

# ╔═╡ dbff58d0-2a7f-11eb-10ab-3b8f501d541f
cu1[1]

# ╔═╡ 0f75a200-2a80-11eb-303e-fd7cc8a06d73
cu1.pool[3]

# ╔═╡ d300567e-2a7f-11eb-1a63-d175efa7cfce
typeof(cu1[1].pool[1])

# ╔═╡ eaffd4e0-2a7f-11eb-16b8-6d26cb05ed0d
dump(cu1[1].pool)

# ╔═╡ 2fe2b820-2a80-11eb-2816-5f890284a069
cu1[1].level

# ╔═╡ 5b694c20-2a80-11eb-1918-336846abed40
cu1[2].level

# ╔═╡ 628efa92-2a80-11eb-31d9-850f51bbdbec
cu1[3]

# ╔═╡ 6cd94190-2a80-11eb-1c08-bd50155f204c
length(cu1.pool.levels)

# ╔═╡ 174adf70-2a82-11eb-0b14-e9069f601978
arcu1 = [cu1[i].level for i in 1:length(cu1)]

# ╔═╡ 0b7b7f10-2a82-11eb-3ac8-59464a1f58b7
length(unique(arcu1))

# ╔═╡ ed87fefe-2a82-11eb-26c7-eb17999ed9a0
cu1.pool.invindex

# ╔═╡ 590feb70-2a83-11eb-1721-c7c125c1e545
cu1[1]

# ╔═╡ 3310e640-2a83-11eb-1e2a-57503b00e9a0
Dict(value => key for (key, value) in cu1.pool.invindex)

# ╔═╡ Cell order:
# ╟─d9f2e2e0-29c2-11eb-356f-5143a84c77b0
# ╠═f4879cf0-2a84-11eb-1173-cb74606b7f80
# ╠═675f06f0-2a85-11eb-3510-3beaea6a21ef
# ╠═bcea10f0-29c3-11eb-06d7-e3deb3882fd9
# ╠═c0f49cb2-29c3-11eb-0978-d77863cd3c6a
# ╠═9f297d30-29c3-11eb-158e-011d0ab2d34a
# ╠═45440e3e-29cb-11eb-08e6-351753ad6be0
# ╠═4f9f452e-29cb-11eb-06c3-83a3d4aa67d7
# ╠═5ef24e10-29cb-11eb-17c7-3d16db1e7619
# ╠═04203960-29cc-11eb-3273-ad4f5a658afc
# ╠═d80ad09e-2a80-11eb-293a-b35ccae3b96a
# ╠═045ec390-2a7d-11eb-1dd4-4988721458ab
# ╠═0c1feeb0-2a7d-11eb-230e-0df60a85dd6a
# ╠═69e7f560-2a7d-11eb-0841-2fe5d43e5666
# ╠═6d326570-2a7d-11eb-343d-6fd6350ca635
# ╠═1daabf20-2a7d-11eb-1712-991add1fa8a9
# ╠═0f0e8320-2a7d-11eb-233c-55372dc25e84
# ╠═a5014110-2a82-11eb-289a-898bdf435411
# ╠═5058af40-2a7d-11eb-14b9-e147e0bcb50b
# ╠═859e44c0-2a7e-11eb-3e17-db48bfe42942
# ╠═ba76a40e-2a80-11eb-17fb-9d727cabf9b7
# ╟─fbdcc400-2a7d-11eb-2f19-1301574ab4ed
# ╠═aa6cb930-2a7e-11eb-162d-e7032f1b7e6b
# ╠═bdc6e080-2a80-11eb-0f56-c51693a8e8b9
# ╠═c0d72dc0-2a80-11eb-1e06-7b2ab2a2ea52
# ╠═ba927b60-2a7e-11eb-00d5-61d053ee1bc2
# ╠═8b504980-2a7f-11eb-1b66-efdb2c969533
# ╠═af521f20-2a7f-11eb-15af-91b431fce3d9
# ╠═dbff58d0-2a7f-11eb-10ab-3b8f501d541f
# ╠═0f75a200-2a80-11eb-303e-fd7cc8a06d73
# ╠═d300567e-2a7f-11eb-1a63-d175efa7cfce
# ╠═eaffd4e0-2a7f-11eb-16b8-6d26cb05ed0d
# ╠═2fe2b820-2a80-11eb-2816-5f890284a069
# ╠═5b694c20-2a80-11eb-1918-336846abed40
# ╠═628efa92-2a80-11eb-31d9-850f51bbdbec
# ╠═6cd94190-2a80-11eb-1c08-bd50155f204c
# ╠═174adf70-2a82-11eb-0b14-e9069f601978
# ╠═0b7b7f10-2a82-11eb-3ac8-59464a1f58b7
# ╠═ed87fefe-2a82-11eb-26c7-eb17999ed9a0
# ╠═590feb70-2a83-11eb-1721-c7c125c1e545
# ╠═3310e640-2a83-11eb-1e2a-57503b00e9a0
