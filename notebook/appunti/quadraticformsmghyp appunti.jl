### A Pluto.jl notebook ###
# v0.12.8

using Markdown
using InteractiveUtils

# ╔═╡ adc80760-2416-11eb-1f3c-db65a5b0f0f2
using QuadraticFormsMGHyp

# ╔═╡ c705e210-242a-11eb-368e-bd949d64024c
md"
* https://s-broda.github.io/QuadraticFormsMGHyp.jl/stable/
"

# ╔═╡ a7974040-2416-11eb-28ad-c3099cb77666
md"il pacchetto implementa algoritmi descritti in https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3369208

tratta la generalizzazione degli algoriotmi di Imhof e  Broda nel caso di vettori iperbolici casuali multivariari generici

esporta una funzione singola: 

qfmgh(x::Union{AbstractVector{<:Real}, Real}, a0, a, A, C, mu, gam, lam, chi, psi; do_spa=false, order=2)"

# ╔═╡ 12b6b6d0-242b-11eb-2396-f3893012f913
md"$L = a0 + a' * X + X' * A * X$
where:

$X = mu + W * gam + sqrt(W) * C * Z$
$Z ~ N(0, I)$
$W ~ GIG(lam, chi, psi)$
i.e., X is distributed as multivariate GHyp."

# ╔═╡ Cell order:
# ╟─c705e210-242a-11eb-368e-bd949d64024c
# ╠═adc80760-2416-11eb-1f3c-db65a5b0f0f2
# ╟─a7974040-2416-11eb-28ad-c3099cb77666
# ╟─12b6b6d0-242b-11eb-2396-f3893012f913
