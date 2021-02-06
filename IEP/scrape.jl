### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 5913aa60-689c-11eb-303f-39f989a6bff5
using Catlab, Catlab.CategoricalAlgebra, DataFrames

# ╔═╡ 1341adf0-5cf0-11eb-2779-21605d9879c9
using CSTParser

# ╔═╡ c1acf890-5a89-11eb-2b8c-cbde52b367b7
using Match

# ╔═╡ 06ffac70-66f2-11eb-0991-299ba39e2779
include("parse_folder.jl")

# ╔═╡ 8242f850-6725-11eb-0c13-850fa1ff4980
include("functions_struct.jl")

# ╔═╡ f2a21ef0-689c-11eb-3e95-8de39d7c453f
struct NameDef
	name::String
	mod::Union{String, Nothing}
	NameDef(n::String, m::String) = new(n,m)
	NameDef(n::String, m::Nothing) = new(n,m)
	NameDef(n::String) = NameDef(n,nothing)
	NameDef(n::Nothing,m::Nothing) = new("name error", "NAMEDEF ERROR")
end

# ╔═╡ bce6eece-689c-11eb-19e1-03cce146ed7c
struct InputDef
	name::NameDef
	type::NameDef
	#InputDef(x::NameDef) = new(x, NameDef("Any"))
end

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

# ╔═╡ 4bec4910-67b5-11eb-0e83-27cbaa39673e
"""
finds both :IDENTIFIER and OP: . of :IDENTIFIER
returns id name or compound name.name
"""
function find_identifier(e::CSTParser.EXPR, i::Int=1)
	#1 sanity checks
	if isnothing(e.args) || isempty(e.args)
		
	end
end
		

# ╔═╡ b8806a30-6809-11eb-08cc-fb1ce0deac24
function scrape_functions(arr::Array{CSTParser.EXPR,1};source::Union{String,Nothing} = nothing)::Array{FunctionContainer,1}
	res = Array{FunctionContainer,1}(undef,0)
	for x in arr
		res = vcat(res, scrape_functions(x;source=source))
	end
	res
end

# ╔═╡ 68aa5292-6805-11eb-3e3e-5591d42758b8
"""
called when e.args[i] is globalrefdoc
returns the index containing the actual docs 
or i if it finds none

"""
function getDocs(e::CSTParser.EXPR, i::Int)	
	if length(e.args) > i
		x = findfirst((x)->(x.head == :TRIPLESTRING), e.args)
		if !isnothing(x)
			i = x
		end
	end
	i
end

# ╔═╡ dda9a240-67dc-11eb-3b7e-6149208727a4
"""
after sanity checks, checks wether argument expression is operator op
"""
function isOP(e::CSTParser.EXPR, op::String)
	if !isnothing(e.head) && typeof(e.head) == CSTParser.EXPR
		if !isnothing(e.head.head) && e.head.head == :OPERATOR && e.head.val == op
			true
		else
			false
		end
	else
		false
	end
end

# ╔═╡ 107d91f0-67d2-11eb-07b3-477719ca9a9c
"""
uses isOP to check if argument expression is a OP: =
"""
function isAssignmentOP(e::CSTParser.EXPR)
	isOP(e,"=")
end

# ╔═╡ 6f394770-67d2-11eb-3678-570594a0b1b5
"""
uses isOP to check if argument expression is a OP: ->
"""
function isArrowOP(e::CSTParser.EXPR)
	isOP(e,"->")
end

# ╔═╡ 12782210-67d5-11eb-3bb0-b3bd1445f95f
"""
uses isOP to check if argument expression is a OP: ::
"""
function isTypedefOP(e::CSTParser.EXPR)
	isOP(e,"::")
end

# ╔═╡ 69ff54b0-67d8-11eb-1081-ebd4a2f72033
"""
uses isOP to check if argument expression is a OP: .
"""
function isDotOP(e::CSTParser.EXPR)
	isOP(e,".")
end

# ╔═╡ f63b728e-67fd-11eb-2ef5-cd69e95763bd
"""
auxiliary function checks wether argument expression has an args parameter that isnt empty
"""
function _checkArgs(e)
	!isnothing(e.args) && !isempty(e.args)
end

# ╔═╡ ca8be250-67c7-11eb-17d2-9f4ba3be11a7
"""
takes an expr that defines a function adress/name, returns NameDef
"""
function scrapeName(e::CSTParser.EXPR)::NameDef
	# is this a module.name pattern?	
	if isDotOP(e)
		NameDef(
			getName(scrapeName(e.args[2])), 
			getName(scrapeName(e.args[1]))
		)
	else
		if e.head == :quotenode
			NameDef(e.args[1].val, nothing)
		else
			NameDef(e.val, nothing)
		end
	end		
end

# ╔═╡ ccaf8f30-67d3-11eb-16ff-f307795a6ad0
"""
takes an expr that defines inputs, returns array of InputDef
the expr needs to only contain argument definitions in its .args array
:function -> :call function definitions have their function name in the same args
"""
function scrapeInputs(e::CSTParser.EXPR)::Array{InputDef,1}
	if !isnothing(e.args) && !isempty(e.args)
		arr = Array{InputDef,1}(undef, length(e.args))
		for i in 1:length(arr)
			# is this a simple param name or is this a :: OP?
			if isTypedefOP(e.args[i])
				arr[i] = InputDef(
					scrapeName(e.args[i].args[1]),
					scrapeName(e.args[i].args[2])
				)
			else
				arr[i] = InputDef(
					scrapeName(e.args[i]), 
					NameDef("Any",nothing)
				)
			end
		end		
	else
		arr = Array{InputDef,1}(undef, 0)
	end
	arr
end

# ╔═╡ a9fda510-67c6-11eb-227d-b53cf6674516
"""
checks if argument expression defines a function
if so, returns the FuncDef
otherwise, returns nothing
"""
function scrapeFuncDef(e::CSTParser.EXPR)::Union{FuncDef, Nothing}
	# 1 returns FuncDef if e defines function, Nothing if it doesnt
	if isAssignmentOP(e)
		# an assignment operation can be a function definition 
		# if rvalue is a nameless function, defined with an -> operation
		if isArrowOP(e.args[2])
			# e.args contains the lvalue and rvalue of the -> operation
			# we also now know that the lvalue of the assignment operation 
			# is the function name
			println("funcdef?")
			return FuncDef(
				scrapeName(e.args[1]),
				scrapeInputs(e.args[2].args[1]),
				e.args[2].args[2]
			)
		elseif e.args[1].head == :call
			# we're in the name(vars) = block pattern
			# we can run scrapeinputs on the :call, 
			# the first input will actually be the function name			
			tmp = scrapeInputs(e.args[1])
			inputs = length(tmp) > 1 ? tmp[2:end] : Array{InputDef,1}(undef, 0)
			# the function code will be the rvalue of the assignment operation e
			return FuncDef(
				scrapeName(e.args[1].args[1]),
				inputs,
				e.args[2]				
			)
		end
	elseif e.head == :function
		# this is the basic function name(args) block pattern
		# args[1] could be the call or an :: OP
		if e.args[1].head == :call
			# we're in the name(vars) = block pattern
			# we can run scrapeinputs on the :call, 
			# the first input will actually be the function name			
			tmp = scrapeInputs(e.args[1])
			inputs = length(tmp) > 1 ? tmp[2:end] : Array{InputDef,1}(undef, 0)
			# the function code will be the rvalue of the assignment operation e
			return FuncDef(
				scrapeName(e.args[1].args[1]),
				inputs,
				e.args[2]				
			)
		elseif isTypedefOP(e.args[1])
			# this function defines its output type
			if _checkArgs(e.args[1])&&_checkArgs(e.args[1].args[1])&&e.args[1].args[1].head == :call
				# we're in the name(vars) = block pattern
				# we can run scrapeinputs on the :call, 
				# the first input will actually be the function name			
				tmp = scrapeInputs(e.args[1].args[1])
				inputs = length(tmp) > 1 ? tmp[2:end] : Array{InputDef,1}(undef, 0)
				
				# the function code will be the rvalue of the assignment operation e
				return FuncDef(
					scrapeName(e.args[1].args[1].args[1]),
					inputs,
					e.args[2],
					scrapeName(e.args[1].args[2])
				)
			else
				return FuncDef(
					":function's typedef operator didnt have a :call as its leftvalue",
					e.args[1]					
				)
			end
		end	
	else
		return nothing
	end
	nothing
end	

# ╔═╡ da5dd4b0-6702-11eb-01e7-8b64690b333f
"""
function iterates over EXPR tree, scrapes function definitions and documentation
"""
function scrape_functions(e::CSTParser.EXPR;source::Union{String,Nothing} = nothing)::Array{FunctionContainer,1}
	if _checkArgs(e)#leaves cant be functions
		res = Array{FunctionContainer,1}(undef,0)
		docs = nothing
		# iterates over e.args, looking for functions or docs
		for i in 1:length(e.args)
			if e.args[i].head == :globalrefdoc
				i = getDocs(e,i)
				docs = isnothing(e.args[i].val) ? "error finding triplestring" : e.args[i].val
			end
			
			tmp = scrapeFuncDef(e.args[i])
			if !isnothing(tmp)
				res = push!(res, FunctionContainer(tmp,docs,source))
				docs = nothing
			elseif _checkArgs(e.args[i])
				# if e[i] has args, scrapes e[i]
				res = vcat(res, scrape_functions(e.args[i]; source = source))
			end
		end
		return res
	else
		return Array{FunctionContainer,1}(undef,0)
	end
end

# ╔═╡ e74d330e-680a-11eb-049d-497985c532f7
function scrape(arr::Array{Any,1})::Array{FunctionContainer,1}
	res = Array{FunctionContainer,1}(undef, 0)
	for x in arr
		if typeof(x) == Tuple{CSTParser.EXPR,String}
			try
				res = vcat(res, scrape_functions(x[1]; source = x[2]))
			catch e
				println(e)
			end
		end
	end
	res
end

# ╔═╡ 88cf83a0-689c-11eb-31af-5dd802ea42a9
function folder_to_scrape(path::String)
	scrape(read_code(path))
end

# ╔═╡ Cell order:
# ╠═06ffac70-66f2-11eb-0991-299ba39e2779
# ╠═5913aa60-689c-11eb-303f-39f989a6bff5
# ╠═88cf83a0-689c-11eb-31af-5dd802ea42a9
# ╠═bce6eece-689c-11eb-19e1-03cce146ed7c
# ╠═f2a21ef0-689c-11eb-3e95-8de39d7c453f
# ╠═e74d330e-680a-11eb-049d-497985c532f7
# ╠═db681500-5a5a-11eb-0de7-fd488e8ecb46
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
# ╠═b9a11222-6016-11eb-1af2-d36a85e541cc
# ╠═f75f1010-6702-11eb-23c8-ab21487b79cf
# ╠═201f5820-6703-11eb-1992-f9571e34cc54
# ╠═4bec4910-67b5-11eb-0e83-27cbaa39673e
# ╠═da5dd4b0-6702-11eb-01e7-8b64690b333f
# ╠═b8806a30-6809-11eb-08cc-fb1ce0deac24
# ╠═68aa5292-6805-11eb-3e3e-5591d42758b8
# ╠═107d91f0-67d2-11eb-07b3-477719ca9a9c
# ╠═6f394770-67d2-11eb-3678-570594a0b1b5
# ╠═12782210-67d5-11eb-3bb0-b3bd1445f95f
# ╠═69ff54b0-67d8-11eb-1081-ebd4a2f72033
# ╠═dda9a240-67dc-11eb-3b7e-6149208727a4
# ╠═a9fda510-67c6-11eb-227d-b53cf6674516
# ╠═f63b728e-67fd-11eb-2ef5-cd69e95763bd
# ╠═ca8be250-67c7-11eb-17d2-9f4ba3be11a7
# ╠═ccaf8f30-67d3-11eb-16ff-f307795a6ad0
# ╠═8242f850-6725-11eb-0c13-850fa1ff4980
