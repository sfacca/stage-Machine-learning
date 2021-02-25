### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 45bc8a80-77a7-11eb-051f-f72a421f3795
using Pkg

# ╔═╡ e462fbd0-77aa-11eb-1c62-cf7e5844bb9e
using JLD2

# ╔═╡ 81278630-778c-11eb-27c8-03e3def7f22b
include("../IEP.jl")

# ╔═╡ a3bf774e-77a7-11eb-020c-677baae4eceb
include("unzip.jl")

# ╔═╡ 2f791400-77a7-11eb-2bda-7d61304dd02d
#1 parse some code

# ╔═╡ 361239e0-77a7-11eb-15eb-d1b9e7e34d0c
catlab = IEP.read_code(Pkg.dir("Catlab"));

# ╔═╡ 7c423690-77a7-11eb-1412-690c9ce11690
flux = IEP.read_code(Pkg.dir("Flux"));

# ╔═╡ 97152040-77a7-11eb-37a9-49aaa9e3bd9e
begin
	mkpath("tmp/zoo")
	download("https://github.com/FluxML/model-zoo/archive/master.zip", "tmp/zoo/master.zip")
	unzip("tmp/zoo/master.zip")
	zoo = IEP.read_code("tmp/zoo")
	rm("tmp/zoo"; recursive = true)
end

# ╔═╡ d53869e0-77a7-11eb-056b-cf4fb931bde7
data = vcat(catlab, flux, zoo);

# ╔═╡ e5a26100-77a7-11eb-06bf-03a39eb4d0dc
dictionary = IEP.make_head_expr_dict([x[1] for x in data])

# ╔═╡ ab167980-77a8-11eb-1a8d-7ba6daa8b80b
function_containers = IEP.scrape(data);

# ╔═╡ 2645daf0-77aa-11eb-1576-1f65f0cb1a55
CSet  = IEP.get_newSchema(function_containers);

# ╔═╡ e21429d0-77aa-11eb-01dd-91f2f975c236
@save "CSet.jld2" CSet 

# ╔═╡ ffd077d0-77aa-11eb-0ce1-11f643e3f2af
@save "dictionary.jld2" dictionary

# ╔═╡ Cell order:
# ╠═81278630-778c-11eb-27c8-03e3def7f22b
# ╠═a3bf774e-77a7-11eb-020c-677baae4eceb
# ╠═45bc8a80-77a7-11eb-051f-f72a421f3795
# ╠═2f791400-77a7-11eb-2bda-7d61304dd02d
# ╠═361239e0-77a7-11eb-15eb-d1b9e7e34d0c
# ╠═7c423690-77a7-11eb-1412-690c9ce11690
# ╠═97152040-77a7-11eb-37a9-49aaa9e3bd9e
# ╠═d53869e0-77a7-11eb-056b-cf4fb931bde7
# ╠═e5a26100-77a7-11eb-06bf-03a39eb4d0dc
# ╠═ab167980-77a8-11eb-1a8d-7ba6daa8b80b
# ╠═2645daf0-77aa-11eb-1576-1f65f0cb1a55
# ╠═e462fbd0-77aa-11eb-1c62-cf7e5844bb9e
# ╠═e21429d0-77aa-11eb-01dd-91f2f975c236
# ╠═ffd077d0-77aa-11eb-0ce1-11f643e3f2af
