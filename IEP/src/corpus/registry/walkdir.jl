#=
include("../write_to_txt.jl")

function __get_name(root)
	split(root, "\\")[end]
end

res = []
for (root, dirs, files) in walkdir("out")
    push!(res, string("files: ", files))
    push!(res, string("dirs: ", dirs))
    push!(res, string("root: ", __get_name(root)))
end
write_to_txt("treeview", res)
=#

function get_filepaths(dir, extension=nothing)
    res = []
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if isnothing(extension) || endswith(file,  extension)
                push!(res, (root, file))
            end
        end
    end
    res
end

function load_file(root, file)#::Array{FileDef,1}
    load(joinpath(root, file))[splitext(file)[1]]
end

function get_module_names(mdf::IEP.ModuleDef)
    res = []
    for sub in mdf.submodules
        push!(res, sub.name)
    end
    res
end
function get_module_names(fd::IEP.FileDef)
    res = []
    for mdf in fd.modules
        push!(res, (fd.path, mdf.name))
        if !isempty(mdf.submodules)
            tmp = get_module_names(mdf)
            tmp = [(fd.path,x) for x in tmp]
            res = vcat(res, tmp)
        end        
    end
    res
end
function get_module_names(fds::Array{IEP.FileDef,1})
    res = []
    for fd in fds
        res = vcat(res, get_module_names(fd))
    end
    res
end