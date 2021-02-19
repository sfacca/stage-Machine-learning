### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ f08f9b10-6559-11eb-11bd-93294be81550
using Pkg

# ╔═╡ fbe716e0-655a-11eb-0582-e3b21000454c
using Catlab

# ╔═╡ 00508b80-655b-11eb-36ad-d551ddb1bf01
using CSTParser

# ╔═╡ ff3acb2e-6559-11eb-18ef-3757149cced5
include("parse_folder.jl")

# ╔═╡ 3fadb7e0-655f-11eb-0805-bd2964920f3d
# get the functions
include("scrape.jl")

# ╔═╡ 85c7b860-655b-11eb-04b4-213304c595d7
include("sample/sample.jl")

# ╔═╡ fa258630-6559-11eb-0c2d-557e08b6813f
#Pkg.activate(".")

# ╔═╡ 999c4730-655a-11eb-2da2-f7cbf7b03044
# we want to get an EXPR, then either turn it back into code or run it

# ╔═╡ a96fcab0-655a-11eb-2ca8-4fb34c8dccd3
parsed_folders = read_code("programs");

# ╔═╡ c0f1dbae-655a-11eb-1295-1fddecc67e91
parsed_expr = parsed_folders[3][1]

# ╔═╡ 8ec1ffc0-655b-11eb-156d-ebaef46ccfb0
parsed_folders[3][2]

# ╔═╡ d6de5890-655a-11eb-20d9-338131c265ce
begin
	eval(Expr(parsed_expr))# this runs the Expr
end

# ╔═╡ Cell order:
# ╠═f08f9b10-6559-11eb-11bd-93294be81550
# ╠═fa258630-6559-11eb-0c2d-557e08b6813f
# ╠═ff3acb2e-6559-11eb-18ef-3757149cced5
# ╠═999c4730-655a-11eb-2da2-f7cbf7b03044
# ╠═fbe716e0-655a-11eb-0582-e3b21000454c
# ╠═00508b80-655b-11eb-36ad-d551ddb1bf01
# ╠═a96fcab0-655a-11eb-2ca8-4fb34c8dccd3
# ╠═c0f1dbae-655a-11eb-1295-1fddecc67e91
# ╠═3fadb7e0-655f-11eb-0805-bd2964920f3d
# ╠═8ec1ffc0-655b-11eb-156d-ebaef46ccfb0
# ╠═d6de5890-655a-11eb-20d9-338131c265ce
# ╠═85c7b860-655b-11eb-04b4-213304c595d7
