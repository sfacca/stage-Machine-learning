### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ 15ad43c0-2a7c-11eb-0ab0-69788c13937e
using CategoricalArrays

# ╔═╡ 1fa9dff0-2a7c-11eb-2bca-59ad98e7526e
using Rmath

# ╔═╡ 23ef78e0-2a7c-11eb-165e-650706bb7be7
arr = runif(Int(rpois(1, 100)[1]),0,10)

# ╔═╡ 60426f50-2a7c-11eb-22c4-a128fba41455
breaks = 0:10

# ╔═╡ 64d36920-2a7c-11eb-1dce-fbaceaf6856d
catArr = cut(arr,breaks)

# ╔═╡ 97879ad0-2a7c-11eb-120c-c927769fd87d
dump(catArr)

# ╔═╡ 9e3a8a40-2a7c-11eb-19ef-3189f9cfb6a3
catArr[1]

# ╔═╡ Cell order:
# ╠═15ad43c0-2a7c-11eb-0ab0-69788c13937e
# ╠═1fa9dff0-2a7c-11eb-2bca-59ad98e7526e
# ╠═23ef78e0-2a7c-11eb-165e-650706bb7be7
# ╠═60426f50-2a7c-11eb-22c4-a128fba41455
# ╠═64d36920-2a7c-11eb-1dce-fbaceaf6856d
# ╠═97879ad0-2a7c-11eb-120c-c927769fd87d
# ╠═9e3a8a40-2a7c-11eb-19ef-3189f9cfb6a3
