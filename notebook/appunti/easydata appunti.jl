### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ ba2b1b72-1f64-11eb-333c-d16ef8432744
using CMDimData

# ╔═╡ c9fb1c80-1f64-11eb-1d51-953bd7fd3c00
using CMDimData.EasyPlot

# ╔═╡ 4c61d512-1f65-11eb-1ed1-2736ad3e6e49
using CMDimData.MDDatasets

# ╔═╡ 6bf5ab10-1937-11eb-14ab-9f0d0337f110
md"EasyData è deprecato, usiamo  CMDimData.jl

CMDimData registrato non è aggiornato, bisogna aggiungerlo direttamente da git?"

# ╔═╡ 6dc06c90-1f64-11eb-0d10-b9bd3acfc7aa
#include("get CMDimData.jl")

# ╔═╡ c4e7f9c0-1ad7-11eb-34a4-d7ad4edcbe11
CMDimData.@includepkg EasyPlotInspect

# ╔═╡ d8101380-1937-11eb-0e6e-03cb3841ab3e
md"### funzionalità principali

1. lavorare comodamente su dataframe multidimensionali  
2. rappresenta graficamente risultati multidimensionali usando modulo EasyPlot
3. leggi/scrivi grafici su HDF5 con modulo Ea<syData

### esempi"

# ╔═╡ 411f9980-1f65-11eb-1cc8-dd8211cf5085
#==Attributes
===============================================================================#
linlin = cons(:a, xyaxes=set(xscale=:lin, yscale=:lin))

# ╔═╡ 4123b82e-1f65-11eb-33f0-bb32028e2811
alabels = cons(:a, labels=set(xaxis="X-Axis Label", yaxis="Y-Axis Label"))

# ╔═╡ 4124c9a0-1f65-11eb-04f0-815a48609296
dfltline = cons(:a, line=set(style=:solid, color=:red))

# ╔═╡ 4127d6e0-1f65-11eb-317b-ff610ef73393
dfltglyph = cons(:a, glyph=set(shape=:square, size=3))

# ╔═╡ 4129f9c0-1f65-11eb-02a4-1732cd56396e
#==Input data
===============================================================================#
x = collect(-2:0.01:2)

# ╔═╡ 412b0b30-1f65-11eb-3b32-d534f6c7e14a
graph = DataF1[]

# ╔═╡ 412fed30-1f65-11eb-2276-510911b1b903
for _exp in 0:3
	push!(graph, DataF1(x, x.^_exp))
end

# ╔═╡ 41336fa0-1f65-11eb-3591-5f61a9515950
#==Generate EasyPlot
===============================================================================#
plot = push!(cons(:plot, linlin, alabels, title = "Polynomial Equations"),
	cons(:wfrm, graph[1], label="Constant"),
	cons(:wfrm, graph[2], label="Linear"),
	cons(:wfrm, graph[3], label="Quadratic"),
)

# ╔═╡ 413432f0-1f65-11eb-34cb-9f5e1e0364b8
#Create individual waveform, and set parameters later, as an example (less readable):
wfrm = cons(:wfrm, graph[4], label="Cubic")

# ╔═╡ 41382a90-1f65-11eb-2444-0bdaa6f7a4ce
set(wfrm, dfltline, dfltglyph)

# ╔═╡ 413bfb20-1f65-11eb-257f-8526d915c3f8
push!(plot, wfrm) #Now add it to the list of plots

# ╔═╡ 413ff2c0-1f65-11eb-3412-79adf16707fb
pcoll = push!(cons(:plot_collection, title="Sample Plot"), plot)

# ╔═╡ 41443880-1f65-11eb-23a5-37fe755f6576
#==Return pcoll to user (call evalfile(...))
===============================================================================#
pcoll

# ╔═╡ Cell order:
# ╟─6bf5ab10-1937-11eb-14ab-9f0d0337f110
# ╠═6dc06c90-1f64-11eb-0d10-b9bd3acfc7aa
# ╠═ba2b1b72-1f64-11eb-333c-d16ef8432744
# ╠═c9fb1c80-1f64-11eb-1d51-953bd7fd3c00
# ╠═4c61d512-1f65-11eb-1ed1-2736ad3e6e49
# ╠═c4e7f9c0-1ad7-11eb-34a4-d7ad4edcbe11
# ╟─d8101380-1937-11eb-0e6e-03cb3841ab3e
# ╠═411f9980-1f65-11eb-1cc8-dd8211cf5085
# ╠═4123b82e-1f65-11eb-33f0-bb32028e2811
# ╠═4124c9a0-1f65-11eb-04f0-815a48609296
# ╠═4127d6e0-1f65-11eb-317b-ff610ef73393
# ╠═4129f9c0-1f65-11eb-02a4-1732cd56396e
# ╠═412b0b30-1f65-11eb-3b32-d534f6c7e14a
# ╠═412fed30-1f65-11eb-2276-510911b1b903
# ╠═41336fa0-1f65-11eb-3591-5f61a9515950
# ╠═413432f0-1f65-11eb-34cb-9f5e1e0364b8
# ╠═41382a90-1f65-11eb-2444-0bdaa6f7a4ce
# ╠═413bfb20-1f65-11eb-257f-8526d915c3f8
# ╠═413ff2c0-1f65-11eb-3412-79adf16707fb
# ╠═41443880-1f65-11eb-23a5-37fe755f6576
