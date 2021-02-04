### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 1341adf0-5cf0-11eb-2779-21605d9879c9
using CSTParser

# ╔═╡ c1acf890-5a89-11eb-2b8c-cbde52b367b7
using Match

# ╔═╡ 06ffac70-66f2-11eb-0991-299ba39e2779
include("parse_folder.jl")

# ╔═╡ 51d65430-66fa-11eb-37cb-219e9f8bd76f
include("sample/function_declarations.jl")

# ╔═╡ d43bca20-5f2c-11eb-2ba5-cf4b923b2ead
function scrape_expr(arr::Array{CSTParser.EXPR,1}; verbose = false)
	res = []
	for expr in arr
		res = vcat(res, scrape_expr(expr; verbose = verbose))
	end
	res	
end

# ╔═╡ db27a4e0-5f21-11eb-24fd-cfa36b36ceff
function variable_declaration(e::CSTParser.EXPR; verbose = false)
	if isnothing(e.args) || isempty(e.args)
		if verbose
			println("no args variable")
		end
		return e
	elseif length(e.args)>1
		return (name = e.args[1].val, type = e.args[end].val)
	else
		return (name = e.args[1].val, type = "Any")
	end
end

# ╔═╡ 6a707da0-5f33-11eb-0494-b128c999fd89
function get_inputs(e::CSTParser.EXPR; verbose = false)
	if verbose 
		println("----------start get inputs")
	end
	# alg is similar to Expr
	#1 find :call expression
	tmp = e
	call = nothing
	while isnothing(call) && !isnothing(tmp.args) && !isempty(tmp.args)
		if tmp.args[1].head == :call
			if verbose
				println("found :call")
			end
			call = tmp.args[1]
		else
			tmp = tmp.args[1]
		end
	end
	
	if isnothing(call)
		#there is no :call
		return ("could not find :call subexpr")
	else
		# find variables
		# first element should be name of function
		if isnothing(findfirst((x)->(x.head == :IDENTIFIER), call.args))
			println(call)
		end
		name = call[findfirst((x)->(x.head == :IDENTIFIER), call.args)].val
		#the rest are variables		
		if !isnothing(call.args) && length(call.args) > 1			
			variables = [
				variable_declaration(call.args[i]; verbose = verbose) for i in 2:length(call.args)
				]
		else
			variables = []
		end
		if verbose
			println("------------end get inputs")
		end
		return (
			name = name, 
			input_variables = variables
		)
	end
end

# ╔═╡ 5e799da0-5a89-11eb-28a3-6fc5463b63e4
"""
middleware to handle different kind of Expr differently
"""
function handle_Content(e::Union{Expr, CSTParser.EXPR}; verbose = verbose)
	@match e.head begin
		:function => get_inputs(e; verbose = verbose)
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

# ╔═╡ 336b4250-5f28-11eb-0ddf-45e25c4347e2
function get_all_heads(e::CSTParser.EXPR)
	res = [e.head]
	for expr in e
		res = vcat(res, get_all_heads(expr))
	end
	res
end

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

# ╔═╡ d7ff1c50-5e7f-11eb-01c0-452cc44a4b0a
"""
overloads Base.keys so it works with CSTParser.EXPR
this is required to make findfirst work with CSTParser.EXPR
"""
function Base.keys(e::CSTParser.EXPR)
	return keys(e.args)
end

# ╔═╡ 6094a710-670e-11eb-1d30-8f39c55a2e8d
function get_leaves(e::CSTParser.EXPR)	
	if isnothing(e.args) || isempty(e.args)
		
		res = e
	else
		res = []
		for exp in e.args
			res = vcat(res, get_leaves(exp))
		end
	end
	res
end

# ╔═╡ b9a11222-6016-11eb-1af2-d36a85e541cc
function get_leaves(arr::Array{CSTParser.EXPR, 1})
	
	res = []
	for exp in arr
		res = vcat(res, get_leaves(exp))
	end
	res
end
		

# ╔═╡ 6a656b30-5cf0-11eb-37f3-a3c326b4c4b0
"""
function iterates over input Expr and its subexpr, returns array of every function, abstract, struct and of every expression with doicumentation

output format is array of (docs::Unions{String,Nothing}, type::Symbol, content)
"""
function scrape_expr(e::CSTParser.EXPR, d = nothing; verbose = false)
	
	if verbose
		println("-----------start scrape expr")
		println("head: $(e.head)")
	end
	if e.head == :function || !isnothing(d)
		if verbose
			println("scraping type: $(e.head)")
		end
		
		res = [
			(
				docs = d, 
				raw = e, 
				type = e.head, 
				leaves = get_leaves(e), 
				content = handle_Content(e; verbose = verbose)
				)
		]
		d = nothing
		#clear docs after assigning them
	else
		res = []
	end
	
	if !isnothing(d)
		if verbose
			println("got docs: $d")
		end
	end
	
	i = 1
	while !isnothing(e.args) && i <= length(e.args)
		if e[i].head == :globalrefdoc
			if verbose
				println("==== FOUND GLOBALREFDOC ====")
				println(i)
			end
			
			next_string = findfirst((x)->(x.head == :TRIPLESTRING), e[i:end])
			if isnothing(next_string)
				if verbose
					println("empty documentation definition")
				end
			else
				d = e[next_string].val
				if verbose
					println("FOUND DOCS: $d")
				end
				i = next_string
			end
			if verbose
				println("=========================")
			end
		else
			res = vcat(res, scrape_expr(e.args[i], d; verbose = verbose))
			d = nothing			
		end
		if verbose
			println("$i / $(length(e.args))")
		end
		i = i + 1
	end
	if verbose
		println("-----------------------end scrape expr")
	end
	res
end

# ╔═╡ f75f1010-6702-11eb-23c8-ab21487b79cf
function flatten_EXPR(e::CSTParser.EXPR)
	res = [e]
	if isnothing(e.args)
	else
		for arg in e.args
			res = vcat(res, flatten_EXPR(arg))
		end
	end
	res
end

# ╔═╡ 201f5820-6703-11eb-1992-f9571e34cc54
function flatten_EXPR(arr::Array{CSTParser.EXPR, 1})
	
	res = []
	for exp in arr
		res = vcat(res, flatten_EXPR(exp))
	end
	res
end
		

# ╔═╡ 2f0c5490-66f5-11eb-29a6-9993342212a0
parsed_cst = read_code("sample");

# ╔═╡ 86bb3ace-66f5-11eb-3031-897513321cb4
func_only = [x[1] for x in parsed_cst];

# ╔═╡ fff1e210-670d-11eb-2204-fb1b933db0f4
get_leaves(func_only[1])

# ╔═╡ 712adf50-6703-11eb-13c1-5dea36cd2def
find_heads(func_only, :call)

# ╔═╡ e3f3dd50-66f6-11eb-3782-c55a31bb471c
[x.head for x in flatten_EXPR(func_only[1:2])]

# ╔═╡ aa252a52-6702-11eb-0630-eb8551e04fa4
[[y.head for y in get_leaves(x)] for x in func_only]

# ╔═╡ 8b60c2b0-6724-11eb-126b-2134db80ed3a
sampl = CSTParser.parse("foo = (x::Int,y::Int,z::Int,g)->(x+y)")

# ╔═╡ ce0f39c0-6724-11eb-254b-a55f9fc3581b
sampl.args[2].args[1].args[3].head.val

# ╔═╡ 4dd65320-6723-11eb-00eb-734bef4a3433
e = func_only[2]

# ╔═╡ 47677190-6723-11eb-1953-3b6b125a572f
found = findfirst((x)->(x.head == :function || (typeof(x.head) == CSTParser.EXPR)&& x.head.val == "="
			), e.args)

# ╔═╡ 5474f740-6723-11eb-0240-bd0fc3b5240c
tmp = e.args[found]

# ╔═╡ 34c150a0-6724-11eb-2108-e7d2c39f94e5
tmp.args[2].args

# ╔═╡ 611b6140-6724-11eb-1e34-eb61b04e5207
findall((x)->(x.head == :brackets), tmp.args[2].args)

# ╔═╡ 5b341bb0-6723-11eb-2d85-a5658f84ea1e
tmp.args[2]

# ╔═╡ a8ce5140-6720-11eb-2118-3ff0d5f7a7a9


# ╔═╡ a7142bb0-6700-11eb-1180-b5132d36cf79


# ╔═╡ c0609c72-6700-11eb-3e87-b1eea031b45a
func_only[2].args[4].args[2].args

# ╔═╡ 227a3f70-6700-11eb-372f-556239d00d0f
func_only[2].args[4]

# ╔═╡ 8cbadfd0-66f5-11eb-28e0-2dcca3ef0c35
scrape_expr(func_only; verbose = true)

# ╔═╡ 8242f850-6725-11eb-0c13-850fa1ff4980
struct InputDef
	name::String
	type::String
	end

# ╔═╡ da5dd4b0-6702-11eb-01e7-8b64690b333f
"""
need to find:
1. function name
2. params declarations
3. function block
"""
function id_function(e::CSTParser.EXPR)
	res = nothing
	#1 find :function or OP: =
	found = findfirst((x)->(x.head == :function || (typeof(x.head) == CSTParser.EXPR)&& x.head.val == "="
			), e.args)
	if !isnothing(found)
		tmp = e.args[found] # we now need to find the second part
		if typeof(tmp)==CSTParser.EXPR && tmp.val == "="
			#find either -> or :call			
			found = nothing
			found = findfirst((x)->(x.head == :call), tmp.args)
			if !isnothing(found)
				#ok
				res = tmp[found]
			else
				name = tmp.args[1].val
				# need to find ->
				found = nothing
				i = 1
				while isnothing(found) && i<=length(tmp.args)
					if typeof(tmp.args[i].head) == CSTParser.EXPR && tmp.args[i].head.val == "->"
						#found ->
						# first :brackets / :tuple contains inputs
						# :block contains block
						inputs = []
						# flatten inputs
						for input in tmp.args[i].args[1].args
							if isnothing(input.args)
								inputs = vcat(
									inputs, 
									InputDef(input.val, "Any")
								)
							elseif input.head.val == "::"
								inputs = vcat(
									inputs, 
									InputDef(input.args[1].val, input.args[2].val)
								)
							end
						end
						block = tmp.args[i].args[2]
						res = (name, inputs, block)
					end
						
				end
			end
		else #find :call
			name = tmp.args[1].val#check
			found = nothing
			found = findfirst((x)->(x.head == :call), tmp.args)
			if !isnothing(found)
				#ok
				res = tmp[found]
			end
		end
	end
end
		

# ╔═╡ 9d7dc100-6724-11eb-14b6-63c5dbeb1597
id_function(sampl)

# ╔═╡ eab79900-671f-11eb-225f-3b35b44e4229
id_function(func_only[2])

# ╔═╡ 6a588130-6728-11eb-19ff-d5ff06e3df11
InputDef("asd","dsa")

# ╔═╡ 3685ca80-6704-11eb-21a2-3fdfd6c0f796
typeof(foo)

# ╔═╡ 454768d0-6704-11eb-2fb3-eba3eeaf1ac1
function asdf()
end

# ╔═╡ 4a461892-6704-11eb-2879-2b61d32770ad
typeof(asdf)

# ╔═╡ Cell order:
# ╠═06ffac70-66f2-11eb-0991-299ba39e2779
# ╠═db681500-5a5a-11eb-0de7-fd488e8ecb46
# ╠═6a656b30-5cf0-11eb-37f3-a3c326b4c4b0
# ╠═d43bca20-5f2c-11eb-2ba5-cf4b923b2ead
# ╠═1341adf0-5cf0-11eb-2779-21605d9879c9
# ╠═5a8dbd70-5a89-11eb-104f-192cb5f012d7
# ╠═c1acf890-5a89-11eb-2b8c-cbde52b367b7
# ╠═5e799da0-5a89-11eb-28a3-6fc5463b63e4
# ╠═6a707da0-5f33-11eb-0494-b128c999fd89
# ╠═db27a4e0-5f21-11eb-24fd-cfa36b36ceff
# ╠═336b4250-5f28-11eb-0ddf-45e25c4347e2
# ╠═884be410-5e7d-11eb-0fb3-33fe00da9b49
# ╠═52b64082-5e81-11eb-3192-5b0f4f436d55
# ╠═d7ff1c50-5e7f-11eb-01c0-452cc44a4b0a
# ╠═6094a710-670e-11eb-1d30-8f39c55a2e8d
# ╠═fff1e210-670d-11eb-2204-fb1b933db0f4
# ╠═b9a11222-6016-11eb-1af2-d36a85e541cc
# ╠═f75f1010-6702-11eb-23c8-ab21487b79cf
# ╠═201f5820-6703-11eb-1992-f9571e34cc54
# ╠═712adf50-6703-11eb-13c1-5dea36cd2def
# ╠═e3f3dd50-66f6-11eb-3782-c55a31bb471c
# ╠═2f0c5490-66f5-11eb-29a6-9993342212a0
# ╠═86bb3ace-66f5-11eb-3031-897513321cb4
# ╠═aa252a52-6702-11eb-0630-eb8551e04fa4
# ╠═da5dd4b0-6702-11eb-01e7-8b64690b333f
# ╠═8b60c2b0-6724-11eb-126b-2134db80ed3a
# ╠═6a588130-6728-11eb-19ff-d5ff06e3df11
# ╠═ce0f39c0-6724-11eb-254b-a55f9fc3581b
# ╠═9d7dc100-6724-11eb-14b6-63c5dbeb1597
# ╠═34c150a0-6724-11eb-2108-e7d2c39f94e5
# ╠═611b6140-6724-11eb-1e34-eb61b04e5207
# ╠═eab79900-671f-11eb-225f-3b35b44e4229
# ╠═4dd65320-6723-11eb-00eb-734bef4a3433
# ╠═47677190-6723-11eb-1953-3b6b125a572f
# ╠═5474f740-6723-11eb-0240-bd0fc3b5240c
# ╠═5b341bb0-6723-11eb-2d85-a5658f84ea1e
# ╠═a8ce5140-6720-11eb-2118-3ff0d5f7a7a9
# ╠═a7142bb0-6700-11eb-1180-b5132d36cf79
# ╠═c0609c72-6700-11eb-3e87-b1eea031b45a
# ╠═227a3f70-6700-11eb-372f-556239d00d0f
# ╠═8cbadfd0-66f5-11eb-28e0-2dcca3ef0c35
# ╠═8242f850-6725-11eb-0c13-850fa1ff4980
# ╠═51d65430-66fa-11eb-37cb-219e9f8bd76f
# ╠═3685ca80-6704-11eb-21a2-3fdfd6c0f796
# ╠═454768d0-6704-11eb-2fb3-eba3eeaf1ac1
# ╠═4a461892-6704-11eb-2879-2b61d32770ad
