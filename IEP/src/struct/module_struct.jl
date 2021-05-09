mutable struct ModuleDef
    name::String
    submodules::Union{Array{ModuleDef,1},Nothing}
    usings::Union{Array{String,1},Nothing}
    includes::Union{Array{String,1},Nothing}
    implements::Union{Array{FuncDef, 1}, Nothing}
    docs::Union{String, Nothing}
    ModuleDef(a,b,c,d,e,f) = new(a,b,c,d,e,f)    
    ModuleDef(a,b,c,d,e::Array{FuncDef, 1},f) = new(a,b,c,d,_conv(e),f)
    ModuleDef(name::String, doc::String) = new(name, [], [], [], [], doc)    
    ModuleDef(e::CSTParser.EXPR, doc::String) = ModuleDef(e.args[firstIdentifier(e)].val, doc)
    ModuleDef(name::String) = new(name, [], [], [], [], [])
    ModuleDef(e::CSTParser.EXPR) = ModuleDef(e.args[firstIdentifier(e)].val)
    
end
