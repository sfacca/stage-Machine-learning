### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 235ad810-13d5-11eb-39d6-e1040f9510f0
include("../../code/julia/HDF5filesDict.jl")

# ╔═╡ 521a4a50-1461-11eb-117b-2566e5f213de
include("../../code/julia/eos_convert.jl")

# ╔═╡ 35f25c1e-145a-11eb-01ba-ad46c2c67110
begin 
	const closeall = HDF5fd.closeall
	const openfiles = HDF5fd.filesDict();
end

# ╔═╡ 47357530-145a-11eb-1021-93e7d7223c55
begin
	filename="data/PRS_L2D_STD_20200627102334_20200627102339_0001.he5"
	allowed = [0]
end

# ╔═╡ 60bb1e62-145a-11eb-00bf-f70597b30d70
in_file = HDF5fd.open(openfiles,filename,"r");

# ╔═╡ 799cbf60-145a-11eb-31f4-131428a7a019
out_file = "out/convert tests/PRS_L2D_STD_20200627102334_20200627102339_0001"

# ╔═╡ 69199af0-145a-11eb-29d5-77f3985c76d9
eos_convert.maketif(in_file,out_file;allowed_errors=allowed,SWIR=false,PAN=false,FULL=false,overwrite=true)

# ╔═╡ f3797200-146f-11eb-39f5-437ecea37461
x = [3,5,2,7,8]

# ╔═╡ fcb221f0-146f-11eb-1a21-fda4fcf0ffc8
s = sortperm(x)

# ╔═╡ 1822d240-1470-11eb-145a-cb469d2c51de
xs = x[s]

# ╔═╡ 92a79140-1470-11eb-2a72-cd18f2e3f6b7
res = zeros(typeof(x[1]),length(x))

# ╔═╡ c2fa2c40-1470-11eb-0f65-273d6b63684b
function undoPerm(arr,perm)
    res = zeros(typeof(arr[1]),length(arr))
    if length(arr) != length(perm)
        println("errore input lunghezze diverse")
        return nothing
    else
        for i in 1:length(arr)
            res[perm[i]]=arr[i]
        end
        return res
    end 

end

# ╔═╡ 80649ef0-1471-11eb-33c1-c38aad167ade
xss = undoPerm(xs,s)

# ╔═╡ f4e52b72-1479-11eb-3128-1191178add94
ss = s[s]

# ╔═╡ 5287f2ae-1481-11eb-0901-99cf26e57639
selb = Array{Float32,1}(undef,0)

# ╔═╡ Cell order:
# ╠═235ad810-13d5-11eb-39d6-e1040f9510f0
# ╠═521a4a50-1461-11eb-117b-2566e5f213de
# ╠═35f25c1e-145a-11eb-01ba-ad46c2c67110
# ╠═47357530-145a-11eb-1021-93e7d7223c55
# ╠═60bb1e62-145a-11eb-00bf-f70597b30d70
# ╠═799cbf60-145a-11eb-31f4-131428a7a019
# ╠═69199af0-145a-11eb-29d5-77f3985c76d9
# ╠═f3797200-146f-11eb-39f5-437ecea37461
# ╠═fcb221f0-146f-11eb-1a21-fda4fcf0ffc8
# ╠═1822d240-1470-11eb-145a-cb469d2c51de
# ╠═92a79140-1470-11eb-2a72-cd18f2e3f6b7
# ╠═c2fa2c40-1470-11eb-0f65-273d6b63684b
# ╠═80649ef0-1471-11eb-33c1-c38aad167ade
# ╠═f4e52b72-1479-11eb-3128-1191178add94
# ╠═5287f2ae-1481-11eb-0901-99cf26e57639
