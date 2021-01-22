### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 6cdbba12-5c3a-11eb-0236-a7b317e9eadd
using Pkg

# ╔═╡ 7cb4e2e0-5c3a-11eb-072c-2f79fcc49f00
using StaticLint

# ╔═╡ 75482a40-5c43-11eb-346e-2d3a6cd78583
using CSTParser

# ╔═╡ 6e4c8e80-5c42-11eb-1103-ddbba765b1e4
include("parse_folder.jl")

# ╔═╡ c691250e-5c42-11eb-04bb-c55938939e85
include("parse.jl")	

# ╔═╡ 243724d0-5c43-11eb-0481-09baecfc5cb7
include("view_Expr.jl")

# ╔═╡ 78c00200-5c3a-11eb-10df-2f58c6482ec0
Pkg.activate(".")

# ╔═╡ 6a14bbc0-5c43-11eb-183c-6de0c989dc5b
Pkg.add("CSTParser")

# ╔═╡ 8028d3f0-5c3a-11eb-3edc-751933ec5131
StaticLint.scopes

# ╔═╡ 7aba03a0-5c42-11eb-17df-6ba30490f02f
parsed_code = [x[1] for x in read_code("programs")];

# ╔═╡ 94f7bcc2-5c43-11eb-0d18-e5c94448f402
CST_parsed = CSTParser.parse(read("sample/sample.jl", String))

# ╔═╡ bb04d640-5c44-11eb-156d-5559e816400a
state = (scope = nothing)

# ╔═╡ 1af9f620-5c45-11eb-3b11-6785290cabfe
asdf = StaticLint.State()

# ╔═╡ 27743c82-5c45-11eb-0471-db0237b1ae67
fdsa = StaticLint.Delayed

# ╔═╡ 4f35640e-5c45-11eb-103c-bd8b8d0f416a
StaticLint.Scope()

# ╔═╡ 9d03c900-5c42-11eb-0918-a7eb9b4e11f8
StaticLint.scopes(CST_parsed)

# ╔═╡ d8a12b10-5c42-11eb-0d23-25ff816efad7
parsed_code[2]

# ╔═╡ 1ced2580-5c43-11eb-1395-2f625bbba29a
defs = Parsers.funcs(view_Expr(parsed_code[4]))

# ╔═╡ 444c2fe2-5c43-11eb-0a59-a195f6b5a8a1


# ╔═╡ Cell order:
# ╠═6cdbba12-5c3a-11eb-0236-a7b317e9eadd
# ╠═78c00200-5c3a-11eb-10df-2f58c6482ec0
# ╠═7cb4e2e0-5c3a-11eb-072c-2f79fcc49f00
# ╠═6a14bbc0-5c43-11eb-183c-6de0c989dc5b
# ╠═75482a40-5c43-11eb-346e-2d3a6cd78583
# ╠═8028d3f0-5c3a-11eb-3edc-751933ec5131
# ╠═6e4c8e80-5c42-11eb-1103-ddbba765b1e4
# ╠═7aba03a0-5c42-11eb-17df-6ba30490f02f
# ╠═94f7bcc2-5c43-11eb-0d18-e5c94448f402
# ╠═bb04d640-5c44-11eb-156d-5559e816400a
# ╠═1af9f620-5c45-11eb-3b11-6785290cabfe
# ╠═27743c82-5c45-11eb-0471-db0237b1ae67
# ╠═4f35640e-5c45-11eb-103c-bd8b8d0f416a
# ╠═9d03c900-5c42-11eb-0918-a7eb9b4e11f8
# ╠═d8a12b10-5c42-11eb-0d23-25ff816efad7
# ╠═c691250e-5c42-11eb-04bb-c55938939e85
# ╠═243724d0-5c43-11eb-0481-09baecfc5cb7
# ╠═1ced2580-5c43-11eb-1395-2f625bbba29a
# ╠═444c2fe2-5c43-11eb-0a59-a195f6b5a8a1
