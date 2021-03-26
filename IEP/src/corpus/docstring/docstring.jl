function docstrings_from_jld2s(dir)
    
    res = Array{doc_fun, 1}(undef, 0)

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
						for fc in tmp
							println("adding $(IEP.getName(fc.func.name))")	
							try	
								if !isnothing(fc.docs)				
									push!(res, doc_fun(fc.docs, IEP.getName(fc.func.name)))
								end
							catch e
								println("err on file: $file, fc: $(fc.func.name)")
                                println(e)
							end
						end
					end
					tmp = nothing
				end
				println("############## $((100*i)/len)% DONE ##############")
				i = i + 1
			end
        catch e
            println("err on file: $file")
            println(e)
        end


    end
    res
end