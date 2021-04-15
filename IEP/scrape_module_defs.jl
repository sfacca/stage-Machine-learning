#= we want 2 things:
1. all module names of module definitions, with filepath of where they're defined
2. for every module, the list of modules it's using
3. for every module, every file it includes
=#
""""""
function find_modules(e::CSTParser.EXPR)
    # looks into expression and sub expressions looking for module definitions
    name = is_moduledef(e)
            
    if _checkArgs(e)
        for se in e.args

        end
    end


end

function scrape_usings_includes(e::CSTParser.EXPR)
    res = []
    
end

"""returns nothing if expression isnt a module def, expression of module otherwise"""
function is_moduledef(e::CSTParser.EXPR)
    (e.head == :module) ? e : nothing
end


# delete this (redundancy)
function _checkArgs(e)
	!isnothing(e.args) && !isempty(e.args)
end


struct ModuleDef
    name::String
    submodules::Union{Array{String,1},Nothing}
    usings::Union{Array{String,1},Nothing}
    includes::Union{Array{String,1},Nothing}
end
