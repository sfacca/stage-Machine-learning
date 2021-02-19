module HDF5fd
### mancano dichiarazione tipi del modulo nelle funzioni ###
using HDF5

export filesDict, open, closeall

mutable struct filesDict
    dict
    counter 

    filesDict(file::String,mode::String)=(
        x= new();
        x.counter=0;
        x.dict = Dict();
        open(x,file,mode);
        x)    
    filesDict()=(
        x=new();
        x.counter=0;
        x.dict=Dict();
        x;
        )
    # sarebbe da trovare se si possono inserire callback quando julia fa
    # garbage collect di oggetti, cosi da lanciare automaticamente closeall
end

function closeall(dict)
    n = 0
    for (key, value) in dict.dict
        close(pop!(dict.dict, key))
        n=n+1;
    end
    dict.counter = 0
    println("chiuso $n file")
    return n
end

function open(dict,file::String,mode::String)
    res = h5open(file, mode)
    dict.dict["file $(dict.counter)"]=res
    dict.counter = dict.counter+1
    res
end

end