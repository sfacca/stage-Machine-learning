function read_mds(dir, verbose=false)

    all_funcs = []    
    for (root, dirs, files) in walkdir(dir)
		#println("root: $root")
		#println("dirs: $dirs")
		#println("files: $files")
        for file in files
            if endswith(file, ".md")
				#println("parsing $(joinpath(root, file))")
				#push!(fils, joinpath(root, file))
                lines = readlines(joinpath(root, file))
                code = false
                tmp = ""
                for line in lines
                    if code
                        if line == "```"
                            code = false
                            
                            s = CSTParser.parse(tmp, true)
                            if !isnothing(s)
                                all_funcs = vcat(
                                        all_funcs, get_expr(s, joinpath(root, file), verbose));
                            end
                            #push!(all_funcs, tmp)
                            tmp = ""
                        else
                            tmp = string(tmp, "\n", line)
                        end
                    else
                        if line == "```Julia"
                            code = true
                        end
                    end
                end
            end
        end
    end

	unique(all_funcs)
end


function get_expr(exp_tree, path, verbose=false)
    leaves = []

    for arg in exp_tree.args
        if verbose
            println(arg)
        end
        #if typeof(arg) == CSTParser.EXPR e.args è Array{CSTParser.EXPR, 1}
		if arg.head != :block
			if verbose
				println("Pushed!")
			end
			push!(leaves, (arg, path))
		else
			if verbose
				println("Recursing!")
			end
			leaves = vcat(leaves, get_expr(arg, path, verbose))
		end
		#end
    end

    return leaves
end
