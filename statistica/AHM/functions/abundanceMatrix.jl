### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ c7892420-29c2-11eb-3012-097bc1f4974a
using NamedArrays, CategoricalArrays

# ╔═╡ cfc74770-29c2-11eb-0084-0f8d1e3af450
md"takes 2 arrays a,b of same length(not checked)      

creates matrix counting occurrence of same a*b couples
"

# ╔═╡ b34b1a8e-29c2-11eb-2ece-6575b605512a
# takes 2 arrays a,b of same length(not checked)
# creates matrix counting occurrence of same a*b couples


function abundanceMatrix(a::AbstractArray{T,1},b::AbstractArray{T,1}, rangeA::AbstractArray{T,1}, rangeB::AbstractArray{T,1}) where {T}
	
	
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
function abundanceMatrix(a::AbstractArray{T,1},b::AbstractArray{T,1},range::AbstractArray{T,1}; names=nothing) where {T}
	abundanceMatrix(a,b,range,range)
end

# ╔═╡ 7987cb80-29c9-11eb-2dc3-b7dbcea2fd48
function abundanceMatrix(a::AbstractArray{T,1},b::AbstractArray{T,1}) where {T}
	abundanceMatrix(a,b,sort(unique(vcat(a,b))))
end
	

# ╔═╡ 35775130-2a7e-11eb-1865-a762480f5547
function abundanceMatrix(a::CategoricalArrays.CategoricalArray{T},b::CategoricalArrays.CategoricalArray{T}) where {T}
	mapCA = Dict(value => key for (key, value) in a.pool.invindex)
	mapCB = Dict(value => key for (key, value) in b.pool.invindex)
	abundanceMatrix([mapCA[a[i].level] for i in 1:length(a)],[mapCB[b[i].level] for i in 1:length(b)],a.pool.levels,b.pool.levels)  	
	
end

# ╔═╡ d9f2e2e0-29c2-11eb-356f-5143a84c77b0
md"
examples are in abundanceMatrix_tests.jl
"

# ╔═╡ fbdcc400-2a7d-11eb-2f19-1301574ab4ed


# ╔═╡ Cell order:
# ╠═c7892420-29c2-11eb-3012-097bc1f4974a
# ╟─cfc74770-29c2-11eb-0084-0f8d1e3af450
# ╠═b34b1a8e-29c2-11eb-2ece-6575b605512a
# ╠═7fb4fe40-29cb-11eb-2c5a-d17a8296f22b
# ╠═7987cb80-29c9-11eb-2dc3-b7dbcea2fd48
# ╠═35775130-2a7e-11eb-1865-a762480f5547
# ╠═d9f2e2e0-29c2-11eb-356f-5143a84c77b0
# ╟─fbdcc400-2a7d-11eb-2f19-1301574ab4ed
