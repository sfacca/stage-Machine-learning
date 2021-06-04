
mutable struct doc_fun_block
    doc::String
    fun::String
    block::CSTParser.EXPR
    doc_fun_block(doc::String,fun::String) = new(doc, fun, CSTParser.parse(""));
    doc_fun_block(doc::Nothing,fun::String) = new("", fun);
    doc_fun_block(doc::String,fun::String,block::CSTParser.EXPR) = new(doc,fun,block)
    doc_fun_block(fun::String, block::CSTParser.EXPR) = new("", fun, block)
    doc_fun_block(doc::Nothing,fun::String, block::CSTParser.EXPR) = new("", fun, block);

end
"""
get doc_fun_block from a filedef scrape
"""
function get_doc_fun_block(fds::Array{FileDef,1})::Array{doc_fun_block,1}
    res = Array{doc_fun_block,1}(undef, 0)
    for fd in fds
        res = vcat(res, get_doc_fun_block(fd))
    end
    res
end
function get_doc_fun_block(fd::FileDef)::Array{doc_fun_block,1}
    father = fd.path
    res = Array{doc_fun_block,1}(undef, 0)
    
    if !isnothing(fd.functions) && !isempty(fd.functions)
        for funcdef in fd.functions
            push!(res, doc_fun_block(funcdef.docs, string("|$father|.", getName(funcdef.name)), funcdef.block))
        end
    end

    if !isnothing(fd.modules) && !isempty(fd.modules)
        for mod in fd.modules
            res = vcat(res , get_doc_fun_block(mod, "|$father|"))
        end
    end

    res
end
function get_doc_fun_block(mdf::ModuleDef, father = nothing)::Array{doc_fun_block,1}
    res = Array{doc_fun_block,1}(undef, 0)    
    father = isnothing(father) ? mdf.name : string(father,".", mdf.name)

    if !isnothing(mdf.submodules) && !isempty(mdf.submodules)
        for submdf in mdf.submodules
            res = vcat(res, get_doc_fun_block(submdf, father))
        end
    end

    if !isnothing(mdf.implements) && !isempty(mdf.implements)
        for func in mdf.implements
            push!(res, doc_fun_block(func.docs, string(father, ".", getName(func.name)), func.block))
        end
    end

    res
end

function dir_to_doc_fun_block(dir::String)

    res = Array{doc_fun_block,1}(undef, 0)
    
    for (root, dirs, files) in walkdir(dir)
        for file in files
            len = length(files)
            i=1
            if endswith(file ,"jld2")
                tmp = load(joinpath(root, file))[splitext(file)[1]]
                tmp_res = get_doc_fun_block(tmp)                
                map = get_file_module_map(tmp)
                apply_map!(tmp_res, map)
                res = vcat(res, tmp_res)
                println("finished $(splitext(file)[1])")
                
            end
        end
    end
    res
end

function file_to_doc_fun_block(root, file)
    tmp = load(joinpath(root, file))[splitext(file)[1]]
    res = get_doc_fun_block(tmp)                
    map = get_file_module_map(tmp)
    apply_map!(res, map)
    println("finished $(splitext(file)[1])")
    res
end

function make_dfbs(dir)
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file ,"jld2")
                
            end
        end
    end
end


