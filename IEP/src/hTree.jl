module hTree

export lnode, getrightmost, addchild!, treeList, printTree, hTree
"""
node
"""
mutable struct lnode{T}
	value::T
	label::String
    leftmost::Union{hTree.lnode,Nothing}
    parent::Union{hTree.lnode,Nothing}
    rightsib::Union{hTree.lnode,Nothing}
	lnode{T}(v::T) where {T} = new(
		v,
		"",
		nothing,
		nothing,
		nothing
	)
	
	lnode{T}(v::T,l::String) where {T} = new(
		v,
		l,
		nothing,
		nothing,
		nothing
		)
end

"""
tree
"""
mutable struct tree{T}
    first::Union{hTree.lnode{T},Nothing}
	
    tree{T}(v::T) where {T} = new{typeof(v)}(hTree.lnode{T}(v))
end


function setLabel!(node,label)
    node.label = label
end

#struttura albero leftmost child/right sibling per alberi non binari
"""
returns last child added to input node
"""
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

"""
adds child to input node
"""
function addchild!(parent::hTree.lnode, value)
    #println("init addchild $name")
    new = hTree.lnode{typeof(value)}(value)
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
function addchild!(parent::hTree.lnode, value, label::String)
    #println("init addchild $name")
    new = hTree.lnode{typeof(value)}(value, label)
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