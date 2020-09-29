##funzioni ausiliarie

module faux

export seq_along, getAttr, closestDistanceFunction, getData
using HDF5


function seq_along(arr::Array{})
    res = [1:length(arr)...]
    res
end
# name è attributo globale del file(aperto) hdf5 file
# ritorna campo valore name
function getAttr(file, name::String)    
    read(attrs(file), name)
end

function getData(file, name::String)
    read(file,name)
end

function closestDistanceFunction(wvl::Array{Int64,1})
    (x) -> (minimum(abs.(wvl .- x)))
end

end#end module