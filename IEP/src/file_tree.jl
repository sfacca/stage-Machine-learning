function read_folder(dir)
    fs = []
    for (root, dirs, files) in walkdir(dir)
		
        for file in files
            if endswith(file, ".jl")
                push!(fs, (root, file) )
            end          
        end
    end

    fsd = Array{FileDef, 1}(undef, length(fs))
    for i in 1:length(fs)
        fsd[i] = handleFile(fs[i][1], fs[i][2])
    end
    
end

#CSTParser.parse(read(joinpath(root, file), String), true)

struct FileDef
    path::String
    uses
    modules
    functions
    includes
end

"""
this function returns included file if the given expr is an include, nothing otherwise"""
function is_include(e::CSTParser.EXPR)::Union{Nothing, String}
    res = nothing
    if e.head == :call
        # it's a call, let's check called function
        if !isnothing(e.args) && length(e.args)>1
            if e.args[1].head == :IDENTIFIER && e.args[1].val == "include"
                res = e.args[2].val
            end
        end
    end
    res
end

"""returns nothing if expression isnt a module def, expression of module otherwise"""
function is_moduledef(e::CSTParser.EXPR)
    (e.head == :module) ? e : nothing
end

function scrapeModuleDef(e::CSTParser.EXPR)
    #=
    name::String
    submodules::Union{Array{String,1},Nothing}
    usings::Union{Array{String,1},Nothing}
    includes::Union{Array{String,1},Nothing}
    implements::Union{Array{FunctionContainer, 1}, Nothing}
    =#
    if e.head == :module
        # initialize the module
        res = ModuleDef(e)

        #scrape stuff from module block
        if _checkArgs(e)

            res.includes, res.usings, res.submodules, res.implements = _handleExprArr(parse)
        end
        
    end
    res
end

function scrapeMacroCall(e::CSTParser.EXPR)

end



struct ModuleDef
    name::String
    submodules::Union{Array{String,1},Nothing}
    usings::Union{Array{String,1},Nothing}
    includes::Union{Array{String,1},Nothing}
    implements::Union{Array{FunctionContainer, 1}, Nothing}
    docs::Union{String, Nothing}
    ModuleDef(name::String, doc::String) = new(name, nothing, nothing, nothing, nothing, doc)    
    ModuleDef(e::CSTParser.EXPR, doc::String) = ModuleDef(e.args[firstIdentifier(e)].val, doc)
    ModuleDef(name::String) = new(name, nothing, nothing, nothing, nothing, nothing)
    ModuleDef(e::CSTParser.EXPR) = ModuleDef(e.args[firstIdentifier(e)].val)
    
end


function is_using(e::CSTParser.EXPR)
    res = nothing
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

function _handleExprArr(parse)
    includes = []
    uses = []
    modules = []
    functions = []
    docs = nothing
    docfind = false
    for expr in parse
        tmp = _genericScrape(expr)
        # this would be better as match case
        tincludes, tuses, tmodules, tfunctions = _parseHandler(tmp)
        includes = vcat(includes, tincludes)
        uses = vcat(uses, tuses)
        modules = vcat(modules, tmodules)
        functions = vcat(functions, tfunctions)
        tmp = nothing

        tincludes, tuses, tmodules, tfunctions, tdocs, tdf = _parseHandler(elem, _docfind)
        _docfind = tdf
        if !isnothing(tincludes)
            if !isnothing(_docs)
                setDocs!(tincludes, _docs)
                _setDocs = true
            end
            if isnothing(includes)
                includes = tincludes
            else
                includes = vcat(includes, tincludes)
            end
        end
        if !isnothing(tuses)
            if !isnothing(_docs)
                setDocs!(tuses, _docs)
                _setDocs = true
            end
            if isnothing(uses)
                uses = tuses
            else
                uses = vcat(uses, tuses)
            end
        end
        if !isnothing(tmodules)
            if !isnothing(_docs)
                setDocs!(tmodules, _docs)
                _setDocs = true
            end
            if isnothing(modules)
                modules = tmodules
            else
                modules = vcat(modules, tmodules)
            end
        end
        if !isnothing(tfunctions)
            if !isnothing(_docs)
                setDocs!(tmotfunctionsdules, _docs)
                _setDocs = true
            end
            if isnothing(functions)
                functions = tfunctions
            else
                functions = vcat(functions, tfunctions)
            end                
        end

        if _setDocs
            _docs = nothing
            _setDocs = false
        end
        
        if !isnothing(tdocs)
            _docs = tdocs
        end
    end
    includes, uses, modules, functions
end


function handleFile(folder, file)
    path = joinpath(folder, file)

    parse = CSTParser.parse(read(joinpath(folder, file), String), true)

    includes, uses, modules, functions = _handleExprArr(parse)

    FileDef(path, uses, modules, functions, includes)
end

function _parseHandler(tuple, docfind)
    includes = nothing
    uses = nothing
    modules = nothing
    functions = nothing
    docs = nothing
    tmp = _genericScrape(expr)
    # this would be better as match case
    if tmp[1] == "include"
        includes = [tmp[2]]
    elseif tmp[1] == "using"
        uses = tmp[2]
    elseif tmp[1] == "module"
        modules= [ tmp[2]]
    elseif tmp[1] == "function"
        functions = [tmp[2]]
    elseif tmp[1] == "macrocall"
        _docfind = false
        _docs = nothing
        _setDocs = false
        for elem in tmp[2]           
            tincludes, tuses, tmodules, tfunctions, tdocs, tdf = _parseHandler(elem, _docfind)
            _docfind = tdf
            if !isnothing(tincludes)
                if !isnothing(_docs)
                    setDocs!(tincludes, _docs)
                    _setDocs = true
                end
                if isnothing(includes)
                    includes = tincludes
                else
                    includes = vcat(includes, tincludes)
                end
            end
            if !isnothing(tuses)
                if !isnothing(_docs)
                    setDocs!(tuses, _docs)
                    _setDocs = true
                end
                if isnothing(uses)
                    uses = tuses
                else
                    uses = vcat(uses, tuses)
                end
            end
            if !isnothing(tmodules)
                if !isnothing(_docs)
                    setDocs!(tmodules, _docs)
                    _setDocs = true
                end
                if isnothing(modules)
                    modules = tmodules
                else
                    modules = vcat(modules, tmodules)
                end
            end
            if !isnothing(tfunctions)
                if !isnothing(_docs)
                    setDocs!(tmotfunctionsdules, _docs)
                    _setDocs = true
                end
                if isnothing(functions)
                    functions = tfunctions
                else
                    functions = vcat(functions, tfunctions)
                end                
            end

            if _setDocs
                _docs = nothing
                _setDocs = false
            end
            
            if !isnothing(tdocs)
                _docs = tdocs
            end

        end
    elseif tmp[1] == "globalrefdoc"
        docfind = true
    elseif docfind && tmp[1] == "string"
        docfind = false
        docs = tmp[2]
    end
    tmp = nothing
    includes, uses, modules, functions, docs, docfind
end


function _genericScrape(expr::CSTParser.EXPR)
    # what is e?
    res = is_include(expr)
    if !isnothing(res)
        res = ("include", res)
    else
        res = is_using(expr)
        if !isnothing(res)
            res = ("using", res)
        else
            res = scrapeModuleDef(expr)
            if !isnothing(res)
               res = ("module", res)
            else
                res = scrapeFuncDef(expr)
                if !isnothing(res)
                    res = ("function", res)
                else
                    if expr.head == :macrocall 
                        # macrocall can have docstrings
                        tmp = []
                        if _checkArgs(expr)
                            for arg in expr.args
                                push!(tmp, _genericScrape(arg))
                            end
                        end
                        res = ("macrocall", tmp)
                    elseif expr.head == :globalrefdoc
                        res = ("globalrefdoc", "")
                    elseif expr.head == :TRIPLESTRING
                        res = ("string", expr.val)
                    end
                end
            end
        end
    end
    res
end



