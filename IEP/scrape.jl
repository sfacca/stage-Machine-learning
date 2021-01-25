### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 1341adf0-5cf0-11eb-2779-21605d9879c9
using CSTParser

# ╔═╡ c1acf890-5a89-11eb-2b8c-cbde52b367b7
using Match

# ╔═╡ 65b70120-5caa-11eb-05a9-bd4239022c3e
include("corpus_struct.jl")

# ╔═╡ e43e5ce0-5e7c-11eb-2a12-bf68ab971179
include("parse_folder.jl")

# ╔═╡ 4f974a10-5e7d-11eb-277a-f7db47dbc06b
CSTParser.EXPR

# ╔═╡ c9b343a0-5f16-11eb-2044-8bad0b0bb328


# ╔═╡ 0d232dd0-5e86-11eb-3bf3-efafd02e7b87
#scrape_expr.(exprs_only)

# ╔═╡ 069ea9e0-5cf0-11eb-3d1b-2149bf325319
"""
fuynction to scrape from CSTParser.EXPR
"""
function scrape_Docs(e::CSTParser.EXPR)
	# CSTParser.EXPR is iterable, no need for .args size checks	
	res = ()
end

# ╔═╡ db27a4e0-5f21-11eb-24fd-cfa36b36ceff
function variable_declaration(e::CSTParser.EXPR)
	if isnothing(e.args) || isempty(e.args)
		println("no args variable")
		return e
	elseif length(e.args)>1
		return (name = e.args[1].val, type = e.args[end].val)
	else
		return (naem = e.args[1].val, type = "Any")
	end
end

# ╔═╡ 70b8e320-5e7d-11eb-3279-8115a509cf96
function get_inputs(e::CSTParser.EXPR)
	# alg is similar to Expr
	#1 find :call expression
	call_ind = findfirst((x)->(x.head == :call), e)
	#println("call_ind $call_ind")
	if isnothing(call_ind)
		#there is no :call
		return ("could not find :call subexpr")
	else
		
		call = e[call_ind]
		#println("call: $call")
		# find variables
		# first element should be name of function
		name = call[findfirst((x)->(x.head == :IDENTIFIER), call.args)].val
		#the rest are variables, defined either with :IDENTIFIER or :OP (for variables of set types)		
		#variables = length(call) > 1 ? call[2:end] : []
		#println("scraping variables: $(call.args)")
		if !isnothing(call.args) && length(call.args) > 1			
			variables = [
				variable_declaration(call.args[i]) for i in 2:length(call.args)
				]
		else
			variables = []
		end
		
		#println(name, variables)
		return (
			name = name, 
			input_variables = variables
		)
	end
end

# ╔═╡ a4304b40-5f21-11eb-27dd-01e5be2181d9
length([])

# ╔═╡ 326d1bf0-5f17-11eb-2180-b99aa532f177
println("==========================")

# ╔═╡ 62f8bd22-5a89-11eb-3158-cba0a98fb785
"""
:function Expr handler

returns tuple (name, input_variables)
"""
function get_inputs(e::Expr)
	# assumtion: e.head == :function
	# 1 find the :call
	name = nothing
	params = []
	call_found = false
	tmp = e
	call = nothing
	while !call_found
		if tmp.args[1].head == :call
			#println(tmp.args[1])
			call_found = true
			call = tmp.args[1]
		else
			if typeof(tmp.args[1]) == Expr
				tmp = tmp.args[1]
			else
				call_found = true
				call = nothing
			end
		end
	end
	
	#println(call)
	if !isnothing(call)
		if typeof(call.args[1]) == Symbol
			#println("found name")
			name = call.args[1]
		else
			name = nothing
		end
		# we scrape :: and :parameters heads			
		for arg in call.args
			if typeof(arg)== Expr 
				if arg.head == :(::) || arg.head == :parameters 
					push!(params, arg)
				end
			end
		end
	end
	#=println("""function $name has inputs: $(
		string([[x.args[1], "of type", x.args[2]] for x in filter(x->(length(x.args)>1),params)]) 
		)""")=#
	(name = name, input_variables = [x.head == :parameters ? x : (name = x.args[1], type = x.args[2]) for x in params])
end

# ╔═╡ 5e799da0-5a89-11eb-28a3-6fc5463b63e4
"""
middleware to handle different kind of Expr differently
"""
function handle_Content(e::Union{Expr, CSTParser.EXPR})
	@match e.head begin
		:function => get_inputs(e)
		_ => e
	end
end

# ╔═╡ db681500-5a5a-11eb-0de7-fd488e8ecb46
"""
function iterates over input Expr and its subexpr, returns array of every function, abstract, struct and of every expression with doicumentation

output format is array of (docs::Unions{String,Nothing}, type::Symbol, content)
"""
function scrape_expr(e::Expr; d = nothing)
	if e.head in [:function, :struct, :abstract] || !isnothing(d)
		res = [(docs = d, type = e.head, content = handle_Content(e))]
	else
		res = []
	end
	docs = nothing
	#doc = GlobalRef(Core, Symbol("@doc"))
	if !isempty(e.args)
		for i in 1:length(e.args)
			if e.args[i] == GlobalRef(Core, Symbol("@doc"))
				docs = e.args[findfirst(
						(x)->(typeof(x)==String),
						e.args[i:end]
						)]
			elseif typeof(e.args[i])==Expr
				res = vcat(res, scrape_expr(e.args[i],d= docs))
				docs = nothing# attaches docs to next expression, then clears docs
			end
		end	
	end
	res
end

# ╔═╡ 6a656b30-5cf0-11eb-37f3-a3c326b4c4b0
function scrape_expr(e::CSTParser.EXPR, d = nothing)
	if e.head in [:function, :struct, :abstract] || !isnothing(d)
		res = [(docs = d, type = e.head, content = handle_Content(e))]
		d = nothing
		#clear docs after assigning them
	else
		res = []
	end
	
	# CSTParser.EXPR is iterable, needs no checks on args
	i = 1
	while !isnothing(e.args) && i <= length(e.args)
		if e[i].head == :globalref
			next_string = findfirst((x)->(x.head == :TRIPLESTRING), e[i:end])
			if isnothing(next_string)
				println("empty documentation definition")
			else
				d = e[next_string].val
				i = next_string
			end
		else
			res = vcat(res, scrape_expr(e[i], d))
			d = nothing			
		end
		i = i + 1
	end
	res
end

# ╔═╡ 5a8dbd70-5a89-11eb-104f-192cb5f012d7
"""
finds documentation on input expressions
"""
function scrape_Docs(e::Expr)
	#1 find the Core.var"@doc"
	res = (docs = nothing, content = nothing)
	tmp = e
	found_doc = false
	doc = GlobalRef(Core, Symbol("@doc"))
	if tmp.args[1] == doc

		found_doc = true
		if typeof(tmp.args[end]) == Expr
			res = (
				docs = tmp.args[minimum([3, length(tmp.args)])],
				content = handle_Content(tmp.args[end]),
				type = tmp.args[end].head
			)
		else
			res = (
				docs = tmp.args[minimum([3, length(tmp.args)])],
				content = tmp.args[end],
				type = typeof(tmp.args[end])				
			)
		end
	else
		if typeof(tmp.args[1]) == Expr
			tmp = tmp.args[1]
		else
			found_doc = true
		end
	end
	res
end

# ╔═╡ 70a65360-5a89-11eb-2898-37b1b52852bf
function make_struct(funcs::Array{Expr,1})
	res = Array{func,1}(undef,length(funcs))
	for i in 1:length(funcs)
		# for each function		
		called_symbols = [
			x.args[1] for x in filter(
					(x)->(x.head == :call), view_Expr(funcs[i])
				)
		]
		println([
				(x, typeof(x)) for x in
			filter(
					(x)->(typeof(x) != Symbol), called_symbols
				)
			])	
		res[i] = func(
			length(called_symbols)>=1 ? called_symbols[1] : nothing,
			length(called_symbols)>1 ? called_symbols[2:end] : [],
			[]
		)
	end
	# set called_bys
	for i in res
		for j in res
			if i.symbol in j.calls
				push!(i.called_by, j.symbol)
			end
		end
	end
	res
end

# ╔═╡ eb625da0-5e7c-11eb-177e-eb48a6f94b6a
parsed_sample = read_code("programs");

# ╔═╡ 16558b40-5e7d-11eb-2c08-196665490091
exprs_only = [x[1] for x in parsed_sample];

# ╔═╡ b00b3d3e-5e85-11eb-289b-a912cd960e2b
exprs_only[1].args[3].val

# ╔═╡ 52157730-5e82-11eb-22c7-496acd08f489


# ╔═╡ 884be410-5e7d-11eb-0fb3-33fe00da9b49
function find_heads(e::CSTParser.EXPR, head::Symbol)
	if e.head == head
		res = [e]
	else
		res = []
	end
	
	for x in e
		res = vcat(res, find_heads(x,head))
	end
	
	res
end	

# ╔═╡ 52b64082-5e81-11eb-3192-5b0f4f436d55
function find_heads(arr::Array{CSTParser.EXPR,1}, head::Symbol)
	res = []
	for x in arr
		res = vcat(res, find_heads(x, head))
	end
	res
end

# ╔═╡ 25bf0580-5e81-11eb-052f-4f1e5c35349e
functions = find_heads(exprs_only, :function);

# ╔═╡ 085655be-5e81-11eb-3ac5-b1fd97b0f80b
scraped_expressions = scrape_expr(functions[1])

# ╔═╡ cbb3f8d0-5f1a-11eb-3a92-f9adff196c8d
all_scraped = scrape_expr.(functions)

# ╔═╡ 7c9f7b60-5e85-11eb-0c08-8ff862d1fd21
typeof(functions[1])

# ╔═╡ 81dfb070-5f13-11eb-3793-af95c6784b56
functions[1][2][6].head

# ╔═╡ b1646170-5e81-11eb-07f6-8128df68413a
length(functions)

# ╔═╡ ac9dffc0-5e81-11eb-06bc-d529446f090e
functions[1][2].args[1].head

# ╔═╡ c2a49450-5e81-11eb-0c84-0d28904239df
functions[1][2].args[2].head

# ╔═╡ d7ff1c50-5e7f-11eb-01c0-452cc44a4b0a
"""
overloads Base.keys so it works with CSTParser.EXPR
this is required to make findfirst work with CSTParser.EXPR
"""
function Base.keys(e::CSTParser.EXPR)
	return keys(e.args)
end

# ╔═╡ Cell order:
# ╠═65b70120-5caa-11eb-05a9-bd4239022c3e
# ╠═4f974a10-5e7d-11eb-277a-f7db47dbc06b
# ╠═db681500-5a5a-11eb-0de7-fd488e8ecb46
# ╠═6a656b30-5cf0-11eb-37f3-a3c326b4c4b0
# ╠═c9b343a0-5f16-11eb-2044-8bad0b0bb328
# ╠═b00b3d3e-5e85-11eb-289b-a912cd960e2b
# ╠═0d232dd0-5e86-11eb-3bf3-efafd02e7b87
# ╠═1341adf0-5cf0-11eb-2779-21605d9879c9
# ╠═069ea9e0-5cf0-11eb-3d1b-2149bf325319
# ╠═5a8dbd70-5a89-11eb-104f-192cb5f012d7
# ╠═c1acf890-5a89-11eb-2b8c-cbde52b367b7
# ╠═5e799da0-5a89-11eb-28a3-6fc5463b63e4
# ╠═70b8e320-5e7d-11eb-3279-8115a509cf96
# ╠═db27a4e0-5f21-11eb-24fd-cfa36b36ceff
# ╠═a4304b40-5f21-11eb-27dd-01e5be2181d9
# ╠═085655be-5e81-11eb-3ac5-b1fd97b0f80b
# ╠═cbb3f8d0-5f1a-11eb-3a92-f9adff196c8d
# ╠═326d1bf0-5f17-11eb-2180-b99aa532f177
# ╠═7c9f7b60-5e85-11eb-0c08-8ff862d1fd21
# ╠═81dfb070-5f13-11eb-3793-af95c6784b56
# ╠═62f8bd22-5a89-11eb-3158-cba0a98fb785
# ╠═70a65360-5a89-11eb-2898-37b1b52852bf
# ╠═e43e5ce0-5e7c-11eb-2a12-bf68ab971179
# ╠═eb625da0-5e7c-11eb-177e-eb48a6f94b6a
# ╠═16558b40-5e7d-11eb-2c08-196665490091
# ╠═25bf0580-5e81-11eb-052f-4f1e5c35349e
# ╠═b1646170-5e81-11eb-07f6-8128df68413a
# ╠═ac9dffc0-5e81-11eb-06bc-d529446f090e
# ╠═c2a49450-5e81-11eb-0c84-0d28904239df
# ╠═52157730-5e82-11eb-22c7-496acd08f489
# ╠═884be410-5e7d-11eb-0fb3-33fe00da9b49
# ╠═52b64082-5e81-11eb-3192-5b0f4f436d55
# ╠═d7ff1c50-5e7f-11eb-01c0-452cc44a4b0a
