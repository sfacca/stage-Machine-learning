### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 09e98130-704e-11eb-1e07-31a126204edc
using Pkg, Catlab, JLD2, FileIO, CSTParser

# ╔═╡ 10324380-72c7-11eb-2b72-052eea2f67ac
include("")#src_dict.jl

# ╔═╡ f5ed4950-7052-11eb-3535-35dc92fd985e
md"
# estrazione docstring
"

# ╔═╡ 0488e912-7053-11eb-0b0a-17da3947c6ed
sample = read_code("sample");

# ╔═╡ 0c33a600-7053-11eb-1bd8-67dcbcf7ccd2
sample_code = [x[1] for x in sample];#per l'esempio ci servono solo le expr

# ╔═╡ 2884cb40-7053-11eb-2d7a-fb50c1ab474e
sample_expr = sample_code[1]#vediamo una funzione

# ╔═╡ 3689d050-7053-11eb-1f05-7d24fd19b7bc
sample_expr.args #vediamo nodi sibling dell'expr

# ╔═╡ 3bddcc00-7053-11eb-03c6-39ee63128e03
sample_expr.args[1] # quasta expr notifica presenza docstring

# ╔═╡ 53da8b40-7053-11eb-3fe6-272f6f5252b3
sample_expr.args[1].head

# ╔═╡ 59918e80-7053-11eb-0abc-efec93a48a72
sample_expr.args[1].val

# ╔═╡ 5c8e05a0-7053-11eb-10e5-bd4d75101dfb
sample_expr.args[3] 
#contenuti docstring sono nell var del nodo triplestring successivo (dopo un sibling vuoto)

# ╔═╡ 7e4268ce-7053-11eb-06ff-2598cada082f
sample_expr.args[3].head

# ╔═╡ 6f437360-7053-11eb-0c85-c587f2ec6a29
sample_expr.args[3].val

# ╔═╡ b96802d0-7053-11eb-2362-51652e9bc8d0
sample_expr.args[4] # la docstring si riferisce all'expr sibling successiva

# ╔═╡ Cell order:
# ╠═09e98130-704e-11eb-1e07-31a126204edc
# ╠═10324380-72c7-11eb-2b72-052eea2f67ac
# ╟─f5ed4950-7052-11eb-3535-35dc92fd985e
# ╠═0488e912-7053-11eb-0b0a-17da3947c6ed
# ╠═0c33a600-7053-11eb-1bd8-67dcbcf7ccd2
# ╠═2884cb40-7053-11eb-2d7a-fb50c1ab474e
# ╠═3689d050-7053-11eb-1f05-7d24fd19b7bc
# ╠═3bddcc00-7053-11eb-03c6-39ee63128e03
# ╠═53da8b40-7053-11eb-3fe6-272f6f5252b3
# ╠═59918e80-7053-11eb-0abc-efec93a48a72
# ╠═5c8e05a0-7053-11eb-10e5-bd4d75101dfb
# ╠═7e4268ce-7053-11eb-06ff-2598cada082f
# ╠═6f437360-7053-11eb-0c85-c587f2ec6a29
# ╠═b96802d0-7053-11eb-2362-51652e9bc8d0
