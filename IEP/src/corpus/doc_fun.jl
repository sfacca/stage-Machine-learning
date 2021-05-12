
struct doc_fun
    doc::String
    fun::String
    doc_fun(doc::String,fun::String) = new(doc, fun);
    doc_fun(doc::Nothing,fun::String) = new("", fun);
end
"""
get doc_fun from a filedef scrape
"""
function get_doc_fun(fds::Array{FileDef,1})::Array{doc_fun,1}
    res = Array{doc_fun,1}(undef, 0)
    for fd in fds
        res = vcat(res, get_doc_fun(fd))
    end
    res
end
function get_doc_fun(fd::Array{FileDef,1})::Array{doc_fun,1}
    father = fd.path
    res = Array{doc_fun,1}(undef, 0)
    
    if !isnothing(fd.functions) && !isempty(fd.functions)
        for funcdef in fd.functions
            push!(res, doc_fun(funcdef.doc, string("($father).", getName(funcdef.name)))
        end
    end

    if !isnothing(fd.modules) && !isempty(fd.modules)
        for mod in fd.modules
            res = vcat(res , get_doc_fun(mod, "($father)"))
        end
    end

    res
end
function get_doc_fun(mdf::ModuleDef, father = nothing)::Array{doc_fun,1}
    res = Array{doc_fun,1}(undef, 0)    
    father = isnothing(father) ? mdf.name : string(father,".", mdf.name)

    if !isnothing(mdf.submodules) && !isempty(mdf.submodules)
        for submdf in mdf.submodules
            res = vcat(res, get_doc_fun(submdf, father))
        end
    end

    if !isnothing(mdf.implements) && !isempty(mdf.implements)
        for func in mdf.implements
            push!(res, doc_fun(func.doc, string(father, ".", func.name)))
        end
    end

    res
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
function _add_to_map!(fd::FileDef, res)
    origin = fd.path

    if !isnothing(fd.includes) && !isempty(fd.includes)
        for incl in fd.includes
            push!(res, (get_links(origin, incl)=> origin))
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
            push!(res, (get_links(origin, incl)=>mod.name))
        end
    end

    if !isnothing(mod.submodules) && !isempty(mod.submodules)
        for submod in mod.submodules
            _add_to_map!(submod, origin)
        end
    end
    res
end



