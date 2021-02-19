### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 777c1640-1860-11eb-2ce4-672bb0cd73b2
include("../../code/julia/HDF5filesDict.jl");

# ╔═╡ ea23a132-1861-11eb-098b-d7895e0f193c
include("../../code/julia/faux.jl");

# ╔═╡ 25288940-1861-11eb-20d8-4975a1d42a0c
md"questa è la legenda riguardo il significato dei valori deiu cubi errore:

* 0=pixel ok  
* 1=Invalid pixel from L1 product  
* 2=Negative value after atmospheric correction  
* 3=Saturated value after atmospheric  "

# ╔═╡ 8ccacfb0-1864-11eb-2429-e9d117abe4a6
knownErrors = [0,1,2,3]

# ╔═╡ 48b14c60-1863-11eb-0355-192a65186522
function checkUniqueErrors(file)
	openfiles = HDF5fd.filesDict()
	in_file = HDF5fd.open(openfiles, file, "r")
	
	vnir_err_mat = faux.getData(in_file, "HDFEOS/SWATHS/PRS_L2D_HCO/Data Fields/VNIR_PIXEL_L2_ERR_MATRIX");
	unique_vnir = unique(vnir_err_mat[:,:,:])
	vnir_err_mat = nothing
	
	swir_err_mat = faux.getData(in_file, "HDFEOS/SWATHS/PRS_L2D_HCO/Data Fields/SWIR_PIXEL_L2_ERR_MATRIX");
	unique_swir = unique(swir_err_mat[:,:,:])
	swir_err_mat = nothing
	
	closed = HDF5fd.closeall(openfiles)
	
	result = unique(vcat(unique_swir,unique_vnir))
	
	return result
end

# ╔═╡ baeb4870-1864-11eb-3bb7-236fb8333daf
function compare2(arr,arr2)
	res = []
	for i in arr
		if i in arr2
		else
			push!(res, i)
		end
	end
	
	for j in arr2
		if j in arr
		else
			push!(res, j)
		end
	end
	return res
end

# ╔═╡ 5ed48620-1862-11eb-2bbe-ad698ef9638d
unique1 = checkUniqueErrors("../../prisma/hdf5/data/PRS_L2D_STD_20190911102308_20190911102313_0001.he5")

# ╔═╡ 9acec350-1864-11eb-26d4-9bdda68a3658
compare2(unique1, knownErrors)

# ╔═╡ 726056b0-1862-11eb-1f5f-f97e3b706656
md"errore 4?"

# ╔═╡ 3ad10d60-1863-11eb-1373-43e48231aae7
md"proviamo con un altro file..."

# ╔═╡ b1116bf0-1863-11eb-3c5c-950bd7bb5e32
unique2 = checkUniqueErrors("../../prisma/hdf5/data/PRS_L2D_STD_20200627102334_20200627102339_0001.he5")

# ╔═╡ b5c026f0-1863-11eb-081c-3f68a97f5cde
compare2(unique2, knownErrors)

# ╔═╡ 52f45580-1865-11eb-05a5-b5df7ac16663
md"entrambi i file han errori di tipo 4(che non ha significato nella legenda) ma non han errori di tipo (che ha significato nella legenda)

3 == 0x04?"

# ╔═╡ Cell order:
# ╠═777c1640-1860-11eb-2ce4-672bb0cd73b2
# ╠═ea23a132-1861-11eb-098b-d7895e0f193c
# ╟─25288940-1861-11eb-20d8-4975a1d42a0c
# ╠═8ccacfb0-1864-11eb-2429-e9d117abe4a6
# ╠═48b14c60-1863-11eb-0355-192a65186522
# ╟─baeb4870-1864-11eb-3bb7-236fb8333daf
# ╟─5ed48620-1862-11eb-2bbe-ad698ef9638d
# ╠═9acec350-1864-11eb-26d4-9bdda68a3658
# ╟─726056b0-1862-11eb-1f5f-f97e3b706656
# ╟─3ad10d60-1863-11eb-1373-43e48231aae7
# ╟─b1116bf0-1863-11eb-3c5c-950bd7bb5e32
# ╠═b5c026f0-1863-11eb-081c-3f68a97f5cde
# ╠═52f45580-1865-11eb-05a5-b5df7ac16663
