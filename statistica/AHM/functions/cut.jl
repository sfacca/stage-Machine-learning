### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ eed94090-29a5-11eb-2de6-a566ec82be86
 using CategoricalArrays

# ╔═╡ a96e1ef0-28ff-11eb-157d-dd42eb8316b3
md"
### Convert Numeric to Factor
#### Description
cut divides the range of x into intervals and codes the values in x according to which interval they fall. The leftmost interval corresponds to level one, the next leftmost to level two and so on.


#### Default S3 method:
cut(x, breaks)  
##### Arguments  
* x	->  a numeric vector which is to be converted to a factor by cutting.  
* breaks -> either a numeric vector of two or more unique cut points or a single number (greater than or equal to 2) giving the number of intervals into which x is to be cut.

##### Details     
When breaks is specified as a single number, the range of the data is divided into breaks pieces of equal length, and then the outer limits are moved away by 0.1% of the range to ensure that the extreme values both fall within the break intervals. (If x is a constant vector, equal-length intervals are created, one of which includes the single value.)

The default method will sort a numeric vector of breaks, but other methods are not required to and labels will correspond to the intervals after sorting.

#### Value
A factor is returned

Values which fall outside the range of breaks are coded as NA, as are NaN and NA values."

# ╔═╡ 7a852610-28ff-11eb-0611-df6a9b042bee
#=function cut(x,breaks)
	
end=#

# ╔═╡ 2cb297e0-2901-11eb-21e8-a133d671d195
md"cut(x,breaks)
* x-> range o array
* breaks -> int o array

se breaks è int divide il range di valori di x in breaks intervalli, ritorna intervalli(Levels) e array di intervalli corrispettivi a ogni valore di x

"

# ╔═╡ b02e6ce0-29a4-11eb-2f35-5f98d3382e33
CategoricalArrays.cut

# ╔═╡ d2a34bd0-29a2-11eb-0a6f-0f865952ab7b
cc = cut([3,2,1,1,7],[1,2,4,8])

# ╔═╡ 611f8e20-29a6-11eb-3b56-2d07ae62fd4c
cc[1]

# ╔═╡ a55197f0-29a6-11eb-106c-f59c2f3fbe63
cc[2]

# ╔═╡ a87741f0-29a6-11eb-3cd5-43c4cc690607
cc[3]

# ╔═╡ d96f6bc0-29a6-11eb-2860-496901405860
cc[4]

# ╔═╡ 0156b8f2-29a7-11eb-1aee-5b61d22c5869
cc[5]

# ╔═╡ 5d4d09b0-29a3-11eb-3353-c16a44055405
DataFrames.PooledDataArray 

# ╔═╡ Cell order:
# ╠═eed94090-29a5-11eb-2de6-a566ec82be86
# ╟─a96e1ef0-28ff-11eb-157d-dd42eb8316b3
# ╠═7a852610-28ff-11eb-0611-df6a9b042bee
# ╟─2cb297e0-2901-11eb-21e8-a133d671d195
# ╠═b02e6ce0-29a4-11eb-2f35-5f98d3382e33
# ╠═d2a34bd0-29a2-11eb-0a6f-0f865952ab7b
# ╠═611f8e20-29a6-11eb-3b56-2d07ae62fd4c
# ╠═a55197f0-29a6-11eb-106c-f59c2f3fbe63
# ╠═a87741f0-29a6-11eb-3cd5-43c4cc690607
# ╠═d96f6bc0-29a6-11eb-2860-496901405860
# ╠═0156b8f2-29a7-11eb-1aee-5b61d22c5869
# ╠═5d4d09b0-29a3-11eb-3353-c16a44055405
