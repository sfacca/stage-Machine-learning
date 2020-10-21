### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ a92f5810-1391-11eb-3df3-0196bd34d502
using HDF5

# ╔═╡ c69f8c70-1392-11eb-243c-1b233cd17c4a
include("../../code/julia/eos_geoloc.jl")

# ╔═╡ b07fb140-1397-11eb-3492-b5b24c36d99b
include("../../code/julia/eos_rastwrite_lines.jl")

# ╔═╡ 3cd0a8c0-1393-11eb-0172-2f44e8310c60
include("../../code/julia/HDF5filesDict.jl")

# ╔═╡ 19ac2180-1398-11eb-04dd-05868f4cce9d
include("../../code/julia/faux.jl")

# ╔═╡ 825b19d0-1397-11eb-221a-c94fe17e8ff4
openfiles = HDF5fd.filesDict()

# ╔═╡ 9375ea60-1397-11eb-3009-bba0fe507feb
begin
	f = "data/PRS_L2D_STD_20200627102334_20200627102339_0001.he5"
	in_file = HDF5fd.open(openfiles,f, "r")
end

# ╔═╡ c8ef5690-1397-11eb-0955-838f21f5a020
md"prendo una matrice da cubo errori da una determinata banda"

# ╔═╡ f7ed92e0-139c-11eb-0ab5-e18177e1725c
@bind index html"<input type=range min=1 max=66>"

# ╔═╡ 433ebb70-139d-11eb-2e24-ab3fc8b4938b
md" banda $index "

# ╔═╡ 13fd3490-1398-11eb-2d7d-9b053f0eadd6
err_mat = faux.getData(in_file,"HDFEOS/SWATHS/PRS_L2D_HCO/Data Fields/VNIR_PIXEL_L2_ERR_MATRIX")[:,index,:];	

# ╔═╡ 5c041420-1398-11eb-29b9-1d6625c2bc60
md"prendo matrice vnir alla stessa banda/indice"

# ╔═╡ 56cca120-1398-11eb-098c-31abc14dd460
vnir_mat = faux.getData(in_file,"HDFEOS/SWATHS/PRS_L2D_HCO/Data Fields/VNIR_Cube")[:,index,:];

# ╔═╡ 0cc9ae00-1399-11eb-0972-4b357a6def0b
md"stampo entrambe nello stesso tif, prima senza geoloc"

# ╔═╡ d6824dfe-1399-11eb-0ca3-9f37748620e8
out_all = "out/err_test/all"

# ╔═╡ 6344d9c0-139a-11eb-0932-03def818a3c8
mkpath(faux.dirname(out_all))

# ╔═╡ 1b9a4070-1399-11eb-0dff-837ebf821d61
begin
	cube = cat(err_mat, vnir_mat, dims = 3)
	rastwrite_lines.write(cube,out_all;overwrite=true)
end

# ╔═╡ 6f141310-139a-11eb-11a0-81b7a26d55ab
md"poi con geoloc"

# ╔═╡ 7803d320-139a-11eb-2508-abb6c22271a1
geo = eos_geoloc.get(in_file,"VNIR");

# ╔═╡ 9f568170-139a-11eb-1cf4-9185b6119dcc
out_all_geo = string(out_all,"_geo_2");

# ╔═╡ b31e97b0-139a-11eb-137a-2fbf969e9cec
rastwrite_lines.write(cube,out_all_geo;gtf = geo.gtf, crs = geo.crs, overwrite = true)

# ╔═╡ ec0cf9ce-13af-11eb-2dbb-45ccf4ef1baf
md"proviamo a prendere tutto"

# ╔═╡ f4195ec0-13af-11eb-0383-3d625def37bd
vnir_raw_cube = faux.getData(in_file,"HDFEOS/SWATHS/PRS_L2D_HCO/Data Fields/VNIR_Cube");

# ╔═╡ bed9f8e0-13b0-11eb-3df3-4da03e947ff7
err_raw_cube = faux.getData(in_file,"HDFEOS/SWATHS/PRS_L2D_HCO/Data Fields/VNIR_PIXEL_L2_ERR_MATRIX");

# ╔═╡ 61c9a970-13b0-11eb-204f-115f4c063b2a
size(vnir_raw_cube)

# ╔═╡ 1756abde-13b0-11eb-05a0-07db185c204b
begin
	vnir_cube = vnir_raw_cube[:,1,:];	
	for i in 2:size(vnir_raw_cube)[2]		
		global vnir_cube = cat(vnir_cube,vnir_raw_cube[:,i,:],dims=3)		
	end
end

# ╔═╡ b73a5f7e-13b0-11eb-33a4-a301f2a99e1a
begin
	vnir_err_cube = err_raw_cube[:,1,:];	
	for i in 2:size(err_raw_cube)[2]		
		global vnir_err_cube = cat(vnir_err_cube,err_raw_cube[:,i,:],dims=3)		
	end
end

# ╔═╡ 17980530-13b1-11eb-290c-d145ae4911ed
begin
	out_vnir = "out/err_test/full/vnir"
	full_err = string(out_vnir,"_err")
end

# ╔═╡ 059397f0-13b1-11eb-32ef-bbf6a64997db
rastwrite_lines.write(vnir_err_cube,full_err;gtf=geo.gtf,crs=geo.crs,overwrite=true)

# ╔═╡ 70ae1c90-13b1-11eb-2907-796153e836b4
rastwrite_lines.write(vnir_cube,out_vnir;gtf=geo.gtf,crs=geo.crs,overwrite=true)

# ╔═╡ ea29e520-13b3-11eb-15ff-2f23a4c4f470
md"risultato: il tif generato con eos_create.maketif ha le bande invertite 1:n -> n:1

la matrice di errori n del tif generato da eos\_create sembrerebbe riferirsi alla banda nbands-n del tif vnir generato da eos\_create"

# ╔═╡ Cell order:
# ╟─a92f5810-1391-11eb-3df3-0196bd34d502
# ╟─c69f8c70-1392-11eb-243c-1b233cd17c4a
# ╟─b07fb140-1397-11eb-3492-b5b24c36d99b
# ╟─3cd0a8c0-1393-11eb-0172-2f44e8310c60
# ╟─19ac2180-1398-11eb-04dd-05868f4cce9d
# ╠═825b19d0-1397-11eb-221a-c94fe17e8ff4
# ╠═9375ea60-1397-11eb-3009-bba0fe507feb
# ╟─c8ef5690-1397-11eb-0955-838f21f5a020
# ╟─f7ed92e0-139c-11eb-0ab5-e18177e1725c
# ╟─433ebb70-139d-11eb-2e24-ab3fc8b4938b
# ╠═13fd3490-1398-11eb-2d7d-9b053f0eadd6
# ╟─5c041420-1398-11eb-29b9-1d6625c2bc60
# ╠═56cca120-1398-11eb-098c-31abc14dd460
# ╟─0cc9ae00-1399-11eb-0972-4b357a6def0b
# ╠═d6824dfe-1399-11eb-0ca3-9f37748620e8
# ╠═6344d9c0-139a-11eb-0932-03def818a3c8
# ╠═1b9a4070-1399-11eb-0dff-837ebf821d61
# ╟─6f141310-139a-11eb-11a0-81b7a26d55ab
# ╠═7803d320-139a-11eb-2508-abb6c22271a1
# ╠═9f568170-139a-11eb-1cf4-9185b6119dcc
# ╠═b31e97b0-139a-11eb-137a-2fbf969e9cec
# ╟─ec0cf9ce-13af-11eb-2dbb-45ccf4ef1baf
# ╠═f4195ec0-13af-11eb-0383-3d625def37bd
# ╠═bed9f8e0-13b0-11eb-3df3-4da03e947ff7
# ╠═61c9a970-13b0-11eb-204f-115f4c063b2a
# ╠═1756abde-13b0-11eb-05a0-07db185c204b
# ╠═b73a5f7e-13b0-11eb-33a4-a301f2a99e1a
# ╠═17980530-13b1-11eb-290c-d145ae4911ed
# ╠═059397f0-13b1-11eb-32ef-bbf6a64997db
# ╠═70ae1c90-13b1-11eb-2907-796153e836b4
# ╟─ea29e520-13b3-11eb-15ff-2f23a4c4f470
