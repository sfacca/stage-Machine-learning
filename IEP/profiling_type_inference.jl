### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 2f82d750-6a1a-11eb-30e1-5b56252cee1e
LOAD_PATH

# ╔═╡ c155a820-6d11-11eb-2624-ed33605757e3
using Tokenize

# ╔═╡ baf9c5b0-6c8a-11eb-2eff-8da7e6f1d656
using Reexport

# ╔═╡ bdb78620-6c8a-11eb-30d6-71194a88cc22
@reexport using Catlab

# ╔═╡ dab362e0-6ae0-11eb-2355-0be4b5a23cc2
using JLD2

# ╔═╡ 1df694a0-6bf9-11eb-1aaf-35125f78ac1f
using Catlab.Theories

# ╔═╡ f041fd10-6bf8-11eb-3d79-fb30ad4289d2
using Catlab.Graphics

# ╔═╡ 4f52b060-6bf9-11eb-3913-1f53c1c2bac0
using Catlab.WiringDiagrams

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
include("module_to_CSet.jl")

# ╔═╡ aaa74f00-6c5a-11eb-2e72-1579c0402732
include("eval_module.jl")

# ╔═╡ 7c27bbd0-6b95-11eb-02a6-61a9f32491ac
result = module_to_CSet("Catlab");

# ╔═╡ d3c52060-6c5a-11eb-357c-df1fc8ae29b4
res = eval_module("Catlab");

# ╔═╡ f6344810-6c5a-11eb-1d76-070d52efaa2d
count(res[2])

# ╔═╡ 1d699630-6d12-11eb-2a87-df9409875349
length(res[2])

# ╔═╡ 9a881200-6b95-11eb-1db0-d71e5bcde54a
data = result[2];

# ╔═╡ a6e1d810-6b95-11eb-3b92-1b13a6667eb2
inputs_array = data[:,:in_set];

# ╔═╡ e2772dc0-6beb-11eb-08af-abf97b5400e1
func_names = [data[i,:func_name] for i in data[:,:impl_fun]]

# ╔═╡ 34610700-6bec-11eb-2f66-b3476fce12b4
func_names[1].name.val

# ╔═╡ a6427840-6bec-11eb-294f-0924474d277c
getindex

# ╔═╡ 467a03c0-6b96-11eb-19f0-d108af4c0cf2
function foo(x::CSTParser.EXPR)
	x
end

# ╔═╡ a857e0be-6c5a-11eb-10d0-41573fe5212c


# ╔═╡ 83b980ce-6c09-11eb-08b3-29f713f52b43
Catlab.ACSetView

# ╔═╡ bfdf2150-6beb-11eb-178e-01ba13b56040
CSTParser.EXPR

# ╔═╡ 0082e860-6bf9-11eb-1227-f157310c62a3
import Catlab.Graphics: Graphviz

# ╔═╡ d4892030-6bf8-11eb-3d3e-e1ccef5bb3ef
to_wiring_diagram

# ╔═╡ c819b040-6bed-11eb-38dc-c3e28460fde6
funcnames = [data[x,:func_name].name for x in data[:,:impl_fun]]

# ╔═╡ 5180b4f0-6bee-11eb-0324-efb806c71965
code = data[:,:impl_code];

# ╔═╡ 68aa6cc2-6bee-11eb-39ca-d74f80365ba7
eval(Expr(code[1]))

# ╔═╡ efe22ad0-6bed-11eb-11bc-29daa82ee824
eval(Expr(funcnames[1]))

# ╔═╡ 058c6e90-6bee-11eb-3684-15bc3f202490
for x in data[:,:impl_fun]
	try
		eval(Expr(data[x,:func_name].name))
	catch e
		println(e)
	end
end

# ╔═╡ 06b62a60-6d13-11eb-3cb3-57015e8512a0
dump(CSTParser.parse("x = 1"))

# ╔═╡ e562dd80-6d13-11eb-312c-59750b66e2bc
CSTParser.parse("x = 1").val

# ╔═╡ b9b44640-6bee-11eb-343e-abaab85a0ba3
eval(Symbol("to_wiring_diagram"))

# ╔═╡ 07f85af0-6bed-11eb-3b6e-d99efa2b10ef
function precomp_w_input(data)
	res = Array{Bool,1}(undef, length(data[:,:impl_in]))
	#1 let's try running the code first
	for i in 1:length(res)
		try
			eval(Expr(data[i,:impl_code]))
		catch e
			println("error running code at index :$(i)")
			println(e)
		end
	end
	
	
	for i in 1:length(res)
		try
			res[i] = precomp_w_input(data, i)
		catch e
			println("error at index :$i")
			println(e)
			res[i] = false
		end
	end
	res
end

# ╔═╡ ba2409f0-6bec-11eb-3d30-45a2b8e920a1
function make_inputs_tuple(inputs::Array{NameDef,1})
	ntuple((x)->(eval(Expr(inputs[x].name))),length(inputs))
end

# ╔═╡ caa113e2-6bec-11eb-3d0c-6bf9d4b0b459
make_inputs_tuple(data[data[2,:impl_in],:in_set])

# ╔═╡ abbd5250-6beb-11eb-056b-d5af61d5f030
function precomp_w_input(data, n::Int)
	precompile(
		eval(Expr(data[data[n,:impl_fun],:func_name].name)),
		make_inputs_tuple(data[data[n,:impl_in],:in_set])
	)
end

# ╔═╡ 440c4c92-6bed-11eb-1602-b7f6ddb84e05
count(precomp_w_input(data))

# ╔═╡ 228366c2-6c5c-11eb-1383-e5305a6c2474
length(precomp_w_input(data))

# ╔═╡ 3bc24cf0-6bee-11eb-2394-8544659bc346
count(precomp_w_input(data))# yay!

# ╔═╡ 352bae3e-6b21-11eb-1617-557b5aae57a8
Symbol("Tokens.Kind")# why no work?

# ╔═╡ fcc895be-6bc7-11eb-0335-41fd59d3cfa5


# ╔═╡ 6f9d5d1e-6bc7-11eb-0a79-49f3be393eb8
dfds = eval(Symbol("CSTParser")).eval(Symbol("EXPR"))

# ╔═╡ f8560b50-6bc5-11eb-3302-2bbd891f5c5b
eval(Symbol("CSTParser")).eval(Symbol("EXPR"))

# ╔═╡ 7b8dbc62-6bae-11eb-3133-df244357a54b
function _string_dot_symbols(arr::Array{String,1})
	if length(arr)>1
		return (eval(Symbol(arr[1]))).(_string_dot_symbols(arr[2:end]))
	else
		return (eval(Symbol(arr[1])))
	end	
end

# ╔═╡ 65b07240-6b20-11eb-04f1-1f7b3f5ba1be
function getName(nd)#overloading because jld2 is being dumb about types
	isnothing(nd.mod) ? nd.name : string(nd.mod,".",nd.name)
end

# ╔═╡ 46107670-6bec-11eb-1500-01ed4a7ab0a8
[getName(x) for x in func_names]

# ╔═╡ 4f6310ae-6b20-11eb-18b6-2f1dc526d2e1
function _in_to_sym(tup)#the tuple
	split
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

# ╔═╡ 72f7aac0-6b0e-11eb-2937-85f9ed2d5529
# need to get usings,import and includes from code and run them before running precompiles.
# include tree?

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

# ╔═╡ 1c7e07ae-6a33-11eb-22c0-a58c5c97c757
typeof(typeof(foo))

# ╔═╡ 894d4a80-6ade-11eb-23a1-133c85489594


# ╔═╡ 54dd3d70-6a2d-11eb-1803-cf4c42734f58
mi = methodinstance(foo, (Int, Int))

# ╔═╡ 3e3207a0-6a31-11eb-1117-ed199d05098a
double(x::Real) = 2x

# ╔═╡ 3fb52530-6a31-11eb-2cad-7d1e6361d271
calldouble(container) = double(container[1])

# ╔═╡ 3fb54c3e-6a31-11eb-3eee-4f3d73e08619
calldouble2(container) = calldouble(container)

# ╔═╡ 9f7549c0-6ade-11eb-185b-952535d5ba84
precompile(calldouble2, (Float64,))

# ╔═╡ 8eaf7700-6ade-11eb-3ea4-a5354a628ac3
precompile(double, (Float64,))

# ╔═╡ 411180e0-6a31-11eb-1c74-216664752b5d
mo = methodinstance(double, (Float64,))

# ╔═╡ f8296070-6add-11eb-216f-9fbad436e69c
print_tree(mo)#prints to shell, not pluto nb

# ╔═╡ Cell order:
# ╠═2f82d750-6a1a-11eb-30e1-5b56252cee1e
# ╠═d29a8cc0-6ade-11eb-2a9c-493b36ceb3e2
# ╠═aaa74f00-6c5a-11eb-2e72-1579c0402732
# ╠═7c27bbd0-6b95-11eb-02a6-61a9f32491ac
# ╠═c155a820-6d11-11eb-2624-ed33605757e3
# ╠═baf9c5b0-6c8a-11eb-2eff-8da7e6f1d656
# ╠═bdb78620-6c8a-11eb-30d6-71194a88cc22
# ╠═d3c52060-6c5a-11eb-357c-df1fc8ae29b4
# ╠═f6344810-6c5a-11eb-1d76-070d52efaa2d
# ╠═1d699630-6d12-11eb-2a87-df9409875349
# ╠═dab362e0-6ae0-11eb-2355-0be4b5a23cc2
# ╠═9a881200-6b95-11eb-1db0-d71e5bcde54a
# ╠═a6e1d810-6b95-11eb-3b92-1b13a6667eb2
# ╠═e2772dc0-6beb-11eb-08af-abf97b5400e1
# ╠═34610700-6bec-11eb-2f66-b3476fce12b4
# ╠═46107670-6bec-11eb-1500-01ed4a7ab0a8
# ╠═a6427840-6bec-11eb-294f-0924474d277c
# ╠═467a03c0-6b96-11eb-19f0-d108af4c0cf2
# ╠═a857e0be-6c5a-11eb-10d0-41573fe5212c
# ╠═83b980ce-6c09-11eb-08b3-29f713f52b43
# ╠═caa113e2-6bec-11eb-3d0c-6bf9d4b0b459
# ╠═bfdf2150-6beb-11eb-178e-01ba13b56040
# ╠═1df694a0-6bf9-11eb-1aaf-35125f78ac1f
# ╠═440c4c92-6bed-11eb-1602-b7f6ddb84e05
# ╠═f041fd10-6bf8-11eb-3d79-fb30ad4289d2
# ╠═0082e860-6bf9-11eb-1227-f157310c62a3
# ╠═d4892030-6bf8-11eb-3d3e-e1ccef5bb3ef
# ╠═4f52b060-6bf9-11eb-3913-1f53c1c2bac0
# ╠═c819b040-6bed-11eb-38dc-c3e28460fde6
# ╠═5180b4f0-6bee-11eb-0324-efb806c71965
# ╠═68aa6cc2-6bee-11eb-39ca-d74f80365ba7
# ╠═efe22ad0-6bed-11eb-11bc-29daa82ee824
# ╠═058c6e90-6bee-11eb-3684-15bc3f202490
# ╠═06b62a60-6d13-11eb-3cb3-57015e8512a0
# ╠═e562dd80-6d13-11eb-312c-59750b66e2bc
# ╠═228366c2-6c5c-11eb-1383-e5305a6c2474
# ╠═3bc24cf0-6bee-11eb-2394-8544659bc346
# ╠═b9b44640-6bee-11eb-343e-abaab85a0ba3
# ╠═abbd5250-6beb-11eb-056b-d5af61d5f030
# ╠═07f85af0-6bed-11eb-3b6e-d99efa2b10ef
# ╠═ba2409f0-6bec-11eb-3d30-45a2b8e920a1
# ╠═352bae3e-6b21-11eb-1617-557b5aae57a8
# ╠═b41c64ce-6b1f-11eb-3dbd-21aac0e80cae
# ╠═fcc895be-6bc7-11eb-0335-41fd59d3cfa5
# ╠═6f9d5d1e-6bc7-11eb-0a79-49f3be393eb8
# ╠═f8560b50-6bc5-11eb-3302-2bbd891f5c5b
# ╠═7b8dbc62-6bae-11eb-3133-df244357a54b
# ╠═4f6310ae-6b20-11eb-18b6-2f1dc526d2e1
# ╠═65b07240-6b20-11eb-04f1-1f7b3f5ba1be
# ╠═c1d3e7f0-6ae4-11eb-136c-0d5013da0606
# ╠═3fdb99e0-6aea-11eb-05ca-f909b9f8897a
# ╠═e408ac70-6ae9-11eb-21a6-b50f5a5d10ec
# ╠═51a93520-6ae9-11eb-3b1e-3759dd52d642
# ╠═72f7aac0-6b0e-11eb-2937-85f9ed2d5529
# ╠═68ee6100-6ae5-11eb-3db7-11424f699182
# ╠═2de94750-6ae5-11eb-2571-2fedb10867ec
# ╠═f374118e-6ae4-11eb-1f93-3b9301a0ba1f
# ╠═09403530-6ae5-11eb-2e1c-315844bc20ac
# ╠═f68aee80-6ae4-11eb-0395-9dab3107456a
# ╠═7b793c52-6ae5-11eb-0d37-9ffc7cef5c1e
# ╠═0f7bce90-6ae1-11eb-0018-2d5509f3e8e3
# ╠═05a09d10-6ae1-11eb-2ef5-5b65a9702b0d
# ╠═e52d9d20-6a28-11eb-3cf6-a712ca13d24c
# ╠═2f1431d0-6a2c-11eb-379d-73d04ba3ef9e
# ╠═3263f910-6a2c-11eb-06e4-07595f29a181
# ╠═b6dcefd0-6a2c-11eb-1e0e-d9d38050dd74
# ╠═37381660-6a2c-11eb-30b0-130e3fea8953
# ╠═7d83ff80-6a2c-11eb-28d7-d13eb6fe77e9
# ╠═72b76c50-6a30-11eb-1a67-55b60e412eaa
# ╠═1c7e07ae-6a33-11eb-22c0-a58c5c97c757
# ╠═894d4a80-6ade-11eb-23a1-133c85489594
# ╠═54dd3d70-6a2d-11eb-1803-cf4c42734f58
# ╠═3e3207a0-6a31-11eb-1117-ed199d05098a
# ╠═3fb52530-6a31-11eb-2cad-7d1e6361d271
# ╠═3fb54c3e-6a31-11eb-3eee-4f3d73e08619
# ╠═9f7549c0-6ade-11eb-185b-952535d5ba84
# ╠═8eaf7700-6ade-11eb-3ea4-a5354a628ac3
# ╠═411180e0-6a31-11eb-1c74-216664752b5d
# ╠═f8296070-6add-11eb-216f-9fbad436e69c
