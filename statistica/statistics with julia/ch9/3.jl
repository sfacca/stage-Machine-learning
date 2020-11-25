### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ f3566c90-2f3d-11eb-19b9-d1f60d424a71
using Flux, Random, LinearAlgebra, CSV

# ╔═╡ 4ff89b72-2f3f-11eb-1a43-959e4469c357
using Flux.Optimise: update!

# ╔═╡ e14d4df0-2f49-11eb-019b-6315e01abcee
using DataFrames

# ╔═╡ 4ff8e990-2f3f-11eb-3ba6-9566b6a4fb7b
Random.seed!(0)

# ╔═╡ 9da90530-2f49-11eb-0639-eb58511c6dbb
mkpath("downloads")

# ╔═╡ a2cd6560-2f49-11eb-296f-ed23de8a2148
download("https://github.com/h-Klok/StatsWithJuliaBook/raw/master/data/L1L2data.csv","downloads/L1L2data.csv")

# ╔═╡ 4ffb81a0-2f3f-11eb-356d-e570d8e5c2ef
data = CSV.read("downloads/L1L2data.csv", DataFrame)

# ╔═╡ 4ffd5660-2f3f-11eb-21c5-3d7bacbc2d7a
xVals, yVals = Array{Float64}(data.X), Array{Float64}(data.Y)

# ╔═╡ 4ffdcb90-2f3f-11eb-2250-07bd6b1e977c
eta = 0.05

# ╔═╡ 5000ffe0-2f3f-11eb-1173-03a526cf761c
epsilon = 10^-7

# ╔═╡ 5002ad90-2f3f-11eb-3102-6548c6e760f3
b = rand(2)

# ╔═╡ 500397f0-2f3f-11eb-3d01-4fe5821267df
predict(x) = b[1] .+ b[2]*x

# ╔═╡ 5006cc40-2f3f-11eb-122b-657b920f8d01
loss(x,y) = sum((y .- predict(x)).^2)

# ╔═╡ 50076880-2f3f-11eb-08e1-374469cd6d9b
opt = ADAM(eta)

# ╔═╡ 407002a0-2f4a-11eb-2721-e39764eb59dd
begin
	global iter, gradNorm = 0, 1.0
	while gradNorm >= epsilon
		gs = gradient(()->loss(xVals,yVals),params(b))
		update!(opt,b,gs[b])
		global gradNorm = norm(gs[b])
		global iter += 1
	end
	
end

# ╔═╡ 500f57c0-2f3f-11eb-237d-ef4ae0211de6
println("Number of iterations: ", iter)

# ╔═╡ 500fa5de-2f3f-11eb-31bb-97342d904d9f
println("Coefficients:", b)

# ╔═╡ Cell order:
# ╠═f3566c90-2f3d-11eb-19b9-d1f60d424a71
# ╠═4ff89b72-2f3f-11eb-1a43-959e4469c357
# ╠═e14d4df0-2f49-11eb-019b-6315e01abcee
# ╠═4ff8e990-2f3f-11eb-3ba6-9566b6a4fb7b
# ╠═9da90530-2f49-11eb-0639-eb58511c6dbb
# ╠═a2cd6560-2f49-11eb-296f-ed23de8a2148
# ╠═4ffb81a0-2f3f-11eb-356d-e570d8e5c2ef
# ╠═4ffd5660-2f3f-11eb-21c5-3d7bacbc2d7a
# ╠═4ffdcb90-2f3f-11eb-2250-07bd6b1e977c
# ╠═5000ffe0-2f3f-11eb-1173-03a526cf761c
# ╠═5002ad90-2f3f-11eb-3102-6548c6e760f3
# ╠═500397f0-2f3f-11eb-3d01-4fe5821267df
# ╠═5006cc40-2f3f-11eb-122b-657b920f8d01
# ╠═50076880-2f3f-11eb-08e1-374469cd6d9b
# ╠═407002a0-2f4a-11eb-2721-e39764eb59dd
# ╠═500f57c0-2f3f-11eb-237d-ef4ae0211de6
# ╠═500fa5de-2f3f-11eb-31bb-97342d904d9f
