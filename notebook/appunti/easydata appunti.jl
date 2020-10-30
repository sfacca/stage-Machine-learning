### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 9b9bb260-1937-11eb-2d86-816ff68ce05b
using CMDimData

# ╔═╡ 3af4a040-193a-11eb-094f-f7208784354d
using CMDimData.EasyPlot

# ╔═╡ 3fe5945e-193a-11eb-2e35-a911f88ded2c
using CMDimData.MDDatasets

# ╔═╡ 1345db2e-1ada-11eb-2b0f-4bd81ea1aaa7
using InspectDR

# ╔═╡ 6bf5ab10-1937-11eb-14ab-9f0d0337f110
md"EasyData è deprecato, usiamo  CMDimData.jl"

# ╔═╡ c4e7f9c0-1ad7-11eb-34a4-d7ad4edcbe11
#CMDimData.@includepkg EasyPlotInspect

# ╔═╡ d8101380-1937-11eb-0e6e-03cb3841ab3e
md"### funzionalità principali

1. lavorare comodamente su dataframe multidimensionali  
2. rappresenta graficamente risultati multidimensionali usando modulo EasyPlot
3. leggi/scrivi grafici su HDF5 con modulo Ea<syData

### esempi"

# ╔═╡ 87186ae0-1ad6-11eb-2d7d-cfc2f141ef98
#==Constants
===============================================================================#
const linlin = paxes(xscale = :lin, yscale = :lin)

# ╔═╡ f1bb2770-1ad6-11eb-1006-f3ebe71619d2
const alabels = paxes(xlabel="X-Axis Label", ylabel="X-Axis Label")

# ╔═╡ f1bc11d0-1ad6-11eb-3ae6-d54e44ef54df
#Defaults
#-------------------------------------------------------------------------------
dfltline = line(style=:solid, color=:red)

# ╔═╡ f1be82d0-1ad6-11eb-0ec2-53c91bf0506d
dfltglyph = glyph(shape=:square, size=3)

# ╔═╡ f1c25362-1ad6-11eb-3b83-d38020d27991
#==Input data
===============================================================================#
x = collect(-2:0.01:2)

# ╔═╡ f1c4c460-1ad6-11eb-22ac-953dd9e7330e
graph = DataF1[]

# ╔═╡ f1c587b0-1ad6-11eb-174e-cb41ee7eae25
for _exp in 0:3
	push!(graph, DataF1(x, x.^_exp))
end

# ╔═╡ f1c846d0-1ad6-11eb-3f1a-f7924a5fa369
#==Generate EasyPlot
===============================================================================#
myplot = EasyPlot.new(title = "Sample Plot")

# ╔═╡ f1c93130-1ad6-11eb-286f-fd85c66e83ee
subplot = add(myplot, linlin, alabels, title = "Polynomial Equations")

# ╔═╡ f1ccdaae-1ad6-11eb-284f-f166ff8da67b
add(subplot, graph[1], id="Constant")

# ╔═╡ f1cdc510-1ad6-11eb-2f36-f5bcc01f1880
add(subplot, graph[2], id="Linear")

# ╔═╡ f1d12070-1ad6-11eb-0e9c-8935b2425fbb
add(subplot, graph[3], id="Quadratic")

# ╔═╡ f1d3df8e-1ad6-11eb-3c40-8b664999a894
wfrm = add(subplot, graph[4], id="Cubic")

# ╔═╡ f1d4c9f0-1ad6-11eb-1a7c-a32878540cca
set(wfrm, dfltline, dfltglyph)

# ╔═╡ f1d7d730-1ad6-11eb-3514-65b8aff71e8e
#==Return plot to user (call evalfile(...))
===============================================================================#
myplot

# ╔═╡ 5430d7b0-1ad7-11eb-03a1-dba14cb2c6b0
pushdisplay(EasyPlotInspect.PlotDisplay())

# ╔═╡ 91bdfbd0-1ad7-11eb-29b8-117375fe4448
display

# ╔═╡ a07783d0-1ad7-11eb-3710-3b7b0b68a8d8


# ╔═╡ a69908b0-1ad7-11eb-3269-e53e1bc21ec6


# ╔═╡ Cell order:
# ╟─6bf5ab10-1937-11eb-14ab-9f0d0337f110
# ╠═9b9bb260-1937-11eb-2d86-816ff68ce05b
# ╠═3af4a040-193a-11eb-094f-f7208784354d
# ╠═3fe5945e-193a-11eb-2e35-a911f88ded2c
# ╠═1345db2e-1ada-11eb-2b0f-4bd81ea1aaa7
# ╠═c4e7f9c0-1ad7-11eb-34a4-d7ad4edcbe11
# ╟─d8101380-1937-11eb-0e6e-03cb3841ab3e
# ╠═87186ae0-1ad6-11eb-2d7d-cfc2f141ef98
# ╠═f1bb2770-1ad6-11eb-1006-f3ebe71619d2
# ╠═f1bc11d0-1ad6-11eb-3ae6-d54e44ef54df
# ╠═f1be82d0-1ad6-11eb-0ec2-53c91bf0506d
# ╠═f1c25362-1ad6-11eb-3b83-d38020d27991
# ╠═f1c4c460-1ad6-11eb-22ac-953dd9e7330e
# ╠═f1c587b0-1ad6-11eb-174e-cb41ee7eae25
# ╠═f1c846d0-1ad6-11eb-3f1a-f7924a5fa369
# ╠═f1c93130-1ad6-11eb-286f-fd85c66e83ee
# ╠═f1ccdaae-1ad6-11eb-284f-f166ff8da67b
# ╠═f1cdc510-1ad6-11eb-2f36-f5bcc01f1880
# ╠═f1d12070-1ad6-11eb-0e9c-8935b2425fbb
# ╠═f1d3df8e-1ad6-11eb-3c40-8b664999a894
# ╠═f1d4c9f0-1ad6-11eb-1a7c-a32878540cca
# ╠═f1d7d730-1ad6-11eb-3514-65b8aff71e8e
# ╠═5430d7b0-1ad7-11eb-03a1-dba14cb2c6b0
# ╠═91bdfbd0-1ad7-11eb-29b8-117375fe4448
# ╠═a07783d0-1ad7-11eb-3710-3b7b0b68a8d8
# ╠═a69908b0-1ad7-11eb-3269-e53e1bc21ec6
