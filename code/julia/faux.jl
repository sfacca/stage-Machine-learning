##funzioni ausiliarie

module faux

export seq_along, existsGroup, getAttr
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

function existsGroup(path::String,file::HDF5.HDF5File)
    #0: path è /{gruppo}/{sottogruppo}/{etc}
    #1 converte path in array di string per 

end