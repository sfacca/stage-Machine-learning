### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 887e2010-2f48-11eb-3bf8-453a3fbc5b6e
using RDatasets, Clustering, Random, LinearAlgebra, Plots; pyplot()

# ╔═╡ bf130e60-2f48-11eb-1d29-333f187deb3f
Random.seed!(0)

# ╔═╡ bf133570-2f48-11eb-2b75-8528dcdb7127
df = dataset("cluster", "xclara")

# ╔═╡ bf138390-2f48-11eb-0d0a-592d982d1884
n,_ = size(df)

# ╔═╡ bf172d12-2f48-11eb-039a-2dc67011d255
dataPoints = [convert(Array{Float64,1},df[i,:]) for i in 1:n]

# ╔═╡ bf177b30-2f48-11eb-21b7-fbebe5e74ead
Random.shuffle!(dataPoints)

# ╔═╡ bf1ad690-2f48-11eb-3a3d-bfe924478c4e
D = [LinearAlgebra.norm(pt1 - pt2) for pt1 in dataPoints, pt2 in dataPoints]

# ╔═╡ bf1cd260-2f48-11eb-3a7e-45a26f97124d
result = hclust(D)

# ╔═╡ bf1d2080-2f48-11eb-189e-d7bd4bb36118
for K in 1:30
	clusters = cutree(result,k=K)
	println("K=$(K): ",[sum(clusters .== i) for i in 1:K])
end

# ╔═╡ bf202dbe-2f48-11eb-12ec-dd6cfb23cef6
cluster(ell,K) = (1:n)[cutree(result,k=K) .== ell]

# ╔═╡ bf2250a0-2f48-11eb-09f4-8930e5cecef6
C1, C2, C3 = cluster(1,30),cluster(2,30),cluster(3,30)

# ╔═╡ bf229ec0-2f48-11eb-0fa9-2b6e4c57276f
plt = scatter( first.(dataPoints[C1]),last.(dataPoints[C1]),c=:blue, msw=0)

# ╔═╡ bf25d310-2f48-11eb-22ec-11eb54246fee
scatter!( first.(dataPoints[C2]),last.(dataPoints[C2]), c=:red, msw=0)

# ╔═╡ bf289230-2f48-11eb-155f-5b29f3341a2d
scatter!( first.(dataPoints[C3]),last.(dataPoints[C3]), c=:green, msw=0)

# ╔═╡ bf28e050-2f48-11eb-0179-b7ef8b7b8774
for ell in 4:30
	clst = cluster(ell,30)
	scatter!(first.(dataPoints[clst]),last.(dataPoints[clst]), ms=10, c=:purple, shape=:xcross, ratio=:equal, legend=:none, label="V1", ylabel="V2")
end

# ╔═╡ bf2c62c0-2f48-11eb-1467-693eea53f59b
plot(plt)

# ╔═╡ Cell order:
# ╠═887e2010-2f48-11eb-3bf8-453a3fbc5b6e
# ╠═bf130e60-2f48-11eb-1d29-333f187deb3f
# ╠═bf133570-2f48-11eb-2b75-8528dcdb7127
# ╠═bf138390-2f48-11eb-0d0a-592d982d1884
# ╠═bf172d12-2f48-11eb-039a-2dc67011d255
# ╠═bf177b30-2f48-11eb-21b7-fbebe5e74ead
# ╠═bf1ad690-2f48-11eb-3a3d-bfe924478c4e
# ╠═bf1cd260-2f48-11eb-3a7e-45a26f97124d
# ╠═bf1d2080-2f48-11eb-189e-d7bd4bb36118
# ╠═bf202dbe-2f48-11eb-12ec-dd6cfb23cef6
# ╠═bf2250a0-2f48-11eb-09f4-8930e5cecef6
# ╠═bf229ec0-2f48-11eb-0fa9-2b6e4c57276f
# ╠═bf25d310-2f48-11eb-22ec-11eb54246fee
# ╠═bf289230-2f48-11eb-155f-5b29f3341a2d
# ╠═bf28e050-2f48-11eb-0179-b7ef8b7b8774
# ╠═bf2c62c0-2f48-11eb-1467-693eea53f59b
