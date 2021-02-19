### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ b35baee0-1f5a-11eb-0a11-01830c96cc7e
using ZipFile

# ╔═╡ 0c84c720-1f5d-11eb-0f55-b9589ff7ffb1
using ZipFile.Zlib

# ╔═╡ 54d285a0-1f5b-11eb-01f1-217f79e2c4e4
using Zlib_jll

# ╔═╡ 91c00700-1f5e-11eb-0342-8be4f118ddb1
using CMDimData

# ╔═╡ 41eaf24e-1ec1-11eb-2479-1fec7fe883d5
using CMDimData.EasyPlot

# ╔═╡ 41ebdcb0-1ec1-11eb-2da6-1b407fe8ab94
using CMDimData.MDDatasets

# ╔═╡ 1d499a60-1f5b-11eb-104c-974420b65b18
include("out/cmdimdata/CMDimData.jl-master/src/CMDimData.jl")

# ╔═╡ c2d57280-1ebe-11eb-2314-2fc9eaafbc47
include("out/cmdimdata/CMDimData.jl-master/sample/parametric_sin.jl")

# ╔═╡ d6b444ce-1f5d-11eb-1d4a-694594d6aaf2


# ╔═╡ 81c10382-1f5a-11eb-0842-85f5467fa588
function downloadStuff()
	mkdir("out/cmdimdata/")
	download("https://github.com/ma-laforge/CMDimData.jl/raw/master/sample/parametric_sin.jl","out/parametric_sin_2.jl")
	download("https://github.com/ma-laforge/CMDimData.jl/archive/master.zip", "out/master.zip")
	
	unzip("out/master.zip","out/cmdimdata/")	
end

# ╔═╡ 530bbd70-1f5d-11eb-2f0c-6929e310f706
#downloadStuff()

# ╔═╡ 865a64f0-1f5e-11eb-298c-8746195c946e
#using Pkg

# ╔═╡ 8acb2c90-1f5e-11eb-1698-6f6ee0dbd925
#Pkg.add(url="https://github.com/ma-laforge/CMDimData.jl.git")

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

# ╔═╡ Cell order:
# ╠═b35baee0-1f5a-11eb-0a11-01830c96cc7e
# ╠═0c84c720-1f5d-11eb-0f55-b9589ff7ffb1
# ╠═54d285a0-1f5b-11eb-01f1-217f79e2c4e4
# ╠═d6b444ce-1f5d-11eb-1d4a-694594d6aaf2
# ╠═81c10382-1f5a-11eb-0842-85f5467fa588
# ╠═530bbd70-1f5d-11eb-2f0c-6929e310f706
# ╠═865a64f0-1f5e-11eb-298c-8746195c946e
# ╠═8acb2c90-1f5e-11eb-1698-6f6ee0dbd925
# ╠═91c00700-1f5e-11eb-0342-8be4f118ddb1
# ╠═1d499a60-1f5b-11eb-104c-974420b65b18
# ╠═c2d57280-1ebe-11eb-2314-2fc9eaafbc47
# ╠═d7827f9e-1ec0-11eb-02c6-57426a188760
# ╠═e76b86f0-1ec0-11eb-1679-f5572b9027e6
# ╠═eaef5680-1ec0-11eb-3886-d39496fd42df
# ╠═21f66790-1ec1-11eb-0201-13b1eb31a4d9
# ╠═41eaf24e-1ec1-11eb-2479-1fec7fe883d5
# ╠═41ebdcb0-1ec1-11eb-2da6-1b407fe8ab94
# ╠═f3cf8630-1ec0-11eb-3353-ed1d187cc912
