#using Pkg, DelimitedFiles, CSTParser

#include("./parse.jl")
"""
explores folder tree of dir, parses all .jl/.ipynb code found
* dir: base path
* maxlen = 500: files bigger than maxlen are ignored
* file_type = "jl": file extension in which to find code to parse
"""
function read_code(dir, verbose=false)
	
    all_funcs = []
	
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file, ".jl")
              s = CSTParser.parse(read(joinpath(root, file), String), true)
              if !isnothing(s)
                all_funcs = vcat(
						all_funcs, get_expr(s, joinpath(root, file), verbose));
              end
            elseif endswith(file, ".ipynb")
				
                pj = [
					string(y["source"]...) for y in filter(
						(x)->(x["cell_type"] == "code") ,
						JSON.parse(join(readlines(joinpath(root, file))))["cells"]
						)
					]

                for code_cell in pj
                    s = CSTParser.parse(code_cell, true)
                    if !isnothing(s)
                        all_funcs = vcat(
                                all_funcs, get_expr(s, joinpath(root, file), verbose));
                    end
                end
            elseif endswith(file, ".md")
				
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

    filter!(x->x!="",all_funcs)
	unique(all_funcs)
end

function scrapeHeads(e)
	res = [e.head]
	for c in e
		res = vcat(res, scrapeHeads(c))
	end
	res
end

function find_paths(e, fun; path=[])
	res = []
	if fun(e)
		res = vcat(res, path)
	end
	
	for i in 1:length(e)
		curr_path = vcat(path, [i])
		#println(curr_path)
		children = find_paths(e[i], fun; path=curr_path)
		if isempty(children)
			#
		else
			#res = vcat(res, children)
			push!(res, children)
		end
	end
	
	res
end

function walk_path(e, path)
	tmp = e
	for index in path[1]
		tmp = tmp[index]
	end
	tmp
end

function findHeads(e, s)
	if e.head == s
		res = [e]
	else
		res = []
	end
	for c in e
		res = vcat(res, findHeads(c, s))
	end
	res
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

function get_code_csv(folder_path, target, maxlen=500, file_type="jl", verbose=true)
	writedlm(target, read_code(folder_path, maxlen, file_type, verbose), quotes=true)
end


#=
head     :: Union{CSTParser.EXPR, Symbol}
args     :: Union{Nothing, Array{CSTParser.EXPR,1}}
trivia   :: Union{Nothing, Array{CSTParser.EXPR,1}}
fullspan :: Int64
span     :: Int64
val      :: Union{Nothing, String}
parent   :: Union{Nothing, CSTParser.EXPR}
meta     :: Any
=#

#=head     :: Union{CSTParser.EXPR, Symbol}
args     :: Union{Nothing, Array{CSTParser.EXPR,1}}
trivia   :: Union{Nothing, Array{CSTParser.EXPR,1}}
fullspan :: Int64
span     :: Int64
val      :: Union{Nothing, String}
parent   :: Union{Nothing, CSTParser.EXPR}
meta     :: Any=#