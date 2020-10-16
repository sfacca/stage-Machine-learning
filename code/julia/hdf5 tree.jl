# docu package hdf5 per julia https://juliaio.github.io/HDF5.jl/stable/
# using Pkg
# pkg.add("HDF5")

module HDF5Tree

include("hierTree.jl")

using HDF5
using DataFrames

export viewfileTree, treeToDf


function viewfileTree(x)#prende file, ritorna radice albero generato
    #println("call viewfile") 
    myRoot = hTree.lnode("HDF5 FILE")
    nomi = names(x)
    checkAtts(x,myRoot)
    for n in nomi
        mychild = hTree.hTree.addchild!(myRoot,n)
        i = x[n]
        myView(i,mychild)
    end
    #println("fine view file tree")
    mytree = hTree.tree(myRoot)
    mytree    
end
    
    
function myView(me::HDF5.HDF5Attributes, mynode::hTree.lnode)#attributi
        #attributi non hanno figli
    ##println("view su attributo")
end

function myView(me::HDF5.HDF5Group, mynode::hTree.lnode)
    ##println("view su gruppo")
    #vediamo figli
    nomi = names(me)
    for n in nomi#per ogni sotto oggetto
        mychild = hTree.addchild!(mynode,n)#lo aggiunge all albero
        i = me[n]
        myView(i,mychild)#lancia la view su di esso
    end
    #controlliamo attributi
    checkAtts(me,mynode)
end

function myView(me::HDF5.HDF5Dataset, mynode::hTree.lnode)
    #data non ha figli
    checkAtts(me,mynode)
end

function checkAtts(x,mynode::hTree.lnode)
    attributi = attrs(x)
    natts = names(attributi)
    ##println("cerco attributi di $(mynode.name)")
    if isempty(natts)
        ##println("niente attributi")
    else 
        ##println("ho trovato attributi $()")
        count = 0
        for attributo in natts
            hTree.addchild!(mynode, attributo)
            count=count+1
        end
        ##println("trovato $count atributi")
    end
end

function checkHeader()
    #todo
end

function viewfile(x)
    
    viewgroup(x)
    
end
    
function viewgroup(g)
    
    
    # attributi
    attributi = attrs(g)
    if isempty(names(attributi))
        ##println("niente attributi")
    else        
        viewattributes(attributi)
    end
    #attrs(obj) ritorna attributi oggetto
    nomi = names(g)
    # names(x::Union{HDF5Group,HDF5File}) ritorna array di nomi dei membri di obj
    ##println("nomi: $nomi")
    #view su oggetti contenuti
    for nome in nomi
        i = g[nome]
        ti = typeof(i)
        ##println("trovato sotto oggetto di nome: $nome e tipo $ti")
        if ti==HDF5Group            
            viewgroup(i)
        elseif ti==HDF5Dataset
            viewdata(i)
        else
            #println(ti)
        end
    end
end

function viewdata(d)
    ##println("call viewdata on $d")
    
    #attributi
    attributi = attrs(d)
    if isempty(names(attributi))
        ##println("niente attributi")
    else        
        viewattributes(attributi)
    end
    
    # nome
    ##println(d)
    #1 dataset mappabile?
    if ismmappable(d)
        ##println("dataset mmappabile")
    else
        ##println("dataset non mmappabile")
    end
    #mappatura dataset con readmmap() aumenta rpestazioni per letture numerose di un ds
    
    # datatype
    #println("tipo dati: $(typeof(read(d)))")
    
    # dataspace (dimensioni )
    #println("dimensioni: $(size(d))")
end 

function viewattributes(atts::HDF5.HDF5Attributes)
    #println("call viewattributes on $atts")
    nomi = names(atts)
    for nome in nomi
        content = read(atts, nome)
        #println("attributo di nome: $nome ; tipo: $(typeof(content))")
        #println("contenuto: $content")
    end
end

function printTree(root::hTree.lnode)
    #TODO 
 end

 function treeToDf(item)
    if :first in fieldnames(typeof(item))
        treeToDf(item.first,0,1)
    else
        treeToDf(item,0,1)
    end
end

function treeToDf(tree::hTree.tree)
    #println("treetoDf on tree")
    treeToDf(tree.first,0,1)
end
function treeToDf(node::hTree.lnode)
    #println("treetoDf on node")
    treeToDf(node,0,1)
end

function treeToDf(p, pid, counter)#prende albero, ritorna df
    #println("tree to df on: $(p.name)")
    #println("figli? $(p.leftmost)")
    #println("fratelli? $(p.rightsib)")
    #println("tree to df args: pid = $pid , counter = $counter")
    myid=counter
    counter = counter+1
    if pid==0
        mydf = DataFrame(id=[0,myid],name=["root",p.name],parent=[missing,pid])         
    else
        mydf = DataFrame(id=myid,name=p.name,parent=pid)
    end

    #si aggiunge
    
    #@show 
    #mydf = DataFrame(id=myid,name=p.name,parent=pid)
    
    #lancia view su figlio        
    if p.leftmost!=nothing
        #println("$(p.name) has children")
        tempdf, counter = treeToDf(p.leftmost,myid,counter)
        append!(mydf,tempdf)
    end
    
    #lancia view sul fratello
    if p.rightsib!=nothing
        #println("$(p.name) has sibling")
        tempdf, counter = treeToDf(p.rightsib,pid,counter)
        append!(mydf,tempdf)
    end
    
    #ritorna df e counter
    mydf, counter
end

end