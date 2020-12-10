### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 0ac500c0-38ae-11eb-21d8-e1025829c9f1
using BenchmarkTools, Rmath, ArchGDAL

# ╔═╡ 7bbae410-38af-11eb-1c80-a5cbd32fd3e1
include("../../src/maketif/faux.jl")

# ╔═╡ 1ad5b452-38ae-11eb-318f-3719ba337ed0
include("../../src/maketif/eos_rastwrite_lines.jl")

# ╔═╡ bde6816e-38ad-11eb-17d6-358a2586f9fe
md"memory allocation when writing to raster

1. create cube"

# ╔═╡ f41b0042-38ad-11eb-227c-056bfc39def5
begin 
	height = 1195
	width = 1211
	nbands = 66
end

# ╔═╡ d66011d0-38ad-11eb-1123-c1ae3374fce8
source_cube = reshape(runif(height * width * nbands), (height,width,nbands) )

# ╔═╡ 75ead000-38ae-11eb-374a-3b94f67209cc
mkpath("")

# ╔═╡ 58c9d7a0-38ae-11eb-3786-690d8f632571
@benchmark rastwrite_lines(source_cube,"out/raster", overwrite=true)

# ╔═╡ 83490660-38b1-11eb-2322-53c30f880b8c
@time rastwrite_lines(source_cube,"out/raster", overwrite=true)

# ╔═╡ 72551ec0-38b1-11eb-2b1d-ef2e9cb8c66f
md"ok"

# ╔═╡ Cell order:
# ╠═0ac500c0-38ae-11eb-21d8-e1025829c9f1
# ╠═bde6816e-38ad-11eb-17d6-358a2586f9fe
# ╠═f41b0042-38ad-11eb-227c-056bfc39def5
# ╠═d66011d0-38ad-11eb-1123-c1ae3374fce8
# ╠═7bbae410-38af-11eb-1c80-a5cbd32fd3e1
# ╠═1ad5b452-38ae-11eb-318f-3719ba337ed0
# ╠═75ead000-38ae-11eb-374a-3b94f67209cc
# ╠═58c9d7a0-38ae-11eb-3786-690d8f632571
# ╠═83490660-38b1-11eb-2322-53c30f880b8c
# ╠═72551ec0-38b1-11eb-2b1d-ef2e9cb8c66f
