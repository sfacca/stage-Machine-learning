### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 9b9bb260-1937-11eb-2d86-816ff68ce05b
using CMDimData

# ╔═╡ 3af4a040-193a-11eb-094f-f7208784354d
using CMDimData.EasyPlot

# ╔═╡ 3fe5945e-193a-11eb-2e35-a911f88ded2c
using CMDimData.MDDatasets

# ╔═╡ 6bf5ab10-1937-11eb-14ab-9f0d0337f110
md"EasyData è deprecato, usiamo  CMDimData.jl"

# ╔═╡ d8101380-1937-11eb-0e6e-03cb3841ab3e
md"### funzionalità principali

1. lavorare comodamente su dataframe multidimensionali  
2. rappresenta graficamente risultati multidimensionali usando modulo EasyPlot
3. leggi/scrivi grafici su HDF5 con modulo Ea<syData

### esempi"

# ╔═╡ cc4f2ab0-193a-11eb-2f4b-c52a0657b0c0
begin
	#==Attributes
	===============================================================================#
	linlin = cons(:a, xyaxes=set(:plot;xscale=:lin, yscale=:lin))
	alabels = cons(:a, labels=set(xaxis="X-Axis Label", yaxis="Y-Axis Label"))
	dfltline = cons(:a, line=set(style=:solid, color=:red))
	dfltglyph = cons(:a, glyph=set(shape=:square, size=3))


	#==Input data
	===============================================================================#
	x = collect(-2:0.01:2)
	graph = DataF1[]
	for _exp in 0:3
		push!(graph, DataF1(x, x.^_exp))
	end


	#==Generate EasyPlot
	===============================================================================#
	plot = push!(cons(:plot, linlin, alabels, title = "Polynomial Equations"),
		cons(:wfrm, graph[1], label="Constant"),
		cons(:wfrm, graph[2], label="Linear"),
		cons(:wfrm, graph[3], label="Quadratic"),
	)

	#Create individual waveform, and set parameters later, as an example (less readable):
	wfrm = cons(:wfrm, graph[4], label="Cubic")
		set(wfrm, dfltline, dfltglyph)
	push!(plot, wfrm) #Now add it to the list of plots

	pcoll = push!(cons(:plot_collection, title="Sample Plot"), plot)


	#==Return pcoll to user (call evalfile(...))
	===============================================================================#
	pcoll
end

# ╔═╡ 2c9c6030-193c-11eb-0f8b-f327a67cd559


# ╔═╡ 99782000-1940-11eb-09ae-0dc5c5cee70f
plot2 = cons(:plot, nstrips = 3,
   #Add more properties such as axis labels here
)

# ╔═╡ Cell order:
# ╟─6bf5ab10-1937-11eb-14ab-9f0d0337f110
# ╠═9b9bb260-1937-11eb-2d86-816ff68ce05b
# ╠═3af4a040-193a-11eb-094f-f7208784354d
# ╠═3fe5945e-193a-11eb-2e35-a911f88ded2c
# ╟─d8101380-1937-11eb-0e6e-03cb3841ab3e
# ╠═cc4f2ab0-193a-11eb-2f4b-c52a0657b0c0
# ╠═2c9c6030-193c-11eb-0f8b-f327a67cd559
# ╠═99782000-1940-11eb-09ae-0dc5c5cee70f
