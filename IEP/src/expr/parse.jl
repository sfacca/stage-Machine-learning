#using Pkg, DelimitedFiles, CSTParser

#include("./parse.jl")
"""
explores folder tree of dir, parses all .jl code found
* dir: base path
* maxlen = 500: files bigger than maxlen are ignored
* file_type = "jl": file extension in which to find code to parse
"""
function read_code(dir, maxlen=500, file_type="jl", verbose=false)
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
              s = CSTParser.parse(read(joinpath(root, file), String), true)
              if !isnothing(s)
                all_funcs = vcat(
						all_funcs, get_expr(s, joinpath(root, file), verbose));
              end
            end
        end
    end

    filter!(x->x!="",all_funcs)
    filter!(x -> length(x)<=maxlen, all_funcs)
	unique(all_funcs)
	#fils
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