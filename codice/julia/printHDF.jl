module printHDF

using HDF5

export viewfile

function viewfile(x)
    println("call viewfile")
   #=for i in x 
        if typeof(i)==HDF5Group
            viewgroup(i)
        else
            println(typeof(i))
        end
    end=#
    viewgroup(x)
    #dump(x)
end
    
function viewgroup(g)
    println("call viewgroup on $g")
    #nome
    #println(g)
    
    # attributi
    attributi = attrs(g)
    if isempty(names(attributi))
        println("niente attributi")
    else        
        viewattributes(attributi)
    end
    #attrs(obj) ritorna attributi oggetto
    nomi = names(g)
    # names(x::Union{HDF5Group,HDF5File}) ritorna array di nomi dei membri di obj
    println("nomi: $nomi")
    #view su oggetti contenuti
    for nome in nomi
        i = g[nome]
        ti = typeof(i)
        println("trovato sotto oggetto di nome: $nome e tipo $ti")
        if ti==HDF5Group            
            viewgroup(i)
        elseif ti==HDF5Dataset
            viewdata(i)
        else
            println(ti)
        end
    end
end

function viewdata(d)
    println("call viewdata on $d")
    
    #attributi
    attributi = attrs(d)
    if isempty(names(attributi))
        println("niente attributi")
    else        
        viewattributes(attributi)
    end
    
    # nome
    #println(d)
    #1 dataset mappabile?
    if ismmappable(d)
        println("dataset mmappabile")
    else
        println("dataset non mmappabile")
    end
    #mappatura dataset con readmmap() aumenta rpestazioni per letture numerose di un ds
    
    # datatype
    println("tipo dati: $(typeof(read(d)))")
    
    # dataspace (dimensioni )
    println("dimensioni: $(size(d))")
end 

function viewattributes(atts::HDF5.HDF5Attributes)
    println("call viewattributes on $atts")
    nomi = names(atts)
    for nome in nomi
        content = read(atts, nome)
        println("attributo di nome: $nome ; tipo: $(typeof(content))")
        println("contenuto: $content")
    end
end

end