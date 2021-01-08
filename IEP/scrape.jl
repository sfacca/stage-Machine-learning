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
                push!(leaves, (string(arg), path))
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
		println(files)
        for file in files
            if endswith(file, "."*file_type)
              s = Parsers.parsefile(joinpath(root, file))
              if !isa(s, Nothing)
                all_funcs = vcat(all_funcs, get_expr(s, joinpath(root, file), verbose));
              end
            end
        end
    end

    filter!(x->x!="",all_funcs)
    filter!(x -> length(x)<=maxlen, all_funcs)
    all_funcs = unique(all_funcs)

    return all_funcs
end

# ╔═╡ 138d89e0-5201-11eb-0b4a-81750b6faa07
md"this does not remove \"\"\" comments"

# ╔═╡ 605fe620-51ff-11eb-287f-4d4eafee8202
all_funcs = read_code("./sample", 500, "jl", true);

# ╔═╡ 7b5af140-51ff-11eb-2e84-a3f50881dff3
writedlm("all_funcs.csv", all_funcs, quotes=true);

# ╔═╡ 8145aeb0-51ff-11eb-2beb-81fc7346d99b
println(size(all_funcs))

# ╔═╡ 280165f2-5200-11eb-3566-4719a1a2fbce
println()

# ╔═╡ 28018d00-5200-11eb-343a-5f6fabe60cc1
println.(all_funcs[1]);

# ╔═╡ c47e47e0-5200-11eb-12a9-0fda88f80708
typeof(all_funcs[1])

# ╔═╡ cb0433e0-5200-11eb-16d6-9f0150339d84
all_funcs[1][1]

# ╔═╡ d138cb92-5200-11eb-16d1-a949fff800e5
all_funcs[1][]

# ╔═╡ 80fcc960-5200-11eb-2ae8-ed39a550ae7f
write("temp.txt",all_funcs[1][1])

# ╔═╡ dd74f780-5200-11eb-0960-cd3e473e54d9
Parsers.parsefile("./temp.txt")

# ╔═╡ Cell order:
# ╠═d8cb3070-51fe-11eb-0456-b3d999c7d6ad
# ╠═38106140-51ff-11eb-2819-5da63b0ecc8e
# ╠═3dddd2b0-51ff-11eb-047a-f9755c66542a
# ╠═49fdeb22-51ff-11eb-238c-63e0904b21ae
# ╠═54761ff0-51ff-11eb-0303-a19ad5d664ad
# ╟─138d89e0-5201-11eb-0b4a-81750b6faa07
# ╠═605fe620-51ff-11eb-287f-4d4eafee8202
# ╠═7b5af140-51ff-11eb-2e84-a3f50881dff3
# ╠═8145aeb0-51ff-11eb-2beb-81fc7346d99b
# ╠═280165f2-5200-11eb-3566-4719a1a2fbce
# ╠═28018d00-5200-11eb-343a-5f6fabe60cc1
# ╠═c47e47e0-5200-11eb-12a9-0fda88f80708
# ╠═cb0433e0-5200-11eb-16d6-9f0150339d84
# ╠═d138cb92-5200-11eb-16d1-a949fff800e5
# ╠═80fcc960-5200-11eb-2ae8-ed39a550ae7f
# ╠═dd74f780-5200-11eb-0960-cd3e473e54d9
