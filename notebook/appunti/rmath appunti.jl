### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ 53fb79f0-2034-11eb-0cd0-5fb3260d04aa
using Rmath

# ╔═╡ 6fdd89b0-2034-11eb-162b-214228a7dde5
md"rmath installa libreria contenente funzioni portate da R per distribuzioni

esempi:

### densità

dnorm(x, μ, σ) ritorna densità P(X=x) con X~N(μ,σ^2)"

# ╔═╡ bad03d90-203f-11eb-3e33-b365d0a7792b
dnorm(1)

# ╔═╡ df1ad4a0-2042-11eb-32d0-59680653d0d4
md"
### funzione di ripartizione

pnorm(x, μ, σ) ritorna probabilità P(X<=x) con X~N(μ,σ^2)"

# ╔═╡ b75b1730-2043-11eb-0558-d1a97bb27bc4
pnorm(1)

# ╔═╡ cb06f2e0-2043-11eb-356b-ffd534a05776
md"### quantile

qnorm(q, μ, σ) ritorna il valore al quantile q, in pratica qnorm(q) è funzione inversa di pnorm(x):"

# ╔═╡ a82c90d0-2044-11eb-2969-0f269a816cdd
x = qnorm(0.3)

# ╔═╡ b054e230-2044-11eb-36d7-1f83baff827b
pnorm(x)

# ╔═╡ cb815d90-2044-11eb-237b-87e9f0f877b2
md"
### numeri casuali

rnorm(n, μ, σ) da n numeri casuali"

# ╔═╡ ddfbbe1e-2044-11eb-1dd4-85e13a6950b7
rnorm(12)

# ╔═╡ bef0daa0-2045-11eb-1ee3-af7f17dc7303
md"### altre distribuzioni

similarmente si possono ottenere densità/ripartizione/etc di altre distribuzioni sostituendo norm a binom, pois, unif e altro

esempi:

pbinom(x,n,p) = P(X=x), X~Bi(n,p)"

# ╔═╡ 20dd5db0-2046-11eb-3096-af96e2f97499
pbinom(3,10,0.2)

# ╔═╡ 655c27f0-2046-11eb-3aa1-7dbbb7f64323
md"qpois(p, λ), ritorna x dove P(X=x)=p con X~POisson(λ)"

# ╔═╡ 6ddbe820-2046-11eb-3e21-d7760b79f395
qpois(0.6,3)

# ╔═╡ ae9f7f20-2046-11eb-24f1-f979e38b803c
md"runif(n) ritorna n numeri casuali generati da distribuzione uniforme"

# ╔═╡ b7e379b0-2046-11eb-07b0-6904959a0b68
runif(4)

# ╔═╡ Cell order:
# ╠═53fb79f0-2034-11eb-0cd0-5fb3260d04aa
# ╟─6fdd89b0-2034-11eb-162b-214228a7dde5
# ╠═bad03d90-203f-11eb-3e33-b365d0a7792b
# ╟─df1ad4a0-2042-11eb-32d0-59680653d0d4
# ╠═b75b1730-2043-11eb-0558-d1a97bb27bc4
# ╟─cb06f2e0-2043-11eb-356b-ffd534a05776
# ╠═a82c90d0-2044-11eb-2969-0f269a816cdd
# ╠═b054e230-2044-11eb-36d7-1f83baff827b
# ╟─cb815d90-2044-11eb-237b-87e9f0f877b2
# ╠═ddfbbe1e-2044-11eb-1dd4-85e13a6950b7
# ╟─bef0daa0-2045-11eb-1ee3-af7f17dc7303
# ╠═20dd5db0-2046-11eb-3096-af96e2f97499
# ╟─655c27f0-2046-11eb-3aa1-7dbbb7f64323
# ╠═6ddbe820-2046-11eb-3e21-d7760b79f395
# ╟─ae9f7f20-2046-11eb-24f1-f979e38b803c
# ╠═b7e379b0-2046-11eb-07b0-6904959a0b68
