### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 52c1266e-3583-11eb-1202-475bb2abfd39
using LightGraphs, DataFrames, GraphPlot

# ╔═╡ c0350ef0-3584-11eb-209d-af5649585e8f
files = readdir("../../PrismaConvert/src/maketif")

# ╔═╡ b9a28350-3585-11eb-3c56-173aebe3bef5
df = DataFrame((files, collect(1:length(files))))

# ╔═╡ 97cd6e30-3584-11eb-3914-ddbc59baf6e3
g = SimpleDiGraph{Int}(size(df)[1])

# ╔═╡ 4b7b1760-3586-11eb-10a1-ade05c1144f5
function add_edges!(g,a::Int,b::Array)
	for i in b
		add_edge!(g,a,i)
	end
end

# ╔═╡ 033fba4e-3586-11eb-2cb0-53cf35025fdb
add_edges!(g, 1, [9,2,5,3])

# ╔═╡ 203b9e80-3586-11eb-3493-b1c1225dd283
add_edges!(g,2,[9,7,6,4,8])

# ╔═╡ 9e59b0e0-3586-11eb-1619-177b8a093d93
add_edges!(g,3,[9,8])

# ╔═╡ ae9c9800-3586-11eb-17b8-7357433d18d2
add_edges!(g,4,[8])

# ╔═╡ b036e710-3586-11eb-0335-ef725a08e252
add_edges!(g,5,[9,7,8])

# ╔═╡ f316bc70-3588-11eb-262e-855b1d257973
add_edges!(g,7,[9])

# ╔═╡ 02c4415e-3589-11eb-27d5-a19de3614d36
add_edges!(g,8,[9])

# ╔═╡ 0d251da0-3589-11eb-0273-6370ae3aae07
gplot(
	g,
	nodelabel=df[!,:x1],
	nodelabeldist=1.8, 
	nodelabelangleoffset=π/4,
	layout=circular_layout
)

# ╔═╡ c13b4ca0-358a-11eb-071a-0316a6ea55c7
gplot(h)

# ╔═╡ Cell order:
# ╠═52c1266e-3583-11eb-1202-475bb2abfd39
# ╠═c0350ef0-3584-11eb-209d-af5649585e8f
# ╠═b9a28350-3585-11eb-3c56-173aebe3bef5
# ╠═97cd6e30-3584-11eb-3914-ddbc59baf6e3
# ╠═4b7b1760-3586-11eb-10a1-ade05c1144f5
# ╠═033fba4e-3586-11eb-2cb0-53cf35025fdb
# ╠═203b9e80-3586-11eb-3493-b1c1225dd283
# ╠═9e59b0e0-3586-11eb-1619-177b8a093d93
# ╠═ae9c9800-3586-11eb-17b8-7357433d18d2
# ╠═b036e710-3586-11eb-0335-ef725a08e252
# ╠═f316bc70-3588-11eb-262e-855b1d257973
# ╠═02c4415e-3589-11eb-27d5-a19de3614d36
# ╠═0d251da0-3589-11eb-0273-6370ae3aae07
# ╠═c13b4ca0-358a-11eb-071a-0316a6ea55c7
