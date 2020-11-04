### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 3f38f1b0-1ec1-11eb-0b1b-eb71e7e4fc04
using CMDimData

# ╔═╡ 41eaf24e-1ec1-11eb-2479-1fec7fe883d5
using CMDimData.EasyPlot

# ╔═╡ 41ebdcb0-1ec1-11eb-2da6-1b407fe8ab94
using CMDimData.MDDatasets

# ╔═╡ 51518dc0-1ec2-11eb-3a6b-d5c29cb9a9b1
using CMDimData.EasyPlot.cons

# ╔═╡ c2d57280-1ebe-11eb-2314-2fc9eaafbc47
include("out/parametric_sin_2.jl")

# ╔═╡ 26be3032-1ebe-11eb-1ecd-5592be2757d9
download("https://github.com/ma-laforge/CMDimData.jl/raw/master/sample/parametric_sin.jl","out/parametric_sin_2.jl")

# ╔═╡ f33820d0-1ec3-11eb-08ed-fdf4c6972aa7


# ╔═╡ d7827f9e-1ec0-11eb-02c6-57426a188760
signal = fill(DataRS, PSweep("phi", [0, 0.5, 1] .* (π/4))) do 𝜙
    fill(DataRS, PSweep("A", [1, 2, 4] .* 1e-3)) do A
    #Inner-most sweep: need to specify element type (DataF1):
    #(Other (scalar) element types: DataInt/DataFloat/DataComplex)
    fill(DataRS{DataF1}, PSweep("freq", [1, 4, 16] .* 1e3)) do 𝑓
        𝜔 = 2π*𝑓
        T = 1/𝑓
        Δt = T/100 #Define resolution from # of samples per period
        Tsim = 4T #Simulated time

        t = DataF1(0:Δt:Tsim) #DataF1 creates a t:{y, x} container with y == x
        sig = A * sin(𝜔*t + 𝜙) #Still a DataF1 sig:{y, x=t} container
        return sig
end; end; end

# ╔═╡ e76b86f0-1ec0-11eb-1679-f5572b9027e6
ampvalue = parameter(signal, "A")

# ╔═╡ eaef5680-1ec0-11eb-3886-d39496fd42df
signal_norm = signal / ampvalue

# ╔═╡ 21f66790-1ec1-11eb-0201-13b1eb31a4d9
CMDimData.@includepkg EasyPlotInspect

# ╔═╡ f3cf8630-1ec0-11eb-3353-ed1d187cc912
plot = cons(:plot, nstrips = 3,
   #Add more properties such as axis labels here
)

# ╔═╡ 1c18fb20-1ec2-11eb-2d81-3fdbc3ed006a
CMDimData.cons

# ╔═╡ Cell order:
# ╠═26be3032-1ebe-11eb-1ecd-5592be2757d9
# ╠═f33820d0-1ec3-11eb-08ed-fdf4c6972aa7
# ╠═c2d57280-1ebe-11eb-2314-2fc9eaafbc47
# ╠═d7827f9e-1ec0-11eb-02c6-57426a188760
# ╠═e76b86f0-1ec0-11eb-1679-f5572b9027e6
# ╠═eaef5680-1ec0-11eb-3886-d39496fd42df
# ╠═21f66790-1ec1-11eb-0201-13b1eb31a4d9
# ╠═3f38f1b0-1ec1-11eb-0b1b-eb71e7e4fc04
# ╠═41eaf24e-1ec1-11eb-2479-1fec7fe883d5
# ╠═41ebdcb0-1ec1-11eb-2da6-1b407fe8ab94
# ╠═f3cf8630-1ec0-11eb-3353-ed1d187cc912
# ╠═1c18fb20-1ec2-11eb-2d81-3fdbc3ed006a
# ╠═51518dc0-1ec2-11eb-3a6b-d5c29cb9a9b1
