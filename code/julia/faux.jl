##funzioni ausiliarie

module faux

export seq_along, getAttr, closestDistanceFunction, getData, dirname, extractWvl, fileSansExt
export diffLag, dnToReflectance, closestElements, ratioToReflectance, indexesOfNonZero, filename
export matCrop, getCube, undoPerm

using HDF5
using ArchGDAL

function matCrop(mat)
    first = 0
    last = 0
    numrows= size(mat)[1]
    for i in 1:numrows
        if mat[i,1]!=0
            last = i
            if first ==0
                first = i
            end        
        end    
    end
    mat[first:last,:]
end

function fileSansExt(path)
    c = length(path)
    for i = 1:length(path)
        
        if path[i] == '.'
            c=i-1
        end
    end
    if c==0
        ""
    else
        path[1:c]
    end
end

function dnToReflectanceFunction(scalemin::Number,scalemax::Number)
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



function closestElements(sel::Array{Float32,1},wvl::Array{Float32,1})#NB: wvl è array ordinato

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
            elseif j==length(wvl)
                res[i]=j
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
        if path[i]=='/'
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

function undoPerm(arr,perm)
    res = zeros(typeof(arr[1]),length(arr))
    if length(arr) != length(perm)
        println("errore input lunghezze diverse")
        return nothing
    else
        for i in 1:length(arr)
            res[sort[i]]=arr[i]
        end
        return res
    end 
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

#fun prende bande da first a last da un gdal dataset (aperto con archgdal.read(filename))
#e le ritorna in un cubo di dati
function getCube(dataset::ArchGDAL.AbstractDataset,inizio::Union{Int,Nothing}=nothing,fine::Union{Int,Nothing}=nothing)
    if fine !=0
        cube = nothing
        first = true
        nbands = ArchGDAL.nraster(dataset)
        if isnothing(inizio)||inizio>nbands||inizio==0
            inizio=1
        end
        if isnothing(fine)||fine>nbands
            fine=nbands
        end
        
        raster = ArchGDAL.read(dataset)
        println("reading bands $inizio to $fine , this might take a while...")

        for i = inizio:fine
            #println("reading bands nr $i of $fine")
            
            if first
                #println("band is first")
                #cube = copy(ArchGDAL.read(ArchGDAL.getband(dataset,i)))
                cube = ArchGDAL.read(ArchGDAL.getband(dataset,i))
                first = false
            else
                #println("appending band $i to cube")
                cube =  cat(cube,ArchGDAL.read(ArchGDAL.getband(dataset,i)),dims=3)
            end
        end
        println("finished reading bands")        
    else
        cube =nothing
    end
    cube
end


function getIndexList()
    mkpath("downloads")
    download("https://github.com/sfacca/stage-Machine-learning/raw/master/extdata/md_indexes_list.txt","downloads/indexes_list.txt")
    index_list = CSV.read("downloads/indexes_list.txt")
    select!(index_list, Not(:id))
end

end#end module