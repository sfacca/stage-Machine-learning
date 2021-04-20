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
        println("#### HANDLING FILE $(fs[i][2]) ####")
        fsd[i] = handleFile(fs[i][1], fs[i][2])
    end
    fsd
end

#CSTParser.parse(read(joinpath(root, file), String), true)

struct FileDef
    path::String
    uses
    modules
    functions
    includes
    FileDef() = new("empty", nothing, nothing, nothing, nothing)
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
    res = nothing
    if e.head == :module
        # initialize the module
        res = ModuleDef(e)

        #scrape stuff from module block
        if _checkArgs(e)

            res.includes, res.usings, res.submodules, res.implements = _handleExprArr(e.args)
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

function _handleExprArr(prs::Array{CSTParser.EXPR,1})
    println("type of prs is $(typeof(prs))")
    includes = []
    uses = []
    modules = []
    functions = []
    docs = nothing
    #docfind = false
    _docfind = false
    println("before for")
    for expr in prs
        println("after for")
        tmp = _genericScrape(expr)#=
        # this would be better as match case
        tincludes, tuses, tmodules, tfunctions = _parseHandler(tmp, docfind)
        includes = vcat(includes, tincludes)
        uses = vcat(uses, tuses)
        modules = vcat(modules, tmodules)
        functions = vcat(functions, tfunctions)
        tmp = nothing=#

        tincludes, tuses, tmodules, tfunctions, tdocs, tdf = _parseHandler(tmp, _docfind)
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
    println("parsing...")
    prs = CSTParser.parse(read(joinpath(folder, file), String), true)
    println("prs type $(typeof(prs))")
    println("handling...")
    println("prs type $(typeof(prs))")
    if _checkArgs(prs)
        includes, uses, modules, functions = _handleExprArr(prs.args) 
        println("generating FileDef...")
        FileDef(path, uses, modules, functions, includes)
    else

    end 

end

function _parseHandler(tuple, docfind)
    includes = nothing
    uses = nothing
    modules = nothing
    functions = nothing
    docs = nothing
    tmp = tuple
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
    println("generic scrape")
    # what is e?
    res = is_include(expr)
    println("ok dude")
    if !isnothing(res)
        res = ("include", res)
    else
        println("res is nothing")
        res = is_using(expr)
        if !isnothing(res)
            res = ("using", res)
        else
            println("heeelp")
            res = scrapeModuleDef(expr)
            println("after scrape module def")
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
    println("finished generic scrape")
    res
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


function scrape_includes(e::CSTParser.EXPR)::Array{String}
	res = Array{String,1}(undef, 0)
	tmp = is_include(e)
	if !isnothing(tmp)
		res = [tmp]
	else
        if _checkArgs(e)
            for sube in e.args
                res = vcat(res, scrape_includes(sube))
            end
        end
	end
    #println(typeof(res))
	res
end


function scrape_includes(arr::Array{CSTParser.EXPR,1})::Array{String}
	res = Array{String,1}(undef, 0)
	for e in arr
        res = vcat(res,scrape_includes(e))
	end
	res
end


function scrape_includes(tuple::Tuple{CSTParser.EXPR,String})
	[(tuple[2], x) for x in scrape_includes(tuple[1])]
end


function aux_stuff(arr)
	res = []
	for tuple in arr
		res = vcat(res, scrape_includes(tuple))
	end
	res
end

function get_links(arr::Array{Any,1})
    res = Array{Tuple{String,String},1}(undef, length(arr))
    for i in 1:length(arr)
        res[i] = get_links(arr[i])
    end
    res
end

function get_links(tuple)::Tuple{String,String}
    # get base path
    origin = split(tuple[1],"\\")[1:(end-1)]# this removes the filename
    path = split(tuple[2],"\\")
    for name in path
        if name == ".."
            if length(origin)>0
                origin = origin[1:(end-1)]# "../" means go back one folder
            else
                origin = [".."]
            end
        else
            push!(origin, name)
        end
    end
    (tuple[1],string(origin.*"\\"...)[1:(end-2)])
end

function make_tree(tuple)
    lnks = get_links(tuple)
    lnks = lnks[sortperm([x[1] for x in lnks])]
    res = []
    tmp = nothing
    me = lnks[1][1]
    for link in lnks
        if link[1] == me
            # add link
            if !isnothing(tmp)
                push!(tmp, link[2])
            else
                tmp = [link[2]]
            end
        else
            # add file_node
            push!(res, file_node(me, tmp))
            # new me
            me = link[1]
            tmp = [link[2]]
        end
    end
    # do the last one
    push!(res, file_node(me, tmp))
    
    res
end

    # make the leaf nodes
    #= just add them when they're missing
    all_filepaths = []
    for x in res
        append!(all_filepaths, x.points)
        push!(all_filepaths, x.path)
    end
    all_filepaths = sort(unique(all_filepaths))
    all_nodes = sort([x.path for x in res])

    to_add = []
    for i in 1:length(all_filepaths)
        if all_filepaths in all_nodes
        else
            push!(to_add, i)
        end
    end

    to_add = all_filepaths[to_add]
    tmp = Array{file_node,1}(undef, length(to_add))
    for i in 1:length(to_add)
        tmp[i] = file_node(to_add[i])
    end
    vcat(res, tmp)=#



struct file_node
    path::String
    points::Union{Array{String,1},Nothing}
    file_node(p)=new(p,nothing)
    file_node(p,a)=new(p,a)
end

# delete this (redundancy)
function _checkArgs(e)
	!isnothing(e.args) && !isempty(e.args)
end




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





