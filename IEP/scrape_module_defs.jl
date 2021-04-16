#= we want 2 things:
1. all module names of module definitions, with filepath of where they're defined
2. for every module, the list of modules it's using
3. for every module, every file it includes
4. for every module, every submodule

this is overly complicated
just assume module name from file/path, then collect all usings
(this means no submodules architecture)
=#

using CSTParser
""""""
function find_modules(e::CSTParser.EXPR)
    # looks into expression and sub expressions looking for module definitions
    name = is_moduledef(e)
            
    if _checkArgs(e)
        for se in e.args

        end
    end


end

function scrape_usings(e::CSTParser.EXPR)
    res = getUsings(e)
    if length(res) == 0
        # e wasnt a using expression
        # we look at the sub expressions
        if _checkArgs(e)
            for arg in e.args
                res = vcat(res, scrape_usings(arg))
            end
        end
    end
    res    
end

"""returns nothing if expression isnt a module def, expression of module otherwise"""
function is_moduledef(e::CSTParser.EXPR)
    (e.head == :module) ? e : nothing
end

function getUsings(e::CSTParser.EXPR)::Array{String,1}
    res = Array{String,1}(undef, 0)
    if e.head == :using
        if _checkArgs(e)
        else
            # some modules might be dotted (eg TextAnalysis.Parse)
            # we just get the base one
            res = unique([string(x.args[1].val) for x in e.args])# unique because ^            
            # we might get "nothing"
            res = filter((x)->(x != "nothing"), res)
        end
    end
    res
end





function scrapeModules(e::CSTParser.EXPR)
    res = Array{ModuleDef,1}(undef,0)
    tmp = is_moduledef(e)
    if !isnothing(tmp)
        res= [ModuleDef(e)]
    end
    # finding submodules
    if _checkArgs(e)
        for arg in e.args
            res = vcat(res, scrapeModules(arg))
        end
    end
    res
end
            


struct ModuleDef
    name::String
    submodules::Union{Array{String,1},Nothing}
    usings::Union{Array{String,1},Nothing}
    includes::Union{Array{String,1},Nothing}
    implements::Union{Array{FunctionContainer, 1}, Nothing}
    ModuleDef(name::String) = new(name, nothing, nothing, nothing, nothing)
    ModuleDef(e::CSTParser.EXPR) = ModuleDef(e.args[firstIdentifier(e)].val)
end

function firstIdentifier(e::CSTParser.EXPR)
    i = 0
    if _checkArgs(e)
        i = findfirst((x)->(x.head == :IDENTIFIER) ,e.args)
        if isnothing(i)
            throw("did not find an :IDENTIFIER in expression $e")
        end
        i
    else
        throw("tried looking for :IDENTIFIER sub expression in expression with no args: $e")
    end
    i
end


# delete this (redundancy)
function _checkArgs(e)
	!isnothing(e.args) && !isempty(e.args)
end

