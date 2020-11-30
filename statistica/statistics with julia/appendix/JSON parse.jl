### A Pluto.jl notebook ###
# v0.12.12

using Markdown
using InteractiveUtils

# ╔═╡ 64ba0380-3329-11eb-3ddc-cfe4acd4ee4e
using HTTP, JSON

# ╔═╡ 7b1ccc60-332a-11eb-35ee-c17eefe7fe9a
data = HTTP.request("GET",
	"https://ocw.mit.edu/ans7870/6/6.006/s08/lecturenotes/files/t8.shakespeare.txt")

# ╔═╡ 7b47fb10-332a-11eb-2620-27a9d119028b
shakespeare = String(data.body)

# ╔═╡ 7b487042-332a-11eb-2180-5f4a72611e56
shakespeareWords = split(shakespeare)

# ╔═╡ 7b4c40d0-332a-11eb-0fa3-49c1ebd1af20
jsonWords = HTTP.request("GET",
	"https://github.com/h-Klok/StatsWithJuliaBook/raw/master/data/jsonCode.json")

# ╔═╡ 7b4c8ef0-332a-11eb-0e11-3f9234bf97d1
parsedJsonDict = JSON.parse( String(jsonWords.body))

# ╔═╡ 7b4fc340-332a-11eb-2c42-a142df37defc
keywords = Array{String}(parsedJsonDict["words"])

# ╔═╡ 7b51e620-332a-11eb-1d1d-d3a3a95ffe5a
numberToShow = parsedJsonDict["numToShow"]

# ╔═╡ 7b53e1f0-332a-11eb-1dc3-4f40a2d617fd
wordCount = Dict([(x,count(w -> lowercase(w) == lowercase(x), shakespeareWords))
		for x in keywords])

# ╔═╡ 7b545720-332a-11eb-283f-3d6a23e06f96
sortedWordCount = sort(collect(wordCount),by=last,rev=true)

# ╔═╡ 7b58eb00-332a-11eb-1a82-9f0969a25699
sortedWordCount[1:numberToShow]

# ╔═╡ Cell order:
# ╠═64ba0380-3329-11eb-3ddc-cfe4acd4ee4e
# ╠═7b1ccc60-332a-11eb-35ee-c17eefe7fe9a
# ╠═7b47fb10-332a-11eb-2620-27a9d119028b
# ╠═7b487042-332a-11eb-2180-5f4a72611e56
# ╠═7b4c40d0-332a-11eb-0fa3-49c1ebd1af20
# ╠═7b4c8ef0-332a-11eb-0e11-3f9234bf97d1
# ╠═7b4fc340-332a-11eb-2c42-a142df37defc
# ╠═7b51e620-332a-11eb-1d1d-d3a3a95ffe5a
# ╠═7b53e1f0-332a-11eb-1dc3-4f40a2d617fd
# ╠═7b545720-332a-11eb-283f-3d6a23e06f96
# ╠═7b58eb00-332a-11eb-1a82-9f0969a25699
