##funzioni ausiliarie

module faux

export seq_along, getAttr, closestDistanceFunction, getData, dirname, extractWvl, fileSansExt
export diffLag, dnToReflectance, closestElements, ratioToReflectance, indexesOfNonZero, filename

using HDF5

function fileSansExt(path)
    c = length(path)
    for i = 1:length(path)
        
        if path[i] == '.'
            c=i-1
        end
    end
    if c==0
        c=1
    end
    path[1:c]
end

function dnToReflectanceFunction(scalemin::Float32,scalemax::Float32)
    (x)->(scalemin+x*(scalemax-scalemin))/65535
end


function ratioToReflectance(f,cube,type)
    proc_lev = getAttr(f,"Processing_Level")
    if proc_lev == 1
        throw(error("processing level 1 files not supported yet"))
    end
    if !(type in ["VNIR","SWIR","PAN"])
        throw(error("type $type is not a valid type, must be SWIR, PAN or VNIR"))
    end

    if type == "PAN"
        source = "PCO"
    else 
        source = "HCO"
    end

    scalemin = getAttr(f,"L2Scale$(titlecase(type))Min")
    scalemax = getAttr(f,"L2Scale$(titlecase(type))Max")

    dnToReflectanceFunction(scalemin,scalemax).(cube)
end

function diffLag(x,lag)
    res = zeros(length(x)-lag)
    for i = 1:(length(x)-lag)
        res[i] = abs(x[i]-x[i+lag])
    end
    res
end

function closestElements(sel::Array{Float64,1},wvl::Array{Float64,1})#NB: wvl è array ordinato
    if length(wvl) == 1
        return Array{UInt8,1}(ones,length(sel))
    end
    res = [1:length(sel)...]
    for i = 1:length(sel)
        for j = 2:length(wvl)
            if sel[i] < wvl[j]
                if abs(sel[i]-wvl[j])<abs(sel[i]-wvl[j-1])
                    res[i]=j
                else
                    res[i]=j-1
                end
                break
            end
        end
    end
    res
end

function indexesOfNonZero(arr)
    res = []
    index = 1
    for i = 1:length(arr)
        if arr[i]!=0
            push!(res,i)            
        end
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

function closestDistanceFunction(wvl::Array{Float32,1})
    (x) -> (minimum(abs.(wvl .- x)))
end

function dirname(path)
    c = length(path)
    for i = 1:length(path)
        if path[i]=="/"
            c = i
        end
    end
    path[1:c]
end

function filename(path)
    c = length(path)
    for i = 1:length(path)
        if path[i]=='/'
            c = i+1
        end
    end
    path[c:end]
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