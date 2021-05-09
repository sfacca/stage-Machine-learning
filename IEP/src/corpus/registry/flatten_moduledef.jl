ModuleDef = IEP.ModuleDef
FileDef = IEP.FileDef

#if a module includes a file, that module implements and uses every function/module/etc in that file
function flatten!(container::FileDef, data::Array{FileDef,1})
    links = get_links(container)
    for i in 1:length(container.modules)
        mdf = container.modules[i]
        paths = find_files(links[i], data)
        for path in paths            
            add_file_to_module!(mdf, data[path])
        end
    end         
end

function flatten!(data::Array{FileDef,1})
    for fd in data
        flatten!(fd, data)
    end
end

function find_file(filepath::String, data::Array{FileDef,1})
    tmp = findfirst((x)->(x.path==filepath), data)
    if !isnothing(tmp)
        data[tmp]
    else
        nothing
    end
end

function find_files(paths::Array{String,1}, data::Array{FileDef,1})
    res = []
    for path in paths
        tmp = findfirst((x)->(x.path==path), data)
        push!(res, tmp)
    end
    res
end

function add_file_to_module!(m::ModuleDef, f::FileDef)
    m.submodules = vcat(m.submodules, f.modules)
    m.usings = vcat(m.usings, f.uses)
    m.implements = vcat(m.implements, f.functions)
    m.includes = vcat(m.includes, f.includes)
    m
end

function get_links(origin::String, path::String)::String
    # get base path
    origin = split(origin,"\\")[1:(end-1)]# this removes the filename
    path = split(replace(path, r"/"=>"\\"),"\\")
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
    string(origin.*"\\"...)[1:(end-1)]
end

function get_links(origin, paths::Array{String,1})::Array{String,1}
    res = [get_links(origin, x) for x in paths]
end

function get_links(fd::IEP.FileDef)
    res = []
    for mdf in fd.modules
        push!(res, get_links(fd.path, mdf.includes))
    end
    res
end

function resolve_includes!(fd::IEP.FileDef)
    for mdf in fd.modules
        mdf.includes = get_links(fd.path, mdf.includes)
    end
    fd
end

function _get_mdfs(fds::Array{FileDef,1})::Array{ModuleDef,1}
    res = []
    for fd in fds
        if !isempty(fd.modules)
            res = vcat(res, fd.modules)
        end
    end
    res
end




function flatten_dir(dir::String)# wow this is terrible
    fails = []
    i = 0
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file ,".jld2")
                i+=1
                try
                    filedefs = load(joinpath(root, file))[splitext(file)[1]]
                    flatten!(filedefs)
                    #rm(joinpath(root, file))
                    save(joinpath(root,file), Dict(splitext(file)[1] => filedefs))
                    println("flattened file $i : $file")
                catch e
                    println("failed flattening file $i : $file")
                    push!(fails, (file, e))
                end
            end
        end
    end
end

function save_flat(root, file)
    filedefs = load(joinpath(root, file))[splitext(file)[1]]
    flatten!(filedefs)
    #rm(joinpath(root, file))
    save(joinpath(root,file), Dict(splitext(file)[1] => filedefs))
end


#=
ModuleDef
    name::String
    submodules::Union{Array{ModuleDef,1},Nothing}
    usings::Union{Array{String,1},Nothing}
    includes::Union{Array{String,1},Nothing}
    implements::Union{Array{FuncDef, 1}, Nothing}
    docs::Union{String, Nothing}

FileDef
    path::String
    uses
    modules
    functions
    includes
=#