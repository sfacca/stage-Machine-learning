include("HDF5filesDict.jl")
include("eos_convert.jl")

using CImGui


const openfiles = HDF5fd.filesDict()
const closeall = HDF5fd.closeall

filename = ""
selbands_vnir = Array{Float32,1}(undef,0)
selbands_swir = Array{Float32,1}(undef,0)
VNIR = true
SWIR = true
PAN = true
FULL = true
out_file = "./"
source = "HCO"
join_priority ="VNIR"
overwrite = false
indexes = nothing
cust_indexes = nothing
allowed_errors = nothing






