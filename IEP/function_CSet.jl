### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ f5031280-600e-11eb-3799-015a8792ae63
using Pkg

# ╔═╡ 6a976fde-624f-11eb-0219-776399a2f5fc
using Match

# ╔═╡ 90e5cff0-6012-11eb-3182-ef1e1f802343
using Catlab, Catlab.CategoricalAlgebra, DataFrames

# ╔═╡ f4e1c610-6096-11eb-0a8c-6f0ffcc97f6b
using Tokenize

# ╔═╡ 45fa2930-6181-11eb-22b0-6d76ebff6633
using CSTParser

# ╔═╡ a721c7e2-617c-11eb-325f-a58b3c82471e
using Catlab.Graphics

# ╔═╡ b9cf6ec0-600e-11eb-25d0-93643031c456
include("scrape.jl")

# ╔═╡ f0743ec0-6012-11eb-154a-e9a8eff08ce7
include("parse_folder.jl")

# ╔═╡ f4d99180-600e-11eb-3053-2f2814838927
Pkg.activate(".")

# ╔═╡ a1d9e5c0-6590-11eb-18ee-7b5bd23e3dcf


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

# ╔═╡ 2568ee40-662c-11eb-37f1-9550afe121d9
parsed_cst = read_code("tmp_cst/CSTParser.jl-master/src");

# ╔═╡ 72423d70-662c-11eb-2201-bb616fcb0a09
func_only = [x[1] for x in parsed_cst];

# ╔═╡ 84518020-662c-11eb-1da2-65e8e8bd8913
scrape_expr(func_only[228])

# ╔═╡ a419bf2e-6636-11eb-19ab-cb0998cd368e


# ╔═╡ a0a823a0-662c-11eb-37cc-9f9d49a091e7
begin
	res = []
	for i in 1:length(func_only)
		try
			scrape_expr(func_only[i])
		catch e
			push!(res, i)
			println(e)
			println("errore a index: $i")
		end
	end
end

# ╔═╡ b48a6d10-6636-11eb-0f83-191884cd8d1a
res

# ╔═╡ b6aab500-6636-11eb-359c-49a6de2ef38e
scrape_expr(func_only[19], nothing; verbose = true)

# ╔═╡ 7337cdc0-663c-11eb-082f-45eccad348ad
 sample = func_only[19]

# ╔═╡ a70ec2a0-663e-11eb-0f1b-63ef7b2eb92b
parsed_cst[19][2]

# ╔═╡ 987e62f0-663d-11eb-38ac-235acf0e0dcf
sample.head

# ╔═╡ 9c4d9362-663d-11eb-2881-cf70319512af
begin
	global verbose = true
	global _tmp = sample
	_call = nothing
	while isnothing(_call) && !isnothing(_tmp.args) && !isempty(_tmp.args)
		if _tmp.args[1].head == :call
			if verbose
				println("found :call")
			end
			global _call = _tmp.args[1]
		else
			global _tmp = _tmp.args[1]
		end
	end
end

# ╔═╡ 1f21b3c0-663e-11eb-111b-015255226fd4
[x.head for x in _call.args]

# ╔═╡ 3872b860-663e-11eb-0a8b-bd95442fb8a2
find_heads(_call, :IDENTIFIER)

# ╔═╡ e7048250-663e-11eb-31f6-f3e83763dfe3


# ╔═╡ 49c11c0e-663e-11eb-2706-cb6cd59a261c
_call

# ╔═╡ fadb8220-663d-11eb-3759-05d0a29044a3
begin
	if isnothing(_call)
		#there is no :call
		return ("could not find :call subexpr")
	else
		# find variables
		# first element should be name of function
		println("block 1")
		name = _call[findfirst((x)->(x.head == :IDENTIFIER), _call.args)].val
		println("block 2")
		#the rest are variables		
		if !isnothing(_call.args) && length(_call.args) > 1	
			println("block 3")
			variables = [
				variable_declaration(_call.args[i]; verbose = verbose) for i in 2:length(_call.args)
				]
		else
			println("block 4")
			variables = []
		end

		return (
			name = name, 
			input_variables = variables
		)
	end
end

# ╔═╡ 59566240-6637-11eb-3fd3-9d78aa40b793
println("############")

# ╔═╡ 4564cc00-662c-11eb-108a-1d1a1fc6ea61
scrape_expr([x[1] for x in parsed_cst])

# ╔═╡ 6a107630-662c-11eb-0a57-bff255bdbf99
scrape()

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

# ╔═╡ dafd3880-619d-11eb-24b8-ebd69e0320cf
function folder_to_CSet(path::String)
	
	println("#### parsing folder #####")
	raw_parse = read_code(path)
	
	
	println("#### scraping parsed #####")	
	parsed = []
	for i in 1:length(raw_parse)
		try
			tmp = scrape_expr(raw_parse[i][1])
			parsed = vcat(parsed, [(scrape = tmp[x], source= raw_parse[i][2]) for x in 1:length(tmp)])
		catch e
			println("SCRAPE ERROR: $e")
			println("SCRAPING EXPRESSION: $(raw_parse[i][1])")
		end
	end
	
	println("#### selecting functions #####")
	functions = filter(
	(x)->(x.scrape.type == :function), parsed
)
	println([typeof(x) for x in functions])
	println("functions number: $(length(functions))")
	
	println("#### creating arrays #####")
	docs = [x.scrape.docs for x in functions]
	names = [x.scrape.content.name for x in functions]
	inputs = [x.scrape.content.input_variables for x in functions]
	
	
	sources = [x.source for x in functions]
	raws = [x.scrape.raw for x in functions]
	ls = [x.scrape.leaves for x in functions]
	calls = map((x)->(length(x)>1 ? [] : sort(unique(x[2:end])))
		,[
		filter(!isnothing, [x[1].val for x in i]) for i in [
				find_heads(x.scrape.raw, :call) for x in functions
					]
		])
	#=
	for i in 1:length(calls)
		@match length(calls[i]) begin
			0 => (calls[i] = [])
			1 => (calls[i] = [])
			_ => (calls[i] = sort(unique(calls[i][2:end])))
		end
end=#
	#df = DataFrame(name= names, doc = docs, inputs = inputs, source = sources, exprs = ls, raw = raws, calls = calls);#we dont need this
	
	# 
	
	
	println("")
	
	
	println("#### creating schema #####")
	@present functionSchema(FreeSchema) begin
		(Function, Implementation, Inputs, Calls)::Ob
		(setImpl, setInp, setExpr, setCalls, docs, name
			)::Data	

		impl_in::Hom(Implementation, Inputs)# ogni implem ha degli input	
		impl_fun::Hom(Implementation, Function)# ogni impl implementa una funzione
		impl_expr::Attr(Implementation, setExpr)#ogni impl è composta da expr
		impl_calls::Hom(Implementation, Calls)

		# link objects to their actual data
		impl_set::Attr(Implementation, setImpl)
		in_set::Attr(Inputs, setInp)
		calls_set::Attr(Calls, setCalls)

		# more attributes
		func_name::Attr(Function, name)
		impl_docs::Attr(Implementation, docs)

	end
	
	println("#### declaring schema, data #####")
	parsedData = ACSetType(functionSchema, index=[:impl_fun])
	data = parsedData{Any, Any, Any, Any, Union{String,Nothing}, Union{String,Nothing}}()
	
	impl_names = names;
	fun_names = unique(impl_names)
	println("#### initializing #####")
	impls = add_parts!(data, :Implementation, length(impl_names))
	println(impls)
	funs = add_parts!(data, :Function, length(fun_names))
	println(funs)
	cal = add_parts!(data, :Calls, length(unique(calls)))
	println(cal)
	# all inputs
	inputs = _get_types_from_inputs(inputs)
	inps = add_parts!(data, :Inputs, length(unique(inputs)))
	
	
	data[:, :in_set] = unique(inputs)
			# do inputs together since they have same indexing
	println("in expr")
	
	println("handling calls sets")
	#=for i in cal
		println("loop $i")
		
		println("calls set")
		data[i, :calls_set] = unique(df.calls)[i]
	end=#
	ucalls = unique(calls)
	data[:, :calls_set] = unique(calls)
	
	
	println("#### handling impl and inp #####")
	# assign implementations data
	println("impl expr")
	data[:, :impl_expr] = ls
	println("impl set")
	data[:, :impl_set] = raws
	println("impl docs")
	data[:, :impl_docs] = docs
	
	for i in 1:length(impl_names)
		println("loop $i")
	
		
		println("impl in")
		data[i, :impl_in] = findfirst((x)->(x == sort(inputs[i])), unique(inputs))
		println("impl fun")
		data[i, :impl_fun] = findfirst((x)->(x == impl_names[i]), fun_names)
		println("impl calls")
		if isnothing(calls[i]) || isempty(calls[i])
			data[i, :impl_calls] = 0
		else
			asdf = findfirst((x)->( x == calls[i]), ucalls)
			data[i, :impl_calls] = findfirst(
				(x)->(x == calls[i]), ucalls
			)
		end
	end
		# do func names
	println("#### handling function #####")
	data[:, :func_name] = fun_names
	
	println("#### finished #####")
	return parsedData, data
end

# ╔═╡ Cell order:
# ╠═f5031280-600e-11eb-3799-015a8792ae63
# ╠═f4d99180-600e-11eb-3053-2f2814838927
# ╠═b9cf6ec0-600e-11eb-25d0-93643031c456
# ╠═f0743ec0-6012-11eb-154a-e9a8eff08ce7
# ╠═6a976fde-624f-11eb-0219-776399a2f5fc
# ╠═90e5cff0-6012-11eb-3182-ef1e1f802343
# ╠═dafd3880-619d-11eb-24b8-ebd69e0320cf
# ╠═a1d9e5c0-6590-11eb-18ee-7b5bd23e3dcf
# ╠═357dc2d0-64b3-11eb-374f-351a90dc6d17
# ╠═2568ee40-662c-11eb-37f1-9550afe121d9
# ╠═72423d70-662c-11eb-2201-bb616fcb0a09
# ╠═84518020-662c-11eb-1da2-65e8e8bd8913
# ╠═a419bf2e-6636-11eb-19ab-cb0998cd368e
# ╠═a0a823a0-662c-11eb-37cc-9f9d49a091e7
# ╠═b48a6d10-6636-11eb-0f83-191884cd8d1a
# ╠═b6aab500-6636-11eb-359c-49a6de2ef38e
# ╠═7337cdc0-663c-11eb-082f-45eccad348ad
# ╠═a70ec2a0-663e-11eb-0f1b-63ef7b2eb92b
# ╠═987e62f0-663d-11eb-38ac-235acf0e0dcf
# ╠═9c4d9362-663d-11eb-2881-cf70319512af
# ╠═1f21b3c0-663e-11eb-111b-015255226fd4
# ╠═3872b860-663e-11eb-0a8b-bd95442fb8a2
# ╠═e7048250-663e-11eb-31f6-f3e83763dfe3
# ╠═49c11c0e-663e-11eb-2706-cb6cd59a261c
# ╠═fadb8220-663d-11eb-3759-05d0a29044a3
# ╠═59566240-6637-11eb-3fd3-9d78aa40b793
# ╠═4564cc00-662c-11eb-108a-1d1a1fc6ea61
# ╠═6a107630-662c-11eb-0a57-bff255bdbf99
# ╠═669206b0-626f-11eb-3d06-8f6951f50af8
# ╠═f4e1c610-6096-11eb-0a8c-6f0ffcc97f6b
# ╠═45fa2930-6181-11eb-22b0-6d76ebff6633
# ╠═a721c7e2-617c-11eb-325f-a58b3c82471e
