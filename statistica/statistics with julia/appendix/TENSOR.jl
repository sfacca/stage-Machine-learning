### A Pluto.jl notebook ###
# v0.12.12

using Markdown
using InteractiveUtils

# ╔═╡ 2a450292-332e-11eb-22eb-81a5ff87208b
using Flux, Flux.Data.MNIST, Statistics, BSON, StatsBase, Plots; pyplot()

# ╔═╡ 03b8c6a0-3330-11eb-3fd7-e1b0c27eff27
using Flux: onecold

# ╔═╡ 03b8edae-3330-11eb-26f3-8b3d0b489b66
model= Chain(Conv((5, 5), 1=>8, relu), MaxPool((2,2)),
	Conv((3, 3), 8=>16, relu), MaxPool((2,2)),
	flatten, Dense(400, 10), softmax)

# ╔═╡ 03b93bd0-3330-11eb-02e3-2b6850717cf9
mkpath("downloads")

# ╔═╡ 03bdcfb0-3330-11eb-2857-034229a2401b
download("https://github.com/h-Klok/StatsWithJuliaBook/raw/master/data/mnistConv.bson","downloads/mnistConv.bson")

# ╔═╡ 03be1dd0-3330-11eb-2688-1d3ccb57b189
BSON.@load "downloads/mnistConv.bson" modelParams

# ╔═╡ 03c12b10-3330-11eb-20fc-8befdd467745
Flux.loadparams!(model, modelParams)

# ╔═╡ 03c34df0-3330-11eb-2dce-175ddfbe286c
function predictor(img)
	whcn = ones(Float32,28,28, 1, 1)
	whcn[:,:,1,1] = Float32.(img)
	onecold(model(whcn),0:9)[1]
end

# ╔═╡ 03c3c320-3330-11eb-14bf-c9649715de06
testLabels = Flux.Data.MNIST.labels(:test)

# ╔═╡ 03c793b0-3330-11eb-000e-7ffe7e6fb75b
testImages = Flux.Data.MNIST.images(:test)

# ╔═╡ 03c82ff0-3330-11eb-0ae5-eb8c2bcc48fe
nTest = length(testLabels)

# ╔═╡ 0ae33000-3330-11eb-115f-d91f0cff5574
begin
	iC, iR = 0, 0
	nCorrect = 0
	goodExamples = zeros(Int,10)
	badExamples = zeros(Int,10)
	predictedBad = zeros(Int,10)
	for i in 1:nTest
		prediction = predictor(testImages[i])
		trueLabel = testLabels[i]
		predictionIsCorrect = (prediction == trueLabel)
		global nCorrect += predictionIsCorrect
		global iC; global iR
		if predictionIsCorrect && trueLabel == iC
			goodExamples[iC+1] = i
			iC += 1
		end
		if !predictionIsCorrect && trueLabel == iR
			badExamples[iR+1] = i
			predictedBad[iR+1] = prediction
			iR += 1
		end
	end
	
	
end

# ╔═╡ 03db42c0-3330-11eb-04fe-fbf5bffa58f2
println("Percentage correctly classified: ", 100*nCorrect/nTest)

# ╔═╡ 03de7710-3330-11eb-2f3b-db2aab31e5eb
default(yflip = true, size = (1000,300),
	legend=false,color = :Greys,ticks=false)

# ╔═╡ 03deec40-3330-11eb-0aa5-df5f87d828b8
p1 = heatmap(hcat(float.(testImages[goodExamples])...))

# ╔═╡ 03e3f550-3330-11eb-2772-9dfe9e9c0b2a
p2 = heatmap(hcat(float.(testImages[badExamples])...))

# ╔═╡ 03e46a80-3330-11eb-364a-33ae25e1223d
for i in 1:10
	annotate!(28i-3,25,text("$(predictedBad[i])",18))
end

# ╔═╡ 03e88930-3330-11eb-0c1c-8bff3969f802
plot(p1,p2,layout=(2,1))

# ╔═╡ Cell order:
# ╠═2a450292-332e-11eb-22eb-81a5ff87208b
# ╠═03b8c6a0-3330-11eb-3fd7-e1b0c27eff27
# ╠═03b8edae-3330-11eb-26f3-8b3d0b489b66
# ╠═03b93bd0-3330-11eb-02e3-2b6850717cf9
# ╠═03bdcfb0-3330-11eb-2857-034229a2401b
# ╠═03be1dd0-3330-11eb-2688-1d3ccb57b189
# ╠═03c12b10-3330-11eb-20fc-8befdd467745
# ╠═03c34df0-3330-11eb-2dce-175ddfbe286c
# ╠═03c3c320-3330-11eb-14bf-c9649715de06
# ╠═03c793b0-3330-11eb-000e-7ffe7e6fb75b
# ╠═03c82ff0-3330-11eb-0ae5-eb8c2bcc48fe
# ╠═0ae33000-3330-11eb-115f-d91f0cff5574
# ╠═03db42c0-3330-11eb-04fe-fbf5bffa58f2
# ╠═03de7710-3330-11eb-2f3b-db2aab31e5eb
# ╠═03deec40-3330-11eb-0aa5-df5f87d828b8
# ╠═03e3f550-3330-11eb-2772-9dfe9e9c0b2a
# ╠═03e46a80-3330-11eb-364a-33ae25e1223d
# ╠═03e88930-3330-11eb-0c1c-8bff3969f802
