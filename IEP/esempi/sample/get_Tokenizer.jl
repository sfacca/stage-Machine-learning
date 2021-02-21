### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 1e02e500-68a9-11eb-2ee2-2dd45c722da3
using Pkg

# ╔═╡ 1ed8bfb0-6d98-11eb-0e7d-af360b401b59
using JLD2

# ╔═╡ 15b8a0d0-6d98-11eb-01c1-312e64523557
using ZipFile

# ╔═╡ 1972c2a0-6d98-11eb-0a2b-cd5583e0c391
using Catlab.Rewrite

# ╔═╡ 0df3df22-68a9-11eb-3b64-9f0050ce84f6
include("unzip.jl")

# ╔═╡ 0ed194f0-68a9-11eb-3563-478636247fcb
include("function_CSet.jl")

# ╔═╡ 192e2b70-68a9-11eb-283b-d9abc27c87be
include("functions_struct.jl")

# ╔═╡ 1d5df270-68a9-11eb-325c-0d6b340835f6
Pkg.activate(".")

# ╔═╡ e19a1c9e-68a8-11eb-38b9-050f27cc460d
begin
	# 2 make CSet
	result = folder_to_CSet(string(Pkg.dir("Tokenize"), "/src"))	
	# 3 save CSet
	@save "src_tokenize.jld2" result
end

# ╔═╡ d1e7a130-6d33-11eb-104d-0121bf54d8d4
result[2]

# ╔═╡ Cell order:
# ╠═1e02e500-68a9-11eb-2ee2-2dd45c722da3
# ╠═1d5df270-68a9-11eb-325c-0d6b340835f6
# ╠═0df3df22-68a9-11eb-3b64-9f0050ce84f6
# ╠═0ed194f0-68a9-11eb-3563-478636247fcb
# ╠═192e2b70-68a9-11eb-283b-d9abc27c87be
# ╠═1ed8bfb0-6d98-11eb-0e7d-af360b401b59
# ╠═15b8a0d0-6d98-11eb-01c1-312e64523557
# ╠═1972c2a0-6d98-11eb-0a2b-cd5583e0c391
# ╠═e19a1c9e-68a8-11eb-38b9-050f27cc460d
# ╠═d1e7a130-6d33-11eb-104d-0121bf54d8d4
