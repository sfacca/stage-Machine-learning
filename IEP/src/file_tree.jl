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


function handleFile(folder, file)
    path = joinpath(folder, file)

    includes = []
    uses = []
    modules = []
    functions = []
    

    parse = CSTParser.parse(read(joinpath(folder, file), String), true)

    for expr in parse
        incl = is_include(expr)
        if !isnothing(incl)
            push!(includes, incl)
        else
            usings = is_using(expr)
            if !isnothing(usings)
                uses = vcat(uses, usings)
            else
                mod = is_moduledef(expr)
                if !isnothing(mod)
                    push!(modules, scrapeModule(expr))# missing definition
                else
                    func = scrapeFuncDef(expr)
                    if !isnothing(func)
                        push!(functions, func)
                    end
                end
            end
        end
    end

    FileDef(path, uses, modules, functions, includes)
end



