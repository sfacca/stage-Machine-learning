### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 44cbf940-388b-11eb-1a45-057f9ca0f5b1
using BenchmarkTools, Plots, Rmath

# ╔═╡ 4cdf6310-388b-11eb-146d-51c8d2bd020d
md"1 creo cubo grande cui bande verranno copiate"

# ╔═╡ 67235330-388b-11eb-201a-dd4f8e4acd4f
begin
	bands_slider = @bind nbands html"
		<input type='range' min='1' max='200' step='1' value='173'>
	"
	width_slider = @bind width html"
		<input type='range' min='1' max='2000' step='1' value='1211'>
	"
	height_slider = @bind height html"
	<input type='range' min='1' max='2000' step='1' value='1195'>
	"
	
	md"""bands:   
	$(bands_slider) 
	
	width:  
	$(width_slider) 
	
	height: 
	$(height_slider)  
	"""
end

# ╔═╡ 59097bb0-388d-11eb-2f48-e9dc65f5d7e2
md"bands: $(nbands)

width: $(width)

height: $(height)
"

# ╔═╡ 37f08342-388f-11eb-2863-cddb0b7b52f2
function init_source()
	global source_cube = reshape(runif(height * width * nbands), (height,width,nbands) )
end

# ╔═╡ c8fc1642-3882-11eb-1a7d-1511dfdb9d30
init_source()

# ╔═╡ 8f225700-389f-11eb-1e3d-bf62ea08ae84
source_cube

# ╔═╡ c447ebf0-38a1-11eb-31e5-7f9f494bca16
@bind range1 html"""
		<input type='range' min='1' max='$(nbands)' step='1' value='$(nbands)'>
	"""

# ╔═╡ eb49e230-38a1-11eb-3fda-7395d8afbecd
range1

# ╔═╡ ca42fd10-38a1-11eb-3d84-7df7106ce603
tg_range = collect(1:range1)

# ╔═╡ 92343010-388d-11eb-3014-3d022135314b
md"
### method 1: 
create product cube by recursively running cat(rast,band,dims=3)"

# ╔═╡ 1b4ffaf0-388e-11eb-2e00-81e2c5125bfe
function no_prealloc_recursive_cat(arr, source)
	res = nothing
	ind = 1
	for i in arr
		band = source[:,:,i]
		if ind == 1
			res = band
		else
			res = cat(res,band,dims=3)
		end
		ind = ind +1
	end
	res
end
		

# ╔═╡ e13e03c0-38a1-11eb-0cc7-afca638b2a41
function foo1(a)
	global res1 = a(tg_range, source_cube)
end

# ╔═╡ a1d98230-388e-11eb-20f1-9d3d178209be
bench_1 = @benchmark foo1(no_prealloc_recursive_cat)

# ╔═╡ 459987d0-389e-11eb-2676-c54faa8b0fd1
res1

# ╔═╡ cf7e92f0-389a-11eb-2bea-75e757ac5298
md"
## method 2
preallocate empty cube of product sizes, then recursively assign values
"

# ╔═╡ f5de2eb0-389a-11eb-1d0b-0304d7b42f57
function prealloc_recursive_assign(arr, source)
	res = Array{typeof(source[1,1,1]),3}(undef,size(source)[1],size(source)[2], length(arr))
	for i in 1:length(arr)
		res[:,:,i] = source[:,:,arr[i]]
	end
	res
end

# ╔═╡ 6037f730-38a2-11eb-3cf4-71aa05e9506f
function foo2(a)
	global res2 = a(tg_range, source_cube)
end

# ╔═╡ f6b6c850-3882-11eb-009c-f1099887f92f


# ╔═╡ 602536b0-389b-11eb-0b39-1b871512d447


# ╔═╡ 65a683ee-389b-11eb-3f56-3f7100591f12


# ╔═╡ 6d0b1020-389b-11eb-0a3c-bf44540bbee5
bench_2 = @benchmark foo2(prealloc_recursive_assign)

# ╔═╡ 9f187650-38a2-11eb-186f-79f6002cc646
res2

# ╔═╡ 43f03f40-388b-11eb-3405-3ff0075acedf
res1 == res2

# ╔═╡ be5cce70-38a3-11eb-25b1-2b6f0713239c
dump(bench_2)

# ╔═╡ df9ee7d0-38a3-11eb-3a57-939eec0a1ae0
println("######################")

# ╔═╡ ee9fd910-38a3-11eb-10b2-71454436ebcd
typeof(source_cube[1,1,1])

# ╔═╡ 7d4076d0-38a8-11eb-2777-358a3da315c0


# ╔═╡ Cell order:
# ╠═44cbf940-388b-11eb-1a45-057f9ca0f5b1
# ╠═4cdf6310-388b-11eb-146d-51c8d2bd020d
# ╠═67235330-388b-11eb-201a-dd4f8e4acd4f
# ╠═59097bb0-388d-11eb-2f48-e9dc65f5d7e2
# ╠═37f08342-388f-11eb-2863-cddb0b7b52f2
# ╠═c8fc1642-3882-11eb-1a7d-1511dfdb9d30
# ╠═8f225700-389f-11eb-1e3d-bf62ea08ae84
# ╟─c447ebf0-38a1-11eb-31e5-7f9f494bca16
# ╟─eb49e230-38a1-11eb-3fda-7395d8afbecd
# ╟─ca42fd10-38a1-11eb-3d84-7df7106ce603
# ╟─92343010-388d-11eb-3014-3d022135314b
# ╠═1b4ffaf0-388e-11eb-2e00-81e2c5125bfe
# ╠═e13e03c0-38a1-11eb-0cc7-afca638b2a41
# ╠═a1d98230-388e-11eb-20f1-9d3d178209be
# ╠═459987d0-389e-11eb-2676-c54faa8b0fd1
# ╟─cf7e92f0-389a-11eb-2bea-75e757ac5298
# ╠═f5de2eb0-389a-11eb-1d0b-0304d7b42f57
# ╠═6037f730-38a2-11eb-3cf4-71aa05e9506f
# ╟─f6b6c850-3882-11eb-009c-f1099887f92f
# ╟─602536b0-389b-11eb-0b39-1b871512d447
# ╟─65a683ee-389b-11eb-3f56-3f7100591f12
# ╠═6d0b1020-389b-11eb-0a3c-bf44540bbee5
# ╠═9f187650-38a2-11eb-186f-79f6002cc646
# ╠═43f03f40-388b-11eb-3405-3ff0075acedf
# ╠═be5cce70-38a3-11eb-25b1-2b6f0713239c
# ╠═df9ee7d0-38a3-11eb-3a57-939eec0a1ae0
# ╠═ee9fd910-38a3-11eb-10b2-71454436ebcd
# ╠═7d4076d0-38a8-11eb-2777-358a3da315c0
