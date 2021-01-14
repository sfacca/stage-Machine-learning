### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ d8cb3070-51fe-11eb-0456-b3d999c7d6ad
using Pkg

# ╔═╡ 38106140-51ff-11eb-2819-5da63b0ecc8e
using DelimitedFiles

# ╔═╡ 3dddd2b0-51ff-11eb-047a-f9755c66542a
include("./parse.jl")

# ╔═╡ 6aee35b2-5399-11eb-36f7-23bf1bba8f84
#include("./remove_comments.jl")

# ╔═╡ 54761ff0-51ff-11eb-0303-a19ad5d664ad
function get_expr(exp_tree, path, verbose=false)
    leaves = []

    for arg in exp_tree.args
        if verbose
            println(arg)
        end
        if typeof(arg) == Expr
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
        end
    end

    return leaves
end

# ╔═╡ 49fdeb22-51ff-11eb-238c-63e0904b21ae
function read_code(dir, maxlen=500, file_type="jl", verbose=false)
    comments = r"\#.*\n"
    docstring = r"\"{3}.*?\"{3}"s

    all_funcs = []
    sources = []

    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file, "."*file_type)
              s = Parsers.parsefile(joinpath(root, file))
              if !isa(s, Nothing)
                all_funcs = vcat(
						all_funcs, get_expr(s, joinpath(root, file), verbose));
              end
            end
        end
    end

    filter!(x->x!="",all_funcs)
    filter!(x -> length(x)<=maxlen, all_funcs)
	unique(all_funcs)
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
# ╠═49fdeb22-51ff-11eb-238c-63e0904b21ae
# ╠═54761ff0-51ff-11eb-0303-a19ad5d664ad
# ╠═edc9de70-567e-11eb-2cd0-b5d101d67d64
