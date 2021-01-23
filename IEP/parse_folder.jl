### A Pluto.jl notebook ###
# v0.12.18

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

# ╔═╡ 96034a02-5ceb-11eb-1a99-97021d350661
include("sample/sample.jl")

# ╔═╡ 6aee35b2-5399-11eb-36f7-23bf1bba8f84
#include("./remove_comments.jl")

# ╔═╡ f34f4c10-5cad-11eb-1378-2d503b89f19c
begin
asd = "123"
	fds = "456"
	joinpath(asd,fds)
	joinpath(asd,fds)
end

# ╔═╡ 06c74680-5cae-11eb-0768-a128e508dcdd
joinpath(asd,fds)

# ╔═╡ 27c95430-5caf-11eb-2f1a-97eaf3e58924
size(e::CSTParser.EXPR) = length(e)

# ╔═╡ b12e0790-5cb2-11eb-1350-b52b21d9a40f
[]#=head     :: Union{CSTParser.EXPR, Symbol}
args     :: Union{Nothing, Array{CSTParser.EXPR,1}}
trivia   :: Union{Nothing, Array{CSTParser.EXPR,1}}
fullspan :: Int64
span     :: Int64
val      :: Union{Nothing, String}
parent   :: Union{Nothing, CSTParser.EXPR}
meta     :: Any=#

# ╔═╡ ab178390-5cd0-11eb-2618-b30db5a5df9a
sample_parsed = CSTParser.parse(read("sample/sample.jl", String), true)

# ╔═╡ 42f8a400-5cd6-11eb-25a2-5fc88d1adc2c
CSTParser.parse(read("sample/sample.jl", String), false)

# ╔═╡ 478705c0-5cd6-11eb-247f-c10780e507e8
CSTParser.parse(read("sample/sample.jl", String), true).args

# ╔═╡ 6445ecb0-5cf1-11eb-2c39-b395f0deb10b
sample_parsed[3].head

# ╔═╡ b260bc8e-5cf1-11eb-3999-2ff9544f74e3
# :FUNCTION is literally the kw function

# ╔═╡ a65fcf70-5cf2-11eb-1bde-a3809a4fbf0a
sample_parsed[1][1].head

# ╔═╡ c5684c80-5cf2-11eb-1d0c-cd473d6ba519
sample_parsed[1][1].val

# ╔═╡ 78249830-5cf1-11eb-3147-71c038935129
sample_parsed[1].val

# ╔═╡ 6e14c220-5cf1-11eb-3ad0-67a399c409f3
sample_parsed.head

# ╔═╡ a948db10-5cf1-11eb-14e2-cdae739b83e9
sample_parsed.val

# ╔═╡ a0d9bcb0-5cf1-11eb-0d9e-5bfb2fa2a92e
CSTParser.EXPR

# ╔═╡ 6dd86eb0-5cec-11eb-3589-d12211904478
function scrapeHeads(e)
	res = [e.head]
	for c in e
		res = vcat(res, scrapeHeads(c))
	end
	res
end

# ╔═╡ 5356c000-5cf1-11eb-0194-d597635bdb2f
all_heads = scrapeHeads(sample_parsed)

# ╔═╡ 22c67860-5cf4-11eb-3368-4b26f6b42394
unique(all_heads)[1:10]

# ╔═╡ 2deaa4a0-5cf4-11eb-08fc-21ffd6df3da4
unique(all_heads)[10:20]

# ╔═╡ 33d4ece2-5cf4-11eb-0183-8fb83ca91a20
unique(all_heads)[20:end]

# ╔═╡ 96b1fc60-5cf2-11eb-3c6b-1113329e1af1
findfirst([x==:FUNCTION for x in all_heads])

# ╔═╡ 2fee03d0-5cf6-11eb-1d20-97b88d1bb859
function find_paths(e, fun; path=[])
	res = []
	if fun(e)
		res = vcat(res, path)
	end
	
	for i in 1:length(e)
		curr_path = vcat(path, [i])
		println(curr_path)
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

# ╔═╡ ae00a480-5cf6-11eb-3c1d-552cebc4d472
paths = find_paths(sample_parsed, (x)->(x.head == :globalrefdoc))

# ╔═╡ 93838680-5cf7-11eb-024c-0f6e38d3bb4e
function walk_path(e, path)
	tmp = e
	for index in path[1]
		tmp = tmp[index]
	end
	tmp
end

# ╔═╡ 8dd26f50-5cfa-11eb-1fd4-a5f0534e79b2
for x in paths[1]
	println(x)
end

# ╔═╡ cc9b4f20-5cf7-11eb-2775-d7a6de482885
sample_parsed[2][1]

# ╔═╡ e0878f30-5cf7-11eb-2ca2-f9bcf00033ad
typeof(paths[1])

# ╔═╡ 1046d8f2-5cfa-11eb-1b0d-19285df0d808
paths[1]

# ╔═╡ a6e16942-5cf7-11eb-2902-1953f761ce9a
walk_path(sample_parsed, paths[1])

# ╔═╡ 6849b2f0-5cf7-11eb-1ec6-3bd4e83830e6
typeof(paths)

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

# ╔═╡ 58757380-5cf4-11eb-2432-bb2c3e4d0bbf
findHeads(sample_parsed, :globalrefdoc)

# ╔═╡ 83411590-5cec-11eb-2476-91d612612ba6
function aux_func2()
	12
end

# ╔═╡ 7a4b3b00-5cec-11eb-07b8-71c00790221e
aux_func2

# ╔═╡ 219b9120-5ced-11eb-31fe-61fb7b63f3c7
x = 33

# ╔═╡ 3ce22430-5ced-11eb-23a3-614eb215366f
Main

# ╔═╡ 25b4c2e0-5ced-11eb-0f2c-5f953e007dea
getfield(Main, Symbol(sample_parsed.args[2][3][3][2][3][1][1].val))

# ╔═╡ 618bef10-5cec-11eb-0c69-357e0d6e3a5b
getfield(Main.workspace593, Symbol(sample_parsed.args[2][3][3][2][3][1][1].val))(
	getfield(Main, Symbol(sample_parsed.args[2][3][3][2][3][1][3].val)),
	getfield(Main, Symbol(sample_parsed.args[2][3][3][2][3][1][5].val)))

# ╔═╡ 10780dfe-5ced-11eb-1052-4b7f561fabbf
Symbol(sample_parsed.args[2][3][3][2][3][1][5].val)

# ╔═╡ 42f56322-5ceb-11eb-3118-a9c23a936c05
CSTParser.EXPR

# ╔═╡ 0b93b420-5cd9-11eb-0165-859860288b53
begin
	println("++++++++++++")
	show(sample_parsed.args[2])
end

# ╔═╡ c3a1edc0-5cd9-11eb-2a84-1dd701f78f30
CSTParser.parse("
	function foo(x::Int)
		x + 2 # comment
end
	", true)[2].trivia[1].head

# ╔═╡ 7f2c7250-5cd9-11eb-037e-2b42d475be20
println("+++++++++")

# ╔═╡ 43806a3e-5cd9-11eb-3b20-9f869d8ca8b3
sample_parsed.args[2].args

# ╔═╡ d7a13610-5cd8-11eb-0d1c-db1d7a2b7d55
Parsers.parsefile("sample/sample.jl").args

# ╔═╡ 04b59d60-5cd6-11eb-3b04-572f537ee634
CSTParse.parse

# ╔═╡ 2d210420-5cd5-11eb-1b4e-09b0acd9fbb8
meta_parsed = Meta.parse(read("sample/sample.jl", String), 1)

# ╔═╡ e4b097e0-5cd5-11eb-2724-e57263572159
Meta.show_sexpr(meta_parsed)

# ╔═╡ 84cda070-5cd5-11eb-1431-fdd8db362fa6
show(meta_parsed)

# ╔═╡ 0706d5d2-5cd5-11eb-1013-b548d9029698
show(parsers_parsed)

# ╔═╡ e0a9f0a0-5cbd-11eb-2c42-6113a8de5659
CSTParser.EXPR

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
function get_expr(exp_tree, path, verbose=true)
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


# ╔═╡ ed2d3580-5cae-11eb-2ae9-4fed2d60b88c
parseds = read_code("programs",500,"jl",true);

# ╔═╡ 8d336ba0-5cb7-11eb-0c9b-e1bcd273e832
typeof(parseds[1][1].args)

# ╔═╡ 9dad5dc0-5cb6-11eb-1433-c5e0b7c2d83e
expression = parseds[1][1]

# ╔═╡ aa088360-5cb6-11eb-105d-fd7c49704677
typeof(expression)

# ╔═╡ afd817b0-5cb6-11eb-1298-f7c2586d8912
expression[3]

# ╔═╡ b6d27060-5cb6-11eb-0e3b-1b2ae9b1c12d
expression.args[3]

# ╔═╡ d5678e00-5cbd-11eb-24bd-0d3dbb5507b0
exprs_only = [x[1] for x in parseds];

# ╔═╡ 943cd0c0-5cbd-11eb-3ebd-695aa30be455
[expr.trivia for x in exprs_only for expr in x]

# ╔═╡ f7047190-5cbd-11eb-08a9-2d64e7a1a032
unique([expr.meta for x in exprs_only for expr in x])

# ╔═╡ 03b494fe-5cbe-11eb-096c-8181ae9ce238
unique([expr.head for x in exprs_only for expr in x])

# ╔═╡ 17d26c5e-5cbe-11eb-28f9-77c082571437
unique([expr.fullspan for x in exprs_only for expr in x])

# ╔═╡ 328523e0-5cbe-11eb-25b7-b10cdddf1b2d
[expr.span - expr.fullspan for x in exprs_only for expr in x]

# ╔═╡ 396034c0-5cbe-11eb-3845-938ac775b68a
[expr.val for x in exprs_only for expr in x]

# ╔═╡ 56d20c3e-5cbe-11eb-0b2f-25d7ed64f6a1
unique([expr.meta for x in exprs_only for expr in x])

# ╔═╡ 73dd32ae-5cbe-11eb-326d-537e992999b0
findfirst([x == :function for x in [expr.head for x in exprs_only for expr in x]])

# ╔═╡ a6ad9ef0-5cbe-11eb-04bc-23c7fd6a35aa
JuliaFunction in unique([expr.head for x in exprs_only for expr in x])

# ╔═╡ b1ac68e0-5cbe-11eb-1680-6f66fe54c772
one_d_exprs = [expr for x in exprs_only for expr in x];

# ╔═╡ bf118270-5cd4-11eb-025d-6b0b5b235c6b
show(one_d_exprs[1])

# ╔═╡ befdd562-5cbe-11eb-35eb-8b90cb3241be
one_d_exprs[8][4][1].args[7]

# ╔═╡ ab186890-5cbd-11eb-1b6c-71541f649182
parseds[1]

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
# ╠═f34f4c10-5cad-11eb-1378-2d503b89f19c
# ╠═06c74680-5cae-11eb-0768-a128e508dcdd
# ╠═ed2d3580-5cae-11eb-2ae9-4fed2d60b88c
# ╠═27c95430-5caf-11eb-2f1a-97eaf3e58924
# ╠═8d336ba0-5cb7-11eb-0c9b-e1bcd273e832
# ╠═b12e0790-5cb2-11eb-1350-b52b21d9a40f
# ╠═9dad5dc0-5cb6-11eb-1433-c5e0b7c2d83e
# ╠═943cd0c0-5cbd-11eb-3ebd-695aa30be455
# ╠═ab178390-5cd0-11eb-2618-b30db5a5df9a
# ╠═42f8a400-5cd6-11eb-25a2-5fc88d1adc2c
# ╠═478705c0-5cd6-11eb-247f-c10780e507e8
# ╠═96034a02-5ceb-11eb-1a99-97021d350661
# ╠═5356c000-5cf1-11eb-0194-d597635bdb2f
# ╠═22c67860-5cf4-11eb-3368-4b26f6b42394
# ╠═2deaa4a0-5cf4-11eb-08fc-21ffd6df3da4
# ╠═33d4ece2-5cf4-11eb-0183-8fb83ca91a20
# ╠═6445ecb0-5cf1-11eb-2c39-b395f0deb10b
# ╠═b260bc8e-5cf1-11eb-3999-2ff9544f74e3
# ╠═96b1fc60-5cf2-11eb-3c6b-1113329e1af1
# ╠═a65fcf70-5cf2-11eb-1bde-a3809a4fbf0a
# ╠═c5684c80-5cf2-11eb-1d0c-cd473d6ba519
# ╠═78249830-5cf1-11eb-3147-71c038935129
# ╠═6e14c220-5cf1-11eb-3ad0-67a399c409f3
# ╠═a948db10-5cf1-11eb-14e2-cdae739b83e9
# ╠═a0d9bcb0-5cf1-11eb-0d9e-5bfb2fa2a92e
# ╠═6dd86eb0-5cec-11eb-3589-d12211904478
# ╠═58757380-5cf4-11eb-2432-bb2c3e4d0bbf
# ╠═2fee03d0-5cf6-11eb-1d20-97b88d1bb859
# ╠═ae00a480-5cf6-11eb-3c1d-552cebc4d472
# ╠═93838680-5cf7-11eb-024c-0f6e38d3bb4e
# ╠═8dd26f50-5cfa-11eb-1fd4-a5f0534e79b2
# ╠═cc9b4f20-5cf7-11eb-2775-d7a6de482885
# ╠═e0878f30-5cf7-11eb-2ca2-f9bcf00033ad
# ╠═1046d8f2-5cfa-11eb-1b0d-19285df0d808
# ╠═a6e16942-5cf7-11eb-2902-1953f761ce9a
# ╠═6849b2f0-5cf7-11eb-1ec6-3bd4e83830e6
# ╠═41e4a050-5cf4-11eb-3b67-37cdc44759ce
# ╠═7a4b3b00-5cec-11eb-07b8-71c00790221e
# ╠═83411590-5cec-11eb-2476-91d612612ba6
# ╠═219b9120-5ced-11eb-31fe-61fb7b63f3c7
# ╠═3ce22430-5ced-11eb-23a3-614eb215366f
# ╠═25b4c2e0-5ced-11eb-0f2c-5f953e007dea
# ╠═618bef10-5cec-11eb-0c69-357e0d6e3a5b
# ╠═10780dfe-5ced-11eb-1052-4b7f561fabbf
# ╠═42f56322-5ceb-11eb-3118-a9c23a936c05
# ╠═0b93b420-5cd9-11eb-0165-859860288b53
# ╠═c3a1edc0-5cd9-11eb-2a84-1dd701f78f30
# ╠═7f2c7250-5cd9-11eb-037e-2b42d475be20
# ╠═43806a3e-5cd9-11eb-3b20-9f869d8ca8b3
# ╠═d7a13610-5cd8-11eb-0d1c-db1d7a2b7d55
# ╠═f7047190-5cbd-11eb-08a9-2d64e7a1a032
# ╠═03b494fe-5cbe-11eb-096c-8181ae9ce238
# ╠═17d26c5e-5cbe-11eb-28f9-77c082571437
# ╠═328523e0-5cbe-11eb-25b7-b10cdddf1b2d
# ╠═396034c0-5cbe-11eb-3845-938ac775b68a
# ╠═56d20c3e-5cbe-11eb-0b2f-25d7ed64f6a1
# ╠═73dd32ae-5cbe-11eb-326d-537e992999b0
# ╠═a6ad9ef0-5cbe-11eb-04bc-23c7fd6a35aa
# ╠═b1ac68e0-5cbe-11eb-1680-6f66fe54c772
# ╠═04b59d60-5cd6-11eb-3b04-572f537ee634
# ╠═2d210420-5cd5-11eb-1b4e-09b0acd9fbb8
# ╠═e4b097e0-5cd5-11eb-2724-e57263572159
# ╠═84cda070-5cd5-11eb-1431-fdd8db362fa6
# ╠═0706d5d2-5cd5-11eb-1013-b548d9029698
# ╠═bf118270-5cd4-11eb-025d-6b0b5b235c6b
# ╠═befdd562-5cbe-11eb-35eb-8b90cb3241be
# ╠═d5678e00-5cbd-11eb-24bd-0d3dbb5507b0
# ╠═e0a9f0a0-5cbd-11eb-2c42-6113a8de5659
# ╠═11952220-5cbe-11eb-1d28-6784a010447d
# ╠═ab186890-5cbd-11eb-1b6c-71541f649182
# ╠═aa088360-5cb6-11eb-105d-fd7c49704677
# ╠═afd817b0-5cb6-11eb-1298-f7c2586d8912
# ╠═b6d27060-5cb6-11eb-0e3b-1b2ae9b1c12d
# ╠═54761ff0-51ff-11eb-0303-a19ad5d664ad
# ╠═edc9de70-567e-11eb-2cd0-b5d101d67d64
