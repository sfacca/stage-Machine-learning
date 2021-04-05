function _dir_to_docfuns(dir)
    res = Array{doc_fun,1}(undef, 0)
    for (root, dirs, files) in walkdir(dir)
		try
			len = length(files)
			i = 1
			for file in files
				if endswith(file, ".jld2")	
					println("handling $file")
					name = string(split(file,".jld2")[1])
                    tmp = load(joinpath(root, file))[name]
                    # we only need name and docstring
					for fd in tmp
						if !isnothing(fd.docs) && fd.docs != ""# is there a docstring?
							push!(res, doc_fun(fd.docs, string(name,".", IEP.getName(fd.func.name))))					
						end
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
	res
end