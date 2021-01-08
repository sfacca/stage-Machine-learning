### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 012fd152-51ba-11eb-38e1-9b040342d1af
using Pkg

# ╔═╡ 179c7ab0-51ba-11eb-3935-315493ca3c94
using Catlab

# ╔═╡ f4006bc0-51b9-11eb-2f72-f9127978f46f
#mkpath("")

# ╔═╡ 3d8ac5c0-51b4-11eb-3356-83d81f347bd2
download("https://github.com/jpfairbanks/SemanticModels.jl/raw/master/src/exprmodels/parse.jl","parse.jl")

# ╔═╡ 2ef0bfc0-51cc-11eb-314e-87bdc9d8ffee
download("https://github.com/jpfairbanks/SemanticModels.jl/raw/master/src/exprmodels/macrotools.jl","macrotools.jl")

# ╔═╡ 2ef098b0-51cc-11eb-0545-5d6761848258
download("https://github.com/jpfairbanks/SemanticModels.jl/raw/master/src/exprmodels/findfunc.jl","findfunc.jl")

# ╔═╡ 0b9d57c0-51ba-11eb-1378-6d3580de9151
Pkg.activate(".")

# ╔═╡ 0fd5d150-51ba-11eb-1fcb-59217dc3304a
Pkg.add("Catlab")

# ╔═╡ Cell order:
# ╠═f4006bc0-51b9-11eb-2f72-f9127978f46f
# ╠═3d8ac5c0-51b4-11eb-3356-83d81f347bd2
# ╠═2ef0bfc0-51cc-11eb-314e-87bdc9d8ffee
# ╠═2ef098b0-51cc-11eb-0545-5d6761848258
# ╠═012fd152-51ba-11eb-38e1-9b040342d1af
# ╠═0b9d57c0-51ba-11eb-1378-6d3580de9151
# ╠═0fd5d150-51ba-11eb-1fcb-59217dc3304a
# ╠═179c7ab0-51ba-11eb-3935-315493ca3c94
