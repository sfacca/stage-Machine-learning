struct file_node
    path::String
    points::Union{Array{String,1},Nothing}
    file_node(p)=new(p,nothing)
    file_node(p,a)=new(p,a)
end

mutable struct FileDef
    path::String
    uses
    modules
    functions
    includes
    FileDef(a,b,c,d,e) = new(a,b,c,d,e)
    FileDef() = new("empty", [],[], [], [])
end