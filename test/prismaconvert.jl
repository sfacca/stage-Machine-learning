### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ b578c6e0-3571-11eb-0811-7def2c1f240f
using Pkg, BenchmarkTools

# ╔═╡ 9d0b47a0-3575-11eb-2650-2948af6902e5
using PrismaConvert

# ╔═╡ ead9d3a0-3572-11eb-17de-431c1b97eea0
include("")

# ╔═╡ d65942d0-3572-11eb-2630-a3c34373c62b
Pkg.activate(".")

# ╔═╡ e60b82ae-3572-11eb-04e9-552e40d9cf55
Pkg.add(url="https://github.com/sfacca/PrismaConvert")

# ╔═╡ 17817290-3574-11eb-2030-6d05acaf6d35
@btime PrismaConvert.maketif()

# ╔═╡ Cell order:
# ╠═b578c6e0-3571-11eb-0811-7def2c1f240f
# ╠═d65942d0-3572-11eb-2630-a3c34373c62b
# ╠═ead9d3a0-3572-11eb-17de-431c1b97eea0
# ╠═e60b82ae-3572-11eb-04e9-552e40d9cf55
# ╠═9d0b47a0-3575-11eb-2650-2948af6902e5
# ╠═17817290-3574-11eb-2030-6d05acaf6d35
