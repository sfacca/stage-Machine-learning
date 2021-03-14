

function read_nbs(dir, maxlen=500, file_type="ipynb", verbose=false)
    comments = r"\#.*\n"
    docstring = r"\"{3}.*?\"{3}"s

    all_funcs = []
    sources = []

	fils = []
    for (root, dirs, files) in walkdir(dir)
		#println("root: $root")
		#println("dirs: $dirs")
		#println("files: $files")
        for file in files
            if endswith(file, "."*file_type)
				#println("parsing $(joinpath(root, file))")
				#push!(fils, joinpath(root, file))
                pj = [string(y["source"]...) for y in filter((x)->(x["cell_type"] == "code") ,JSON.parse(join(readlines(joinpath(root, file))))["cells"])]

                for code_cell in pj
                    s = CSTParser.parse(code_cell, true)
                    if !isnothing(s)
                        all_funcs = vcat(
                                all_funcs, get_expr(s, joinpath(root, file), verbose));
                    end
                end
            end
        end
    end

    filter!(x->x!="",all_funcs)
    filter!(x -> length(x)<=maxlen, all_funcs)
	unique(all_funcs)
	#fils
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
