### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ f5031280-600e-11eb-3799-015a8792ae63
using Pkg

# ╔═╡ 689162b0-7121-11eb-2fb1-3b6edaf4d7a3
using CSTParser

# ╔═╡ 6a976fde-624f-11eb-0219-776399a2f5fc
using Match

# ╔═╡ 90e5cff0-6012-11eb-3182-ef1e1f802343
using Catlab, Catlab.CategoricalAlgebra, DataFrames

# ╔═╡ b9cf6ec0-600e-11eb-25d0-93643031c456
include("scrape.jl")

# ╔═╡ f0743ec0-6012-11eb-154a-e9a8eff08ce7
include("parse_folder.jl")

# ╔═╡ 96b03242-7228-11eb-24a3-d1ff8a46c7e7
include("functions_struct.jl")

# ╔═╡ f4d99180-600e-11eb-3053-2f2814838927
Pkg.activate(".")

# ╔═╡ 0390d870-6887-11eb-20b8-a5e1c5ea588e
#=
struct FunctionContainer
	func::FuncDef
	docs::Union{String,Nothing}
	source::Union{String,Nothing}	
end
struct NameDef
	name::String
	mod::Union{String, Nothing}
	NameDef(n::String, m::Union{String, Nothing}) = new(n,m)
	NameDef(n::String) = NameDef(n,nothing)
	NameDef(n::Nothing,m::Nothing) = new("name error", "NAMEDEF ERROR")
end
struct FuncDef
	name::NameDef
	inputs::Array{InputDef,1}
	block::CSTParser.EXPR
	output::Union{Nothing,NameDef}
	FuncDef(n::NameDef,i::Array{InputDef,1},b::CSTParser.EXPR,o::NameDef) = new(n,i,b,o)
	FuncDef(n::NameDef,i::Array{InputDef,1},b::CSTParser.EXPR) = new(n,i,b,nothing)
	FuncDef(error::String, block::CSTParser.EXPR) = new(
		NameDef(error,"FUNCDEF_ERROR"),
		Array{InputDef,1}(undef, 0),
		block,
		nothing
	)
end
struct InputDef
	name::NameDef
	type::NameDef	
end
=#

# ╔═╡ ad7005de-7242-11eb-248e-33498f3040d5
function _make_CSet(raw)
	println("##### scraping parse #####")
	function_definitions = scrape(raw)
	# every element of the function definitions array is a
	# FunctionContainer that defines an implementation
	# clearing raw
	raw = nothing
	N = length(function_definitions)
	# creating arrays
	
	# docs are in the functioncontainer
	println("scrape docs")
	docs = [isnothing(x.docs) ? "" : x.docs for x in function_definitions]#::Array{Union{String,Nothing},1}
	
	# code is in container.funcdef.block
	println("scrape code")
	code = [x.func.block for x in function_definitions]#::Array{CSTParser.EXPR,1}
	
	# leaves
	println("scrape leaves")
	ls = [get_leaves(x) for x in code]
	
	# name is in container.funcdef.name
	println("scrape names")
	names = [x.func.name for x  in function_definitions]#::Array{NameDef,1}
	
	# inputs are in container.funcdef.inputs
	println("scrape inputs")
	inputs = [
		x.func.inputs for x in function_definitions
			]#::Array{Array{InputDef,1},1}
	# we only want input types
	tmp = Array{Array{NameDef,1},1}(undef, N)
	for i in 1:N
		tmp[i] = [x.type for x in inputs[i]]
	end
	inputs = tmp
	uinputs = unique_arrays(inputs)
	#println(length(unique_arrays(inputs)))
	unique_inputs = [sort(getName(x)) for x in unique_arrays(inputs)]
	#println(length(unique_inputs))
	# sort inputs
	println("about to sort inputs...")
	inputs = [sort(x) for x in inputs]
	println("...sorted inputs")
	# sources are in container.source
	sources = [
		x.source for x in function_definitions
			]#::Array{Union{String,Nothing}},1
	
	# outputs is in container.func.output
	outputs = [
		x.func.output for x in function_definitions
			]#::Array{Union{Nothing,NameDef},1}
	
	
	
	# calls are to be obtained from block
	calls = [get_calls(x) for x in code]
	name_ucalls = [sort(getName(x)) for x in unique_arrays(calls)]
	# ordered set of called functions NB: probably need NameDef
	println("...defining schema...")
	
	@present implementationsSchema(FreeSchema) begin
		(Function, Implementation, Inputs, Calls)::Ob
		(code, setInp, setExpr, setCalls, docs, name, source)::Data
		
		impl_in::Hom(Implementation, Inputs)# ogni implem ha degli input	
		impl_fun::Hom(Implementation, Function)# ogni impl implementa una funzione
		impl_expr::Attr(Implementation, setExpr)#ogni impl è composta da expr
		impl_calls::Hom(Implementation, Calls)

		# link objects to their actual data
		impl_code::Attr(Implementation, code)
		in_set::Attr(Inputs, setInp)
		calls_set::Attr(Calls, setCalls)

		# more attributes
		func_name::Attr(Function, name)
		impl_docs::Attr(Implementation, docs)
	end
	
	println("... declaring schema, data ...")
	parsed_data = ACSetType(implementationsSchema, index=[:impl_fun])
	data = parsed_data{
		CSTParser.EXPR,#code, 
		Array{NameDef,1},#setInp, 
		Array{CSTParser.EXPR,1},# setExpr, 
		Array{NameDef,1},# setCalls, 
		String,# docs, 
		NameDef,# name, 
		Union{String,Nothing}# source
	}()
	
	fun_names = unique(names)
	# (Function, Implementation, Inputs, Calls)::Ob
	# (code, setInp, setExpr, setCalls, docs, name, source)::Data
	println("#### initializing ####")
	impls = add_parts!(data, :Implementation, N)
	fs = add_parts!(data, :Function, length(unique(names)))
	inps = add_parts!(data, :Inputs, length(unique_inputs))
	clls = add_parts!(data, :Calls, length(name_ucalls))
	#clls = add_parts!(data, :Calls, length(unique(calls)))
	
	println("#### setting up attrs and homs")
	
	uniqued_calls = unique_arrays(calls)
		
	println("impl homs")
	# impl homs
	for i in 1:N
		
		#println("impl fun")
		data[i, :impl_fun] = findfirst((x)->(x == names[i]), unique(names))
		#println("impl calls")
		data[i, :impl_calls] = findfirst(
			(x)->(x == sort(getName(calls[i]))), 
			name_ucalls
		)
		#println("impl in")
		indx = findfirst(
				(x)->(x == sort(getName(inputs[i]))),
				unique_inputs
			)
		if isnothing(indx)
			#println("asd")
			indx = 0
		end
		#println(indx)
		data[i, :impl_in] = indx
		#println("xxx")
	end
	
	println("impl attr")
	# impl attr
	data[:, :impl_expr] = ls#leaves (leaf expressions)
	data[:, :impl_code] = code#blocks
	data[:, :impl_docs] = docs
	
	println("in attr")
	data[:, :in_set] = uinputs
	
	#data[:, :calls_set] = unique(calls)
	data[:, :calls_set] = unique_arrays(calls)
	
	println("func attr")
	data[:, :func_name] = unique(names)
	#=
	PRECOMP/TYPE INFERENCE GOES HERE
	1. send :data to function
	2. receive array of outputs of Implementations length
	3. sets them on output
	=#
	println("finished")
	return parsed_data, data
end

# ╔═╡ e78580b0-6884-11eb-09c1-718b29dfebb1
function folder_to_CSet(path::String)
	println("##### parsing folder #####")
	raw = read_code(path)
	_make_CSet(raw)
end

# ╔═╡ d75e94c0-7242-11eb-1fbf-713b09915b74
function folder_to_CSet(paths::Array{String,1})
	println("##### parsing folders #####")
	
	raw = []
	for path in paths
		try
			raw = vcat(raw, read_code(path))
		catch err
			println(err)
		end
	end
	_make_CSet(raw)
end

# ╔═╡ 32713c30-7092-11eb-1b95-a3209b3335fa
#=function _handle_calls_set(
		carr::Array{Array{NameDef,1},1}, 
		narr::Array{Array{String,1},1})::Array{Array{NameDef,1},1}
	uniques = [sort(unique(x))for x in carr]
	=#

# ╔═╡ ad93b020-68a2-11eb-1d99-d753edd2fd86
#=
BenchmarkTools.Trial: 
  memory estimate:  26.59 MiB
  allocs estimate:  401717
  --------------
  minimum time:     44.136 ms (0.00% GC)
  median time:      63.022 ms (24.47% GC)
  mean time:        57.994 ms (19.92% GC)
  maximum time:     71.029 ms (31.91% GC)
  --------------
  samples:          87
  evals/sample:     1
=#

# ╔═╡ 357dc2d0-64b3-11eb-374f-351a90dc6d17
#=
BenchmarkTools.Trial: 
  memory estimate:  14.07 MiB
  allocs estimate:  302169
  --------------
  minimum time:     381.777 ms (0.00% GC)
  median time:      749.045 ms (0.00% GC)
  mean time:        702.608 ms (0.25% GC)
  maximum time:     767.965 ms (1.86% GC)
  --------------
  samples:          8
  evals/sample:     1
----------------------------------
BenchmarkTools.Trial: 
  memory estimate:  14.07 MiB
  allocs estimate:  302076
  --------------
  minimum time:     344.479 ms (0.00% GC)
  median time:      728.441 ms (0.00% GC)
  mean time:        661.352 ms (0.26% GC)
  maximum time:     742.936 ms (1.88% GC)
  --------------
  samples:          8
  evals/sample:     1
-------------------------- map
BenchmarkTools.Trial: 
  memory estimate:  17.42 MiB
  allocs estimate:  442728
  --------------
  minimum time:     407.505 ms (0.00% GC)
  median time:      688.001 ms (0.00% GC)
  mean time:        671.876 ms (0.53% GC)
  maximum time:     783.490 ms (1.83% GC)
  --------------
  samples:          8
  evals/sample:     1
____________________________________
BenchmarkTools.Trial: 
  memory estimate:  17.50 MiB
  allocs estimate:  443243
  --------------
  minimum time:     399.763 ms (0.00% GC)
  median time:      716.824 ms (0.00% GC)
  mean time:        685.075 ms (0.54% GC)
  maximum time:     755.387 ms (1.99% GC)
  --------------
  samples:          8
  evals/sample:     1
BenchmarkTools.Trial: 
  memory estimate:  17.51 MiB
  allocs estimate:  443272
  --------------
  minimum time:     441.639 ms (0.00% GC)
  median time:      715.373 ms (0.00% GC)
  mean time:        703.896 ms (0.49% GC)
  maximum time:     836.887 ms (0.00% GC)
  --------------
  samples:          8
  evals/sample:     1
_________________________________
BenchmarkTools.Trial: 
  memory estimate:  17.57 MiB
  allocs estimate:  443679
  --------------
  minimum time:     449.643 ms (0.00% GC)
  median time:      781.946 ms (0.00% GC)
  mean time:        715.165 ms (0.30% GC)
  maximum time:     844.381 ms (0.00% GC)
  --------------
  samples:          7
  evals/sample:     1
________________________________
BenchmarkTools.Trial:   
  	memory estimate:  17.60 MiB  
  	allocs estimate:  444566  
  	--------------  
	minimum time:     402.855 ms (0.00% GC)  
	median time:      818.166 ms (0.00% GC)  
	mean time:        752.844 ms (0.26% GC)  
	maximum time:     891.966 ms (0.00% GC)  
	--------------
	samples:          7
	evals/sample:     1
=#

# ╔═╡ 669206b0-626f-11eb-3d06-8f6951f50af8
function _get_types_from_inputs(arr::Array{Array{T,1} where T,1})
	println("start")
	res = Array{Array{Any,1},1}(undef, length(arr))
	println("pre loop")
	for i in 1:length(arr)
		println("loop num $i")
		res[i] = Array{Any,1}(undef, length(arr[i]))
		println("pre inner")
		for j in 1:length(arr[i])
			println("inner $j")
			try
				@match typeof(arr[i][j]) begin
					String => (res[i][j] = arr[i][j])
					CSTParser.EXPR => (res[i][j] = "Any")
					_ => (res[i][j] = arr[i][j].type)
				end
				if isnothing(res[i][j])
					res[i][j] = "Any"
				end	
			catch e
				println(e)
				res[i][j] = String(arr[i][j])
			end
		end
		res[i] = sort(res[i])
	end
	res
end

# ╔═╡ Cell order:
# ╠═f5031280-600e-11eb-3799-015a8792ae63
# ╠═f4d99180-600e-11eb-3053-2f2814838927
# ╠═b9cf6ec0-600e-11eb-25d0-93643031c456
# ╠═f0743ec0-6012-11eb-154a-e9a8eff08ce7
# ╠═96b03242-7228-11eb-24a3-d1ff8a46c7e7
# ╠═689162b0-7121-11eb-2fb1-3b6edaf4d7a3
# ╠═6a976fde-624f-11eb-0219-776399a2f5fc
# ╠═90e5cff0-6012-11eb-3182-ef1e1f802343
# ╠═0390d870-6887-11eb-20b8-a5e1c5ea588e
# ╠═ad7005de-7242-11eb-248e-33498f3040d5
# ╠═e78580b0-6884-11eb-09c1-718b29dfebb1
# ╠═d75e94c0-7242-11eb-1fbf-713b09915b74
# ╠═32713c30-7092-11eb-1b95-a3209b3335fa
# ╠═ad93b020-68a2-11eb-1d99-d753edd2fd86
# ╠═357dc2d0-64b3-11eb-374f-351a90dc6d17
# ╠═669206b0-626f-11eb-3d06-8f6951f50af8
