### A Pluto.jl notebook ###
# v0.12.12

using Markdown
using InteractiveUtils

# ╔═╡ 396c7020-30d4-11eb-3f8d-5b944a7a56fa
using LinearAlgebra, Random, Plots; pyplot()

# ╔═╡ 84e65660-30d4-11eb-02f7-4373bd365ae6
Random.seed!(1)

# ╔═╡ 850ec5ee-30d4-11eb-39c1-4586c71a292e
N = 10^4

# ╔═╡ 850f1410-30d4-11eb-2a06-5d2c8915c977
edges = [(1,2), (1,3), (2,4), (1,4), (3,4)]

# ╔═╡ 851332c0-30d4-11eb-09ee-73737f2db956
L = maximum(maximum.(edges))

# ╔═╡ 851555a2-30d4-11eb-3329-91eb9e3ae6e8
source, dest = 1, L

# ╔═╡ 85175172-30d4-11eb-19d1-f1c5dbd52ad3
function adjMatrix(edges,L)
	R = zeros(Int, L, L)
	for e in edges
		R[ e[1], e[2] ], R[ e[2], e[1] ] = 1, 1
	end
	R
end

# ╔═╡ 8517edb0-30d4-11eb-05c4-b31aa8793ac9
pathExists(R, source, destination) = sign.((I+R)^L)[source,destination]

# ╔═╡ 851bbe40-30d4-11eb-1475-b70c468ee123
randNet(p) = randsubseq(edges,1-p)

# ╔═╡ 851ea470-30d4-11eb-0da5-997046ced14b
relEst(p) = sum([pathExists(adjMatrix(randNet(p),L),source,dest) for _ in 1:N])/N

# ╔═╡ 851f19a0-30d4-11eb-3acc-31eb1ad6d658
relAnalytic(p) = 1-p^3*(p-2)^2

# ╔═╡ 85235f62-30d4-11eb-219b-65fa36e18144
pGrid = 0:0.05:1

# ╔═╡ 85266ca0-30d4-11eb-1a4d-65feeea212c6
scatter(pGrid, relEst.(pGrid),
	c=:blue, ms=5, msw=0,label="Monte Carlo")

# ╔═╡ 8526e1d2-30d4-11eb-3352-d9c03e6d4743
plot!(pGrid, relAnalytic.(pGrid),
	c=:red, label="Analytic", xlims=(0,1.05), ylims=(0,1.05),
	xlabel="p", ylabel="Reliability")

# ╔═╡ Cell order:
# ╠═396c7020-30d4-11eb-3f8d-5b944a7a56fa
# ╠═84e65660-30d4-11eb-02f7-4373bd365ae6
# ╠═850ec5ee-30d4-11eb-39c1-4586c71a292e
# ╠═850f1410-30d4-11eb-2a06-5d2c8915c977
# ╠═851332c0-30d4-11eb-09ee-73737f2db956
# ╠═851555a2-30d4-11eb-3329-91eb9e3ae6e8
# ╠═85175172-30d4-11eb-19d1-f1c5dbd52ad3
# ╠═8517edb0-30d4-11eb-05c4-b31aa8793ac9
# ╠═851bbe40-30d4-11eb-1475-b70c468ee123
# ╠═851ea470-30d4-11eb-0da5-997046ced14b
# ╠═851f19a0-30d4-11eb-3acc-31eb1ad6d658
# ╠═85235f62-30d4-11eb-219b-65fa36e18144
# ╠═85266ca0-30d4-11eb-1a4d-65feeea212c6
# ╠═8526e1d2-30d4-11eb-3352-d9c03e6d4743
