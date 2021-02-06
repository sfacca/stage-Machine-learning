### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 1e02e500-68a9-11eb-2ee2-2dd45c722da3
using Pkg

# ╔═╡ 7c9c6c80-68a9-11eb-1964-ad12834af66f
using JLD2

# ╔═╡ 8643e3d0-68a9-11eb-113a-6fa7bc1dc424
using Catlab

# ╔═╡ 86d12fb0-68a9-11eb-1ef5-9b097ae0341a
using ZipFile

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
	#1 dl Tokenize source
	mkpath("tmp_tkn")
	download("https://github.com/JuliaLang/Tokenize.jl/archive/master.zip", "tmp_tkn/cstparser")
	unzip("tmp_tkn/cstparser")
	# 2 make CSet
	result = folder_to_CSet("tmp_tkn/Tokenize.jl-master/src")	
	# 3 save CSet
	@save "src_tokenize.jld2" result
	# 4 delete downloaded stuff
	rm("tmp_tkn", recursive=true)
end

# ╔═╡ Cell order:
# ╠═1e02e500-68a9-11eb-2ee2-2dd45c722da3
# ╠═1d5df270-68a9-11eb-325c-0d6b340835f6
# ╠═7c9c6c80-68a9-11eb-1964-ad12834af66f
# ╠═8643e3d0-68a9-11eb-113a-6fa7bc1dc424
# ╠═86d12fb0-68a9-11eb-1ef5-9b097ae0341a
# ╠═0df3df22-68a9-11eb-3b64-9f0050ce84f6
# ╠═0ed194f0-68a9-11eb-3563-478636247fcb
# ╠═192e2b70-68a9-11eb-283b-d9abc27c87be
# ╠═e19a1c9e-68a8-11eb-38b9-050f27cc460d
