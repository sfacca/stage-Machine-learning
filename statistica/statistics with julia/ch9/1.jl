### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ f31508b0-2f3b-11eb-32c7-c1de6cbff440
using Flux, Flux.Data.MNIST, Statistics, BSON, StatsBase, Plots; pyplot()

# ╔═╡ 4c252ca0-2f3c-11eb-028f-fb0f6a59820e
using Flux: onecold

# ╔═╡ 4c4d9c30-2f3c-11eb-280e-6d42cd5fb7db
model= Chain(Conv((5, 5), 1=>8, relu), MaxPool((2,2)),
Conv((3, 3), 8=>16, relu), MaxPool((2,2)),
flatten, Dense(400, 10), softmax)

# ╔═╡ dd9e3000-2f46-11eb-3fd8-f10469a14fe0
mkpath("downloads")

# ╔═╡ e6e44d70-2f46-11eb-2907-973aae9e0ca5
download("https://github.com/h-Klok/StatsWithJuliaBook/raw/master/data/mnistConv.bson", "downloads/mnistConv.bson")

# ╔═╡ 4c4dea50-2f3c-11eb-2a1b-bd5cfbbf337d
BSON.@load "downloads/mnistConv.bson" modelParams

# ╔═╡ 4c52a540-2f3c-11eb-348b-93b95c24467e
Flux.loadparams!(model, modelParams)

# ╔═╡ 4c553d50-2f3c-11eb-3516-21a691b64217
function predictor(img)
whcn = ones(Float32,28,28, 1, 1)
whcn[:,:,1,1] = Float32.(img)
onecold(model(whcn),0:9)[1]
end

# ╔═╡ 4c558b72-2f3c-11eb-0003-1b8823d4d82b
testLabels = Flux.Data.MNIST.labels(:test)

# ╔═╡ 4c5934f0-2f3c-11eb-3d50-29e45526646b
testImages = Flux.Data.MNIST.images(:test)

# ╔═╡ 4c5b57d0-2f3c-11eb-2283-0b24ac47ca81
nTest = length(testLabels)

# ╔═╡ 4c5da1c0-2f3c-11eb-0784-8f1408b029fd
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

# ╔═╡ 4c6d8040-2f3c-11eb-3bcd-356c35b23c94
println("Percentage correctly classified: ", 100*nCorrect/nTest)

# ╔═╡ 4c70b490-2f3c-11eb-13dc-238fedf006aa
default(yflip = true, size = (1000,300),
legend=false,color = :Greys,ticks=false)

# ╔═╡ 4c7129c0-2f3c-11eb-0c28-47455d8354d1
p1 = heatmap(hcat(float.(testImages[goodExamples])...))

# ╔═╡ 4c754870-2f3c-11eb-24f4-a16856c6c9ab
p2 = heatmap(hcat(float.(testImages[badExamples])...))

# ╔═╡ 4c791900-2f3c-11eb-2854-cdfc797d5392
for i in 1:10
annotate!(28i-3,25,text("$(predictedBad[i])",18))
end

# ╔═╡ 4c798e30-2f3c-11eb-1711-1792833407a1
plot(p1,p2,layout=(2,1))

# ╔═╡ Cell order:
# ╠═f31508b0-2f3b-11eb-32c7-c1de6cbff440
# ╠═4c252ca0-2f3c-11eb-028f-fb0f6a59820e
# ╠═4c4d9c30-2f3c-11eb-280e-6d42cd5fb7db
# ╠═dd9e3000-2f46-11eb-3fd8-f10469a14fe0
# ╠═e6e44d70-2f46-11eb-2907-973aae9e0ca5
# ╠═4c4dea50-2f3c-11eb-2a1b-bd5cfbbf337d
# ╠═4c52a540-2f3c-11eb-348b-93b95c24467e
# ╠═4c553d50-2f3c-11eb-3516-21a691b64217
# ╠═4c558b72-2f3c-11eb-0003-1b8823d4d82b
# ╠═4c5934f0-2f3c-11eb-3d50-29e45526646b
# ╠═4c5b57d0-2f3c-11eb-2283-0b24ac47ca81
# ╠═4c5da1c0-2f3c-11eb-0784-8f1408b029fd
# ╠═4c6d8040-2f3c-11eb-3bcd-356c35b23c94
# ╠═4c70b490-2f3c-11eb-13dc-238fedf006aa
# ╠═4c7129c0-2f3c-11eb-0c28-47455d8354d1
# ╠═4c754870-2f3c-11eb-24f4-a16856c6c9ab
# ╠═4c791900-2f3c-11eb-2854-cdfc797d5392
# ╠═4c798e30-2f3c-11eb-1711-1792833407a1
