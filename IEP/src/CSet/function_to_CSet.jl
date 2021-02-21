
#using Pkg, CSTParser, Match, Catlab, Catlab.CategoricalAlgebra, DataFrames 

#include("scrape.jl")
#include("parse_folder.jl")
#include("functions_struct.jl")

function folder_to_CSet(path::String)
	println("##### parsing folder #####")
	raw = read_code(path)
	_make_CSet(raw)
end

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
	unames = unique([getName(x) for x in names])
	
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
		String,# name, 
		Union{String,Nothing}# source
	}()
	
	fun_names = unique(names)
	# (Function, Implementation, Inputs, Calls)::Ob
	# (code, setInp, setExpr, setCalls, docs, name, source)::Data# names
	println("#### initializing ####")
	impls = add_parts!(data, :Implementation, N)
	fs = add_parts!(data, :Function, length(unames))
	inps = add_parts!(data, :Inputs, length(unique_inputs))
	clls = add_parts!(data, :Calls, length(name_ucalls))
	#clls = add_parts!(data, :Calls, length(unique(calls)))
	
	println("#### setting up attrs and homs")
	
	uniqued_calls = unique_arrays(calls)
		
	println("impl homs")
	# impl homs
	for i in 1:N
		
		#println("impl fun")
		data[i, :impl_fun] = findfirst((x)->(x == getName(names[i])), unames)
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
	data[:, :func_name] = unames
	#=
	PRECOMP/TYPE INFERENCE GOES HERE
	1. send :data to function
	2. receive array of outputs of Implementations length
	3. sets them on output
	=#
	println("finished")
	return parsed_data, data
end

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

#=
function _handleFuncNames(arr::Array{NameDef,1})::Array{NameDef,1}
	unames = unique([getName(x) for x in arr])
	res = Array{NameDef,1}(undef,length(unames))
	for i in 1:length(res)
		res[i] = arr[findfirst((x)->(getName(x) == unames[i]),arr)]
	end
	res
end
=#

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

#=function _handle_calls_set(
		carr::Array{Array{NameDef,1},1}, 
		narr::Array{Array{String,1},1})::Array{Array{NameDef,1},1}
	uniques = [sort(unique(x))for x in carr]
	=#

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