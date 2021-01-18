### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 2975c0a0-590a-11eb-1943-33ac3cc96fea
using Pkg

# ╔═╡ 366efb00-590a-11eb-2cb6-955181576fb7
using Catlab.WiringDiagrams

# ╔═╡ 3eca6a50-590a-11eb-125f-0ff2439103a0
using Catlab.Graphics

# ╔═╡ 5116cb20-590c-11eb-01af-816e6bd2ef95
using Catlab.Theories

# ╔═╡ 3228c5d0-590a-11eb-2b15-43c038b7c441
Pkg.activate(".")

# ╔═╡ 3ecadf80-590a-11eb-3681-b1e963cec82a
import Catlab.Graphics: Graphviz

# ╔═╡ 3ecb7bc0-590a-11eb-05b7-6997a7fb60db
show_diagram(d::WiringDiagram) = to_graphviz(d,
  orientation=LeftToRight,
  labels=true, label_attr=:xlabel,
  node_attrs=Graphviz.Attributes(
    :fontname => "Courier",
  ),
  edge_attrs=Graphviz.Attributes(
    :fontname => "Courier",
  )
)

# ╔═╡ 7fef2230-590c-11eb-0272-9994d5533784
A, B, C, D = Ob(FreeBiproductCategory, :A, :B, :C, :D)

# ╔═╡ 7fef4940-590c-11eb-1955-8d01353b0315
f = Hom(:f, A, B)

# ╔═╡ 7fef9760-590c-11eb-0fb6-a7a4ffcb421b
g = Hom(:g, B, C)

# ╔═╡ 7ff25680-590c-11eb-0624-bbfce84e2661
h = Hom(:h, C, D)

# ╔═╡ 7ff58ad0-590c-11eb-21ba-4396f2e85819
f

# ╔═╡ 882b22a0-590c-11eb-2925-7d2d94d4c69b


# ╔═╡ Cell order:
# ╠═2975c0a0-590a-11eb-1943-33ac3cc96fea
# ╠═3228c5d0-590a-11eb-2b15-43c038b7c441
# ╠═366efb00-590a-11eb-2cb6-955181576fb7
# ╠═3eca6a50-590a-11eb-125f-0ff2439103a0
# ╠═3ecadf80-590a-11eb-3681-b1e963cec82a
# ╠═3ecb7bc0-590a-11eb-05b7-6997a7fb60db
# ╠═5116cb20-590c-11eb-01af-816e6bd2ef95
# ╠═7fef2230-590c-11eb-0272-9994d5533784
# ╠═7fef4940-590c-11eb-1955-8d01353b0315
# ╠═7fef9760-590c-11eb-0fb6-a7a4ffcb421b
# ╠═7ff25680-590c-11eb-0624-bbfce84e2661
# ╠═7ff58ad0-590c-11eb-21ba-4396f2e85819
# ╠═882b22a0-590c-11eb-2925-7d2d94d4c69b
