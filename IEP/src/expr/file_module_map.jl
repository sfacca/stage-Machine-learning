
function get_file_module_map(filepath::String, res = nothing)
    get_file_module_map(load(filepath)[splitext(basename(filepath))[1]])
end


function get_file_module_map(data::Array{FileDef,1}, res = nothing)
    # dict (filepath) => module name of module that includes it
    # dict (filepath) => (filepath) of file that includes it
    if isnothing(res)
        res = Dict()
    end

    for fd in data
        _add_to_map!(fd, res)
    end

    res
end
function _add_to_map!(fds::Array{FileDef,1}, res)
    for fd in fds
        _add_to_map!(fd, res)
    end
end
function _add_to_map!(fd::FileDef, res)
    origin = fd.path

    if !isnothing(fd.includes) && !isempty(fd.includes)
        for incl in fd.includes
            push!(res, ((lowercase(get_links((origin, incl))[2]))=> origin))
        end
    end

    if !isnothing(fd.modules) && !isempty(fd.modules)
        for mod in fd.modules
            _add_to_map!(mod, res, origin)
        end
    end

    res
end
function _add_to_map!(mod::ModuleDef, res, origin)

    if !isnothing(mod.includes) && !isempty(mod.includes)
        for incl in mod.includes
            push!(res, ((lowercase(get_links((origin, incl))[2]))=>mod.name))
        end
    end

    if !isnothing(mod.submodules) && !isempty(mod.submodules)
        for submod in mod.submodules
            _add_to_map!(submod, res, origin)
        end
    end
    res
end

function __swap_slash(str::String)
    # replace \\ with /
    replace(str, r"\\\\"=>"/")
end
function __extract_father(str::String)
    __swap_slash(lowercase(split(str, "|")[2]))
end

function apply_map!(dfs::Union{Array{doc_fun_block,1},Array{doc_fun,1}}, map)    
    for i in 1:length(dfs)
        dfs[i] = apply_map(dfs[i], map)
    end
end
function apply_map(df::Union{doc_fun_block,doc_fun}, map)
    parts = split(df.fun, "|")
    i = 0
    if length(parts) == 3
        father = replace(lowercase(parts[2]), r"\\\\"=>"/")
        son = parts[3]
        if haskey(map, father)
            df.fun = string(map[father], son)
        else
            if occursin(r"/src/", father)
                println("unhandled father $father")
            end
        end
    end
    df
end

function get_unhandled(dfs::Union{Array{doc_fun_block,1},Array{doc_fun,1}}, map)
    res = []
    for df in dfs
        if is_unhandled(df, map)
            push!(res, df.fun)
        end
    end
    res
end

function dir_to_unhandled(dir, number=false)
    res = []
    i = 0
    for (root, dirs, files) in walkdir(dir)
        for file in files
            
            if endswith(file ,"jld2")
                tmp = load(joinpath(root, file))[splitext(file)[1]]                                
                map = get_file_module_map(tmp)
                tmp = get_doc_fun(tmp)
                if number
                    if has_unhandled(tmp, map)
                        push!(res, splitext(file)[1])
                    end
                else
                    tmp = get_unhandled(tmp, map)
                    if length(tmp) > 0
                        res = vcat(res, unique(tmp))
                    end
                end
                println("finished $(splitext(file)[1])")
                i+=1
            end
        end
    end
    if number
        println("$(length(res)) / $i")
    end
    res
end

function is_unhandled(df::Union{doc_fun_block, doc_fun}, map)
    occursin(r"|", df.fun) && occursin(r"src", df.fun) && !haskey(map, __extract_father(df.fun))        
end
function has_unhandled(dfs::Union{Array{doc_fun_block,1},Array{doc_fun,1}}, map)
    res = false
    for df in dfs
        if is_unhandled(df, map)
            res = true
            return true
        end
    end
    res
end
            


