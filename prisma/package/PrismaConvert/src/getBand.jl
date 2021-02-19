### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ 5e224c62-28e5-11eb-34ed-3ff47e204db0
using HDF5, CSV, DataFrames

# ╔═╡ 8d9c88c0-28e5-11eb-3b69-130d2b4fe010
function getBand(n::Int,f;typ::String="VNIR",out="out") 
    mkpath(out)
    cw = read(attrs(f), "List_Cw_$(titlecase(typ, strict = true))")[n]
    fwhm = read(attrs(f), "List_Fwhm_$(titlecase(typ, strict = true))")[n]
    CSV.write(mkpath(out*"/name/band $(n)")*"/info.csv", 
		DataFrame([("cw",cw),("fwhm",fwhm)]))
    read(f, "HDFEOS/SWATHS/PRS_L2D_HCO/Data Fields/$(typ)_Cube")[:,n,:] 	
end

# ╔═╡ 8d9d2502-28e5-11eb-3069-47e24c4e6ee1


# ╔═╡ 06fa28b0-28ed-11eb-207a-01140a9a156d
out="out"

# ╔═╡ 031e2700-28ed-11eb-1652-c746f3ad5f1a
mkpath(out*"/name/band")

# ╔═╡ 1c779010-28ed-11eb-04e4-5d8cb147a1df
n = 1

# ╔═╡ ff383a40-28ec-11eb-2c48-854abec7450f


# ╔═╡ Cell order:
# ╠═5e224c62-28e5-11eb-34ed-3ff47e204db0
# ╠═8d9c88c0-28e5-11eb-3b69-130d2b4fe010
# ╠═8d9d2502-28e5-11eb-3069-47e24c4e6ee1
# ╠═06fa28b0-28ed-11eb-207a-01140a9a156d
# ╠═031e2700-28ed-11eb-1652-c746f3ad5f1a
# ╠═1c779010-28ed-11eb-04e4-5d8cb147a1df
# ╠═ff383a40-28ec-11eb-2c48-854abec7450f
