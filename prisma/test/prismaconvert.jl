### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ b578c6e0-3571-11eb-0811-7def2c1f240f
using Pkg, BenchmarkTools

# ╔═╡ 303525f0-3599-11eb-1ac8-cfacfd204a26
try 
	Pkg.add(url="https://github.com/sfacca/PrismaConvert")
	using PrismaConvert 
catch e
	e
end

# ╔═╡ d65942d0-3572-11eb-2630-a3c34373c62b
Pkg.activate(".")

# ╔═╡ 19ae64e0-3599-11eb-2e80-a712dacacf2d
fd = PrismaConvert.open("../prisma/hdf5/data/PRS_L2D_STD_20190911102308_20190911102313_0001.he5")

# ╔═╡ 17817290-3574-11eb-2030-6d05acaf6d35
try 
	x= @btime PrismaConvert.maketif(
	fd.dict["file 0"], 
	"out/PRS_L2D_STD_20190911102308_20190911102313_0001"
)
	PrismaConvert.close(fd)
	x
catch e
	PrismaConvert.close(fd)
	e
end

# ╔═╡ a0ddc910-3599-11eb-17e3-8d980989dfa8
fd

# ╔═╡ Cell order:
# ╠═b578c6e0-3571-11eb-0811-7def2c1f240f
# ╠═d65942d0-3572-11eb-2630-a3c34373c62b
# ╠═303525f0-3599-11eb-1ac8-cfacfd204a26
# ╠═19ae64e0-3599-11eb-2e80-a712dacacf2d
# ╠═17817290-3574-11eb-2030-6d05acaf6d35
# ╠═a0ddc910-3599-11eb-17e3-8d980989dfa8
