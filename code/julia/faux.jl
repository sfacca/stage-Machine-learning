##funzioni ausiliarie

module faux

export seq_along, getAttr, closestDistanceFunction, getData, dirname, getIndexList, extractWvl, fileSansExt, diffLag
using HDF5

function fileSansExt(path)
    c = length(path)
    for i = 1:length(path)
        if path[i] == .
            c=i
        end
    end
    path[1:c]
end


function diffLag(x,lag)
    res = Array(0,length(x)-lag)
    for i = 1:(length(x)-lag)
        res[i] = x[i]-x[i+lag]
    end
    res
end


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

function dirname(file)
    c = length(path)
    for i = 1:length(path)
        if path[i]=="/"
            c = i
        end
    end
    file[1:c]
end

function getIndexList()
    mkpath("downloads")
    download("https://github.com/sfacca/stage-Machine-learning/raw/master/extdata/md_indexes_list.txt","downloads/indexes_list.txt")
    index_list = CSV.read("downloads/indexes_list.txt")
    select!(index_list, Not(:id))
end

function extractWvl(str::String)# prende stringa, ritorna array di int 
    currnum = ""
    res::Array{Int,1} = []
    intc = ['1','2','3','4','5','6','7','8','9','0']
    afterR = false
    for char in str 
        if afterR

            if char in intc
                currnum = currnum * 10
                currnum = currnum + parse(Int, char)             
                  
            else
                push!(res, currnum)
                currnum = 0
                afterR = false
            end
          
        end
        if char == 'R'
            afterR = true
        end
    end
    push!(res, currnum)  
    res
end

end#end module