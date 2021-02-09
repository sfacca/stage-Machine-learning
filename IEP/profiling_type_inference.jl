### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 2f82d750-6a1a-11eb-30e1-5b56252cee1e
LOAD_PATH

# ╔═╡ dab362e0-6ae0-11eb-2355-0be4b5a23cc2
using JLD2

# ╔═╡ 1a1b6180-6ae1-11eb-289b-bd530ec036c5
using Catlab

# ╔═╡ 0f7bce90-6ae1-11eb-0018-2d5509f3e8e3
using FileIO

# ╔═╡ e52d9d20-6a28-11eb-3cf6-a712ca13d24c
using CSTParser

# ╔═╡ 2f1431d0-6a2c-11eb-379d-73d04ba3ef9e
using Pkg

# ╔═╡ 37381660-6a2c-11eb-30b0-130e3fea8953
using MethodAnalysis

# ╔═╡ 7d83ff80-6a2c-11eb-28d7-d13eb6fe77e9
using AbstractTrees

# ╔═╡ d29a8cc0-6ade-11eb-2a9c-493b36ceb3e2
include("function_CSet.jl")

# ╔═╡ de84dd40-6ae0-11eb-0d4f-73b567275ba1
@load "src_cstparser.jld2"

# ╔═╡ 4a498490-6ae1-11eb-11c3-f57b45af7c4d
code_blocks = result[2][:impl_code];

# ╔═╡ 4c055e00-6ae4-11eb-2b05-f7416276422a
data = result[2];

# ╔═╡ 6760f780-6b17-11eb-3fb3-ed82b5cb2d08
Pkg.dir("Catlab")

# ╔═╡ 8c9bca80-6ae4-11eb-25d9-735413c9c83b
length(data[:impl_in])

# ╔═╡ a076cc80-6ae4-11eb-2ffa-ff72c9533015
data[8,:impl_in]

# ╔═╡ 694a5920-6ae4-11eb-1eab-9bcf2be44e0b
inputs = [data[data[i,:impl_in],:in_set] for i in 1:length(data[:impl_in])]

# ╔═╡ 352bae3e-6b21-11eb-1617-557b5aae57a8
Symbol("Tokens.Kind")# why no work?

# ╔═╡ 65b07240-6b20-11eb-04f1-1f7b3f5ba1be
function getName(nd)#overloading because jld2 is being dumb about types
	isnothing(nd.mod) ? nd.name : string(nd.mod,".",nd.name)
end

# ╔═╡ 4f6310ae-6b20-11eb-18b6-2f1dc526d2e1
function _in_to_sym(tup)#the tuple
	Symbol(getName(tup))
end

# ╔═╡ b41c64ce-6b1f-11eb-3dbd-21aac0e80cae
function inputdefs_to_symbols(arr)
	res = Array{Array{Symbol,1},1}(undef, length(arr))
	for i in 1:length(arr)#loops over arrays of inputdefs
		try
			res[i] = [_in_to_sym(input) for input in arr[i]]
		catch err
			println("############ error")
			println(err)
		end
	end
	res
end

# ╔═╡ bbe8be10-6b20-11eb-2bec-6997561b3926
unique(inputdefs_to_symbols(inputs))

# ╔═╡ e408ac70-6ae9-11eb-21a6-b50f5a5d10ec
function precomp(data)
	res = Array{Any,1}(undef, length(data[:,:impl_code]))
	for i in 1:length(1:length(data[:,:impl_code]))
		try
			res[i] = precomp(
					data[i,:impl_code],
					data[data[i,:impl_in],:in_set] 
			)
		catch error
			println("error at index: $i")
			println(error)
		end
	end
	res	
end

# ╔═╡ ebb75340-6ae4-11eb-1e13-5bafd52dbf50
inputs[1]

# ╔═╡ 51a93520-6ae9-11eb-3b1e-3759dd52d642
function make_types_tuple(arr)
	ntuple((i)->(eval(Symbol(getName(arr[i])))), length(arr))
end

# ╔═╡ c1d3e7f0-6ae4-11eb-136c-0d5013da0606
function precomp(e::CSTParser.EXPR, inputs)
	#need to translate input types (which are strings) into Types
	# eval(Symbol(datatype string)) returns datatype
	precompile(eval(Expr(e)), make_types_tuple(inputs))
end

# ╔═╡ 3fdb99e0-6aea-11eb-05ca-f909b9f8897a
precomp(data)

# ╔═╡ f65ead60-6aef-11eb-09c9-951c71125f33
for x in inputs
	try
		make_types_tuple(x)
	catch e
		println(e)
		println("source: $x")
	end
end

# ╔═╡ 72f7aac0-6b0e-11eb-2937-85f9ed2d5529
# need to get usings,import and includes from code and run them before running precompiles.
# include tree?

# ╔═╡ 761a4750-6ae9-11eb-1498-d3a1c35b9532
make_types_tuple(inputs[1])

# ╔═╡ 0b4e09c0-6ae9-11eb-242d-b11cb6e967cb
ntuple((i)->(inputs[1][i].name), length(inputs[1]))

# ╔═╡ 68ee6100-6ae5-11eb-3db7-11424f699182
asdf = [1,2,3]

# ╔═╡ 2de94750-6ae5-11eb-2571-2fedb10867ec
(x for x in asdf)

# ╔═╡ f374118e-6ae4-11eb-1f93-3b9301a0ba1f
ParseState == eval(:ParseState)

# ╔═╡ 09403530-6ae5-11eb-2e1c-315844bc20ac
Symbol("ParseState")

# ╔═╡ f68aee80-6ae4-11eb-0395-9dab3107456a
eval(:ParseState)

# ╔═╡ 7b793c52-6ae5-11eb-0d37-9ffc7cef5c1e


# ╔═╡ 05a09d10-6ae1-11eb-2ef5-5b65a9702b0d
"asd"

# ╔═╡ 3263f910-6a2c-11eb-06e4-07595f29a181
Pkg.activate(".")

# ╔═╡ b6dcefd0-6a2c-11eb-1e0e-d9d38050dd74
#Pkg.add("AbstractTrees")

# ╔═╡ ebaa8870-6a28-11eb-1a7c-556bd913ba47
sample_parse = CSTParser.parse("function foo(x::Int, y::Int)
	x + y
end")

# ╔═╡ 42f5c6b0-6a30-11eb-035e-afec9061ef83
dep_parse = CSTParser.parse(read("sample/function_dependancy.jl", String), true)

# ╔═╡ bb5e8380-6a30-11eb-3d96-2f5821f072d9
methodinstance(foo1, (Int))

# ╔═╡ eb477d9e-6ae8-11eb-0c51-255c36e7d5af
ntuple(, length())

# ╔═╡ 72b76c50-6a30-11eb-1a67-55b60e412eaa
function find_functions(e::CSTParser.EXPR)
	if e.head == :function
		res = [e]
	else
		res = []
	end
	if !isnothing(e.args) && !isempty(e.args)
		for expr in e.args
			res = vcat(res, find_functions(expr))
		end
	end
	res
end

# ╔═╡ ad991f80-6a30-11eb-2731-7b7b7cf3c37f
funcs = find_functions(dep_parse)

# ╔═╡ cead2400-6a30-11eb-3941-ffc8f673fe1c
eval(Expr(funcs[1]))

# ╔═╡ d39f0280-6a30-11eb-1d64-eff27ef736e5
eval(Expr(funcs[2]))

# ╔═╡ 076d505e-6a29-11eb-1085-99174cea2147
eval(Expr(sample_parse))(1,2)

# ╔═╡ 4c8e1b70-6a33-11eb-2779-ab28f800b0c4
precompile(foo2, (Int))

# ╔═╡ 1c7e07ae-6a33-11eb-22c0-a58c5c97c757
typeof(typeof(foo))

# ╔═╡ 31fe2e30-6a33-11eb-044a-9756009e9fbc
foo(12)

# ╔═╡ 894d4a80-6ade-11eb-23a1-133c85489594


# ╔═╡ 54dd3d70-6a2d-11eb-1803-cf4c42734f58
mi = methodinstance(foo, (Int, Int))

# ╔═╡ 8ffd9cc0-6a2c-11eb-2be5-5fbf9f8ec950
methodinstance(eval(Expr(sample_parse)), (Int, Int))

# ╔═╡ e384bb00-6a1b-11eb-101f-c1ddc3e9116a
precompile(eval(Expr(sample_parse)), (Int, Int))

# ╔═╡ 5d5538a0-6a31-11eb-2f31-452c51605781
precompile(eval(Expr(funcs[2])), (Int, Int))

# ╔═╡ 6aada9fe-6a31-11eb-1c8f-c58a4e836852
precompile(eval(Expr(funcs[1])), (Int, Int))

# ╔═╡ 3e3207a0-6a31-11eb-1117-ed199d05098a
double(x::Real) = 2x

# ╔═╡ 3fb52530-6a31-11eb-2cad-7d1e6361d271
calldouble(container) = double(container[1])

# ╔═╡ 3fb54c3e-6a31-11eb-3eee-4f3d73e08619
calldouble2(container) = calldouble(container)

# ╔═╡ a5d00712-6ade-11eb-0706-e36311047f07
precompile(calldouble, [Float64])

# ╔═╡ 9f7549c0-6ade-11eb-185b-952535d5ba84
precompile(calldouble2, (Float64,))

# ╔═╡ 8eaf7700-6ade-11eb-3ea4-a5354a628ac3
precompile(double, (Float64,))

# ╔═╡ 411180e0-6a31-11eb-1c74-216664752b5d
mo = methodinstance(double, (Float64,))

# ╔═╡ 26594850-6a77-11eb-2326-3f9f79a75ee7
for x in funcs
	if precompile(eval(Expr(x)), (Int, Int))
		println(x, "true")
	else
		println(x, "false")
	end
end

# ╔═╡ f8296070-6add-11eb-216f-9fbad436e69c
print_tree(mo)#prints to shell, not pluto nb

# ╔═╡ Cell order:
# ╠═2f82d750-6a1a-11eb-30e1-5b56252cee1e
# ╠═d29a8cc0-6ade-11eb-2a9c-493b36ceb3e2
# ╠═dab362e0-6ae0-11eb-2355-0be4b5a23cc2
# ╠═de84dd40-6ae0-11eb-0d4f-73b567275ba1
# ╠═4a498490-6ae1-11eb-11c3-f57b45af7c4d
# ╠═4c055e00-6ae4-11eb-2b05-f7416276422a
# ╠═6760f780-6b17-11eb-3fb3-ed82b5cb2d08
# ╠═8c9bca80-6ae4-11eb-25d9-735413c9c83b
# ╠═a076cc80-6ae4-11eb-2ffa-ff72c9533015
# ╠═694a5920-6ae4-11eb-1eab-9bcf2be44e0b
# ╠═bbe8be10-6b20-11eb-2bec-6997561b3926
# ╠═352bae3e-6b21-11eb-1617-557b5aae57a8
# ╠═b41c64ce-6b1f-11eb-3dbd-21aac0e80cae
# ╠═4f6310ae-6b20-11eb-18b6-2f1dc526d2e1
# ╠═65b07240-6b20-11eb-04f1-1f7b3f5ba1be
# ╠═c1d3e7f0-6ae4-11eb-136c-0d5013da0606
# ╠═f65ead60-6aef-11eb-09c9-951c71125f33
# ╠═3fdb99e0-6aea-11eb-05ca-f909b9f8897a
# ╠═e408ac70-6ae9-11eb-21a6-b50f5a5d10ec
# ╠═ebb75340-6ae4-11eb-1e13-5bafd52dbf50
# ╠═51a93520-6ae9-11eb-3b1e-3759dd52d642
# ╠═72f7aac0-6b0e-11eb-2937-85f9ed2d5529
# ╠═761a4750-6ae9-11eb-1498-d3a1c35b9532
# ╠═0b4e09c0-6ae9-11eb-242d-b11cb6e967cb
# ╠═68ee6100-6ae5-11eb-3db7-11424f699182
# ╠═2de94750-6ae5-11eb-2571-2fedb10867ec
# ╠═f374118e-6ae4-11eb-1f93-3b9301a0ba1f
# ╠═09403530-6ae5-11eb-2e1c-315844bc20ac
# ╠═f68aee80-6ae4-11eb-0395-9dab3107456a
# ╠═7b793c52-6ae5-11eb-0d37-9ffc7cef5c1e
# ╠═1a1b6180-6ae1-11eb-289b-bd530ec036c5
# ╠═0f7bce90-6ae1-11eb-0018-2d5509f3e8e3
# ╠═05a09d10-6ae1-11eb-2ef5-5b65a9702b0d
# ╠═e52d9d20-6a28-11eb-3cf6-a712ca13d24c
# ╠═2f1431d0-6a2c-11eb-379d-73d04ba3ef9e
# ╠═3263f910-6a2c-11eb-06e4-07595f29a181
# ╠═b6dcefd0-6a2c-11eb-1e0e-d9d38050dd74
# ╠═37381660-6a2c-11eb-30b0-130e3fea8953
# ╠═7d83ff80-6a2c-11eb-28d7-d13eb6fe77e9
# ╠═ebaa8870-6a28-11eb-1a7c-556bd913ba47
# ╠═42f5c6b0-6a30-11eb-035e-afec9061ef83
# ╠═ad991f80-6a30-11eb-2731-7b7b7cf3c37f
# ╠═cead2400-6a30-11eb-3941-ffc8f673fe1c
# ╠═d39f0280-6a30-11eb-1d64-eff27ef736e5
# ╠═bb5e8380-6a30-11eb-3d96-2f5821f072d9
# ╠═eb477d9e-6ae8-11eb-0c51-255c36e7d5af
# ╠═72b76c50-6a30-11eb-1a67-55b60e412eaa
# ╠═076d505e-6a29-11eb-1085-99174cea2147
# ╠═4c8e1b70-6a33-11eb-2779-ab28f800b0c4
# ╠═1c7e07ae-6a33-11eb-22c0-a58c5c97c757
# ╠═31fe2e30-6a33-11eb-044a-9756009e9fbc
# ╠═894d4a80-6ade-11eb-23a1-133c85489594
# ╠═54dd3d70-6a2d-11eb-1803-cf4c42734f58
# ╠═8ffd9cc0-6a2c-11eb-2be5-5fbf9f8ec950
# ╠═e384bb00-6a1b-11eb-101f-c1ddc3e9116a
# ╠═5d5538a0-6a31-11eb-2f31-452c51605781
# ╠═6aada9fe-6a31-11eb-1c8f-c58a4e836852
# ╠═3e3207a0-6a31-11eb-1117-ed199d05098a
# ╠═3fb52530-6a31-11eb-2cad-7d1e6361d271
# ╠═3fb54c3e-6a31-11eb-3eee-4f3d73e08619
# ╠═a5d00712-6ade-11eb-0706-e36311047f07
# ╠═9f7549c0-6ade-11eb-185b-952535d5ba84
# ╠═8eaf7700-6ade-11eb-3ea4-a5354a628ac3
# ╠═411180e0-6a31-11eb-1c74-216664752b5d
# ╠═26594850-6a77-11eb-2326-3f9f79a75ee7
# ╠═f8296070-6add-11eb-216f-9fbad436e69c
