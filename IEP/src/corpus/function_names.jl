using FileIO, JLD2

getName = IEP.getName

function names(fd)
    ns = []
    add_names!(fd, ns)
end

function add_names!(fd, ns)
    for f in fd
        push!(ns, getName(f.func.name))        
    end
    ns
end

function alt_add_names!(fd, ns)
    tmp = Array{String,1}(undef, length(fd))
    for i in 1:length(fd)
        tmp[i] = getName(fd[i].func.name)
    end
    vcat(ns, tmp)
end

"""
uses ids from ids to overwrite func names in fds
returns index of first unused id
errors if there are more func defs than ids
"""
function names_ids!(fd::Array{IEP.FunctionContainer,1}, ids)
    i=1
    for f in fd
        if i>length(ids)
            throw("out of bounds error: need more ids!")
        else
            f.func.name = ids[i]
            i += i
        end
    end
    i
end



function get_ids(names)
    try
        Int32.(collect(0:length(names)))
    catch e
        @warn "failed casting with error: $e"
        collect(0:length(names))
    end
end

function names_in_dir(dir)
    ns = []
    for (root, dirs, files) in walkdir(dir)
		try
			len = length(files)
			i = 1
			for file in files
				if endswith(file, ".jld2")	
					println("handling $file")
					name = string(split(file,".jld2")[1])
					tmp = Array{IEP.FunctionContainer,1}(undef,0)
					tmp = vcat(tmp, load(joinpath(root, file))[name])
					println(unique([typeof(x) for x in tmp]))
					if isnothing(tmp)
						println("$file appears empty")
					else
						println("adding stuff...")
						add_names!(tmp, ns)
					end
					tmp = nothing
				end
				println("############## $((100*i)/len)% DONE ##############")
				i = i + 1
			end
		catch e
			println("error at file: $file")
			println(e)
		end
	end
    ns
end


