
mutable struct doc_fun
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
function get_doc_fun(fd::FileDef)::Array{doc_fun,1}
    father = fd.path
    res = Array{doc_fun,1}(undef, 0)
    
    if !isnothing(fd.functions) && !isempty(fd.functions)
        for funcdef in fd.functions
            push!(res, doc_fun(funcdef.docs, string("|$father|.", getName(funcdef.name))))
        end
    end

    if !isnothing(fd.modules) && !isempty(fd.modules)
        for mod in fd.modules
            res = vcat(res , get_doc_fun(mod, "|$father|"))
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
            push!(res, doc_fun(func.docs, string(father, ".", func.name)))
        end
    end

    res
end

function dir_to_doc_fun(dir::String)

    res = Array{doc_fun,1}(undef, 0)
    
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file ,"jld2")
                tmp = load(joinpath(root, file))[splitext(file)[1]]
                tmp_res = get_doc_fun(tmp)                
                map = get_file_module_map(tmp)
                apply_map!(tmp_res, map)
                res = vcat(res, tmp_res)
            end
        end
    end

end






