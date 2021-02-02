### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ d8cb3070-51fe-11eb-0456-b3d999c7d6ad
using Pkg

# ╔═╡ 38106140-51ff-11eb-2819-5da63b0ecc8e
using DelimitedFiles

# ╔═╡ 1c8cf3c0-5ca9-11eb-3b40-59e3797fe531
using CSTParser

# ╔═╡ 3dddd2b0-51ff-11eb-047a-f9755c66542a
include("./parse.jl")

# ╔═╡ 6aee35b2-5399-11eb-36f7-23bf1bba8f84
#include("./remove_comments.jl")

# ╔═╡ b12e0790-5cb2-11eb-1350-b52b21d9a40f
[]#=head     :: Union{CSTParser.EXPR, Symbol}
args     :: Union{Nothing, Array{CSTParser.EXPR,1}}
trivia   :: Union{Nothing, Array{CSTParser.EXPR,1}}
fullspan :: Int64
span     :: Int64
val      :: Union{Nothing, String}
parent   :: Union{Nothing, CSTParser.EXPR}
meta     :: Any=#

# ╔═╡ 6dd86eb0-5cec-11eb-3589-d12211904478
function scrapeHeads(e)
	res = [e.head]
	for c in e
		res = vcat(res, scrapeHeads(c))
	end
	res
end

# ╔═╡ 2fee03d0-5cf6-11eb-1d20-97b88d1bb859
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

# ╔═╡ 93838680-5cf7-11eb-024c-0f6e38d3bb4e
function walk_path(e, path)
	tmp = e
	for index in path[1]
		tmp = tmp[index]
	end
	tmp
end

# ╔═╡ 41e4a050-5cf4-11eb-3b67-37cdc44759ce
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

# ╔═╡ 11952220-5cbe-11eb-1d28-6784a010447d
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

# ╔═╡ 54761ff0-51ff-11eb-0303-a19ad5d664ad
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

# ╔═╡ 49fdeb22-51ff-11eb-238c-63e0904b21ae
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


# ╔═╡ edc9de70-567e-11eb-2cd0-b5d101d67d64
function get_code_csv(folder_path, target, maxlen=500, file_type="jl", verbose=true)
	writedlm(target, read_code(folder_path, maxlen, file_type, verbose), quotes=true)
end

# ╔═╡ Cell order:
# ╠═d8cb3070-51fe-11eb-0456-b3d999c7d6ad
# ╠═38106140-51ff-11eb-2819-5da63b0ecc8e
# ╠═3dddd2b0-51ff-11eb-047a-f9755c66542a
# ╠═6aee35b2-5399-11eb-36f7-23bf1bba8f84
# ╠═1c8cf3c0-5ca9-11eb-3b40-59e3797fe531
# ╠═49fdeb22-51ff-11eb-238c-63e0904b21ae
# ╠═b12e0790-5cb2-11eb-1350-b52b21d9a40f
# ╠═6dd86eb0-5cec-11eb-3589-d12211904478
# ╠═2fee03d0-5cf6-11eb-1d20-97b88d1bb859
# ╠═93838680-5cf7-11eb-024c-0f6e38d3bb4e
# ╠═41e4a050-5cf4-11eb-3b67-37cdc44759ce
# ╠═11952220-5cbe-11eb-1d28-6784a010447d
# ╠═54761ff0-51ff-11eb-0303-a19ad5d664ad
# ╠═edc9de70-567e-11eb-2cd0-b5d101d67d64
