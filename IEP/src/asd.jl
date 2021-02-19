### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ b949a230-72c0-11eb-05b3-bbe5664c7f2d
using CSTParser

# ╔═╡ 51d0e850-72b3-11eb-1e5f-81b30af422dd
using FileIO

# ╔═╡ 3ad68fd0-72b1-11eb-3b33-332db7f7f6bf
include("function_CSet.jl")

# ╔═╡ 6148fe00-72b6-11eb-0d20-8dc5b09c67af
raw = read_code("./");

# ╔═╡ 5c9b94d0-72b1-11eb-10a2-6bace567087d
asd = scrape(raw);

# ╔═╡ 31a5aa40-72c0-11eb-2bd0-ad82f7aed0b3
_checkArgs

# ╔═╡ 5c97ed7e-72c0-11eb-0987-b90f8632c1ab
function find_heads(e::Array{Any,1}, h)
	res = []
	for asd in e
		res = vcat(res, find_heads(asd,h))
	end
	res
end

# ╔═╡ 25ce3390-72c0-11eb-275c-b79e75c4e153
function find_heads(e::CSTParser.EXPR,h)
	if e.head == h
		res = [e]
	else
		res = []
	end
	
	if _checkArgs(e)
		for arg in e.args
			res = vcat(res, find_heads(arg, h))
		end
	end
	res
end

# ╔═╡ 7f1964b0-72c0-11eb-25d3-977e08d2e7af
typeof(asd)

# ╔═╡ 7cc212c0-72b6-11eb-1843-3f0a26bc08a6
find_heads(raw, :call)

# ╔═╡ 8e2cf390-72c0-11eb-0006-151b0c547135
raw[7]

# ╔═╡ 74ca6e50-72b6-11eb-3707-47a06be3b2a6
find_heads([x[1] for x in raw], :struct)

# ╔═╡ cececf90-72b1-11eb-1ccf-7ff5747ddf5c
FunctionContainer

# ╔═╡ a3c70880-72b1-11eb-139a-89cb8464ef3c
funs = [[getName(x.func.name),x.source] for x in asd]

# ╔═╡ 3799b780-72b5-11eb-3fc0-1b0382d0204d
strr = string([string([tup[1], tup[2], "\n"]) for tup in funs])

# ╔═╡ f61170f0-72b4-11eb-2bf7-0f36b6d87ed1
io = open("functions.txt", "w");

# ╔═╡ 90bd3c60-72b5-11eb-0b6a-e5d8403e7f12
close(io)

# ╔═╡ 7a615be2-72b5-11eb-1683-c382e08610a9
for tup in funs
	write(io, string(tup[1],tup[2], "\n"))
end

# ╔═╡ Cell order:
# ╠═3ad68fd0-72b1-11eb-3b33-332db7f7f6bf
# ╠═6148fe00-72b6-11eb-0d20-8dc5b09c67af
# ╠═5c9b94d0-72b1-11eb-10a2-6bace567087d
# ╠═31a5aa40-72c0-11eb-2bd0-ad82f7aed0b3
# ╠═b949a230-72c0-11eb-05b3-bbe5664c7f2d
# ╠═5c97ed7e-72c0-11eb-0987-b90f8632c1ab
# ╠═25ce3390-72c0-11eb-275c-b79e75c4e153
# ╠═7f1964b0-72c0-11eb-25d3-977e08d2e7af
# ╠═7cc212c0-72b6-11eb-1843-3f0a26bc08a6
# ╠═8e2cf390-72c0-11eb-0006-151b0c547135
# ╠═74ca6e50-72b6-11eb-3707-47a06be3b2a6
# ╠═cececf90-72b1-11eb-1ccf-7ff5747ddf5c
# ╠═51d0e850-72b3-11eb-1e5f-81b30af422dd
# ╠═a3c70880-72b1-11eb-139a-89cb8464ef3c
# ╠═3799b780-72b5-11eb-3fc0-1b0382d0204d
# ╠═f61170f0-72b4-11eb-2bf7-0f36b6d87ed1
# ╠═90bd3c60-72b5-11eb-0b6a-e5d8403e7f12
# ╠═7a615be2-72b5-11eb-1683-c382e08610a9
