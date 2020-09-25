module hTree

export lnode, getrightmost, addchild!, treeList, printTree

mutable struct lnode
    name::String
    leftmost::Union{hTree.lnode,Nothing}
    parent::Union{hTree.lnode,Nothing}
    rightsib::Union{hTree.lnode,Nothing}
    lnode(v::String) = (
        x = new(); 
        x.leftmost = nothing; 
        x.rightsib=nothing;
        x.parent=nothing; 
        x.name=v; 
        x
        )
end

mutable struct tree
    first::Union{hTree.lnode,Nothing}
    #treeList(root::hTree.lnode) = List(nodo) 
    tree(value::String)=(
        x = new();
        nnode = hTree.lnode(value);
        x.first = nnode;
        x
    )

    tree()=tree(nothing)  

    tree(nodo::hTree.lnode)=(
        x = new();
        x.first=nodo;
        x
    )
end

#struttura albero leftmost child/right sibling per alberi non binari

function getrightmost(parent::hTree.lnode)
    temp = parent
    if parent.leftmost != nothing
        temp = parent.leftmost
        while (temp.rightsib != nothing)
            temp = temp.rightsib
        end
        temp
    else
        throw("input has no parent")        
    end
end

function addchild!(parent::hTree.lnode, name::String)
    #println("init addchild $name")
    new = lnode(name)
    new.parent = parent
    if(parent.leftmost!=nothing)
        temp = getrightmost(parent)
        temp.rightsib = new
        new
    else
        parent.leftmost = new
        new
    end
end

function printTree(root::hTree.lnode)
    #TODO 
    #1 trasforma albero in df
    #2 lancia macro vgplot?
end




end