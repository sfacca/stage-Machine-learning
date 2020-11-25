### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 3e7623e0-2f49-11eb-0c79-21c6dfa1ce82
using Flux, MLDatasets, Statistics, Random, BSON

# ╔═╡ 980c40b0-2f49-11eb-0cd2-43f068c71ea6
using Flux.Optimise: update!

# ╔═╡ 980c8ed0-2f49-11eb-081a-698a92d92176
using Flux: logitbinarycrossentropy

# ╔═╡ 980cdcf0-2f49-11eb-1c54-1f5570466574
batchSize, latentDim = 500, 100

# ╔═╡ 981170d0-2f49-11eb-11a2-95b5a56eff0f
epochs = 40

# ╔═╡ 9811bef0-2f49-11eb-3008-11d59f037aec
etaD, etaG = 0.0002, 0.0002

# ╔═╡ 98151a50-2f49-11eb-1808-41aa9aa35668
images, _ = MLDatasets.MNIST.traindata(Float32)

# ╔═╡ 98156870-2f49-11eb-183f-9902586adbe7
imageTensor = reshape(@.(2f0 * images - 1f0), 28, 28, 1, :)

# ╔═╡ 9818c3d0-2f49-11eb-3d91-b5f7f0971e7a
data = [imageTensor[:, :, :, r] for r in Iterators.partition(1:60000, batchSize)]

# ╔═╡ 981b5be0-2f49-11eb-3271-0fff0dbcf0b1
dscr = Chain(Conv((4,4),1=>64;stride=2,pad=1),x->leakyrelu.(x,0.2f0),
	Dropout(0.25),Conv((4,4),64=>128;stride=2,pad=1),x->leakyrelu.(x,0.2f0),
	Dropout(0.25), x->reshape(x, 7 * 7 * 128, :), Dense(7 * 7 * 128, 1))

# ╔═╡ 981bd110-2f49-11eb-0e61-63dcdbf110ca
gen = Chain(Dense(latentDim,7*7*256),BatchNorm(7*7*256,relu),
	x->reshape(x,7,7,256,:),ConvTranspose((5,5),256=>128;stride=1,pad=2),
	BatchNorm(128,relu),ConvTranspose((4,4),128=>64;stride=2,pad=1),
	BatchNorm(64,relu),ConvTranspose((4,4),64=>1,tanh;stride=2,pad=1))

# ╔═╡ 981f7a90-2f49-11eb-2082-5b720480d1bf
dLoss(realOut,fakeOut) = mean(logitbinarycrossentropy.(realOut,1f0)) +
	mean(logitbinarycrossentropy.(fakeOut,0f0))

# ╔═╡ 981fc8b0-2f49-11eb-091b-8905e9b3414f
gLoss(u) = mean(logitbinarycrossentropy.(u, 1f0))

# ╔═╡ 9823c052-2f49-11eb-2d6d-419cc9ac8430
function updateD!(gen, dscr, x, opt_dscr)
	noise = randn!(similar(x, (latentDim, batchSize)))
	fakeInput = gen(noise)
	ps = Flux.params(dscr)
	loss, back = Flux.pullback(()->dLoss(dscr(x), dscr(fakeInput)), ps)
	grad = back(1f0)
	update!(opt_dscr, ps, grad)
	return loss
end

# ╔═╡ 98267f70-2f49-11eb-104f-db00349dac7a
function updateG!(gen, dscr, x, optGen)
	noise = randn!(similar(x, (latentDim, batchSize)))
	ps = Flux.params(gen)
	loss, back = Flux.pullback(()->gLoss(dscr(gen(noise))),ps)
	grad = back(1f0)
	update!(optGen, ps, grad)
	return loss
end

# ╔═╡ 982742c2-2f49-11eb-2394-6b85b9b228ae
optDscr, optGen = ADAM(etaD), ADAM(etaG)

# ╔═╡ 982b1350-2f49-11eb-0f56-d9c87bc005ec
cd(@__DIR__)

# ╔═╡ 982e479e-2f49-11eb-16d8-a772e2ef207f
@time begin
	for ep in 1:epochs
		for (bi,x) in enumerate(data)
			lossD = updateD!(gen, dscr, x, optDscr)
			lossG = updateG!(gen, dscr, x, optGen)
			@info "Epoch $ep, batch $bi, D loss = $(lossD), G loss = $(lossG)"
		end
		@info "Saving generator for epcoh $ep"
		BSON.@save "../data/mnistGAN$(ep).bson" genParams=cpu.(params(gen))
	end
end

# ╔═╡ Cell order:
# ╠═3e7623e0-2f49-11eb-0c79-21c6dfa1ce82
# ╠═980c40b0-2f49-11eb-0cd2-43f068c71ea6
# ╠═980c8ed0-2f49-11eb-081a-698a92d92176
# ╠═980cdcf0-2f49-11eb-1c54-1f5570466574
# ╠═981170d0-2f49-11eb-11a2-95b5a56eff0f
# ╠═9811bef0-2f49-11eb-3008-11d59f037aec
# ╠═98151a50-2f49-11eb-1808-41aa9aa35668
# ╠═98156870-2f49-11eb-183f-9902586adbe7
# ╠═9818c3d0-2f49-11eb-3d91-b5f7f0971e7a
# ╠═981b5be0-2f49-11eb-3271-0fff0dbcf0b1
# ╠═981bd110-2f49-11eb-0e61-63dcdbf110ca
# ╠═981f7a90-2f49-11eb-2082-5b720480d1bf
# ╠═981fc8b0-2f49-11eb-091b-8905e9b3414f
# ╠═9823c052-2f49-11eb-2d6d-419cc9ac8430
# ╠═98267f70-2f49-11eb-104f-db00349dac7a
# ╠═982742c2-2f49-11eb-2394-6b85b9b228ae
# ╠═982b1350-2f49-11eb-0f56-d9c87bc005ec
# ╠═982e479e-2f49-11eb-16d8-a772e2ef207f
