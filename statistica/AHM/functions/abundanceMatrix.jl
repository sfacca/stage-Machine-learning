### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ c7892420-29c2-11eb-3012-097bc1f4974a
using NamedArrays

# ╔═╡ cfc74770-29c2-11eb-0084-0f8d1e3af450
md"takes 2 arrays a,b of same length(not checked)      

creates matrix counting occurrence of same a*b couples
"

# ╔═╡ b34b1a8e-29c2-11eb-2ece-6575b605512a
# takes 2 arrays a,b of same length(not checked)
# creates matrix counting occurrence of same a*b couples


function abundanceMatrix(a::Array{T,1},b::Array{T,1}, rangeA::Array{T,1}, rangeB::Array{T,1}) where {T}
	
	rangeA = unique(rangeA)
	mapA = Dict([(rangeA[i],i) for i in 1:length(rangeA)])
	
	rangeB = unique(rangeB)
	mapB = Dict([(rangeB[i],i) for i in 1:length(rangeB)])
	
	res = reshape(
		[0 for _ in 1:(length(rangeA)*length(rangeB))], 
		length(rangeA), length(rangeB)
	)
	for i in 1:length(a)
		res[mapA[a[i]],mapB[b[i]]] += 1
	end
	
	NamedArray(res, (rangeA,rangeB))
end

#= eg
[3,2,1,1], [] -> 


=#

# ╔═╡ 7fb4fe40-29cb-11eb-2c5a-d17a8296f22b
function abundanceMatrix(a::Array{T,1},b::Array{T,1},range::Array{T,1}) where {T}
	abundanceMatrix(a,b,range,range)
end

# ╔═╡ 7987cb80-29c9-11eb-2dc3-b7dbcea2fd48
function abundanceMatrix(a::Array{T,1},b::Array{T,1}) where {T}
	abundanceMatrix(a,b,sort(unique(vcat(a,b))))
end
	

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

# ╔═╡ Cell order:
# ╠═c7892420-29c2-11eb-3012-097bc1f4974a
# ╟─cfc74770-29c2-11eb-0084-0f8d1e3af450
# ╠═b34b1a8e-29c2-11eb-2ece-6575b605512a
# ╠═7fb4fe40-29cb-11eb-2c5a-d17a8296f22b
# ╠═7987cb80-29c9-11eb-2dc3-b7dbcea2fd48
# ╟─d9f2e2e0-29c2-11eb-356f-5143a84c77b0
# ╠═bcea10f0-29c3-11eb-06d7-e3deb3882fd9
# ╠═c0f49cb2-29c3-11eb-0978-d77863cd3c6a
# ╠═9f297d30-29c3-11eb-158e-011d0ab2d34a
# ╠═45440e3e-29cb-11eb-08e6-351753ad6be0
# ╠═4f9f452e-29cb-11eb-06c3-83a3d4aa67d7
# ╠═5ef24e10-29cb-11eb-17c7-3d16db1e7619
# ╠═04203960-29cc-11eb-3273-ad4f5a658afc
