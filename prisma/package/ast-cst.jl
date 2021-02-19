### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 6998f292-3945-11eb-11c7-991f6fadf102
using BenchmarkTools

# ╔═╡ c7959f00-395f-11eb-3df4-4b37c03f0a74
using PrismaConvert

# ╔═╡ 1e516b50-3963-11eb-04a7-073ca56bf41b
using TreeView

# ╔═╡ 63548b50-3964-11eb-0761-ad7a2f40142f
function parse_file(path::AbstractString)
    code = read(path, String)
    Meta.parse("begin $code end")
end

# ╔═╡ 687ce320-3964-11eb-259a-0faeee68324e
eos_convert_parsed = parse_file("../src/maketif/eos_convert.jl")

# ╔═╡ 1069c760-3965-11eb-0f69-e7ca83b407a1
walk_tree(eos_convert_parsed)

# ╔═╡ Cell order:
# ╠═6998f292-3945-11eb-11c7-991f6fadf102
# ╠═c7959f00-395f-11eb-3df4-4b37c03f0a74
# ╠═1e516b50-3963-11eb-04a7-073ca56bf41b
# ╠═63548b50-3964-11eb-0761-ad7a2f40142f
# ╠═687ce320-3964-11eb-259a-0faeee68324e
# ╠═1069c760-3965-11eb-0f69-e7ca83b407a1
