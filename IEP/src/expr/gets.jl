#=
    contains get-type functions that return iunformation on the input CSTParser.EXPR
=#

"""
uses isOP to check if argument expression is a OP: .
"""
function isDotOP(e::CSTParser.EXPR)
	isOP(e,".")
end

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

function flattenExpr(arr::Array{CSTParser.EXPR,1})::Array{CSTParser.EXPR}
	res = []
	for e in arr
		res = vcat(res, flattenExpr(e))
	end
	res
end

function flattenExpr(e::CSTParser.EXPR)::Array{CSTParser.EXPR}
	res = [e]
	if typeof(e.head) == CSTParser.EXPR
		res = vcat(res, flattenExpr(e.head))
	end
	
	if typeof(e.val) == CSTParser.EXPR
		res = vcat(res, flattenExpr(e.val))
	end
		
	if _checkArgs(e)
		for x in e.args
			res = vcat(res, flattenExpr(x))
		end
	end
	res
end

function get_all_heads(e::Array{CSTParser.EXPR,1})
	[x.head for x in e]
end	

function get_all_vals(e::Array{CSTParser.EXPR,1})
	[x.val for x in e]
end	

"""
recursively views expr tree
returns all expresssions e where e.head == input symbol
"""
function find_heads(x::Array{Any,1}, symbol::Symbol)
	res = []
	for i in 1:length(x)
		elem = x[i]
		len = length(res)
		if typeof(x) in [CSTParser.EXPR, Array{Any,1}]
			try
				res = vcat(res, find_heads(elem, symbol))
			catch err
				println("error at element $i")
				println(err)
			end
		end
		#=
		if len < length(res)
			
		else
			println("loop i")
	end=#
	end
	res
end

function get_all_heads(e::CSTParser.EXPR)
	res = [e.head]
	for expr in e
		res = vcat(res, get_all_heads(expr))
	end
	res
end

"""
recursively views expr tree
returns all expresssions e where e.head == input symbol
"""
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

function find_heads(arr::Array{CSTParser.EXPR,1}, head::Symbol)
	res = []
	for x in arr
		res = vcat(res, find_heads(x, head))
	end
	res
end

"""
overloads Base.keys so it works with CSTParser.EXPR
this is required to make findfirst work with CSTParser.EXPR
"""
function Base.keys(e::CSTParser.EXPR)
	return keys(e.args)
end

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

function get_leaves(arr::Array{CSTParser.EXPR, 1})
	res = []
	for exp in arr
		res = vcat(res, get_leaves(exp))
	end
	res
end		

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

function flatten_EXPR(arr::Array{CSTParser.EXPR, 1})
	res = []
	for exp in arr
		res = vcat(res, flatten_EXPR(exp))
	end
	res
end	

"""
finds both :IDENTIFIER and OP: . of :IDENTIFIER
returns id name or compound name.name
"""
function find_identifier(e::CSTParser.EXPR, i::Int=1)
	#1 sanity checks
	if isnothing(e.args) || isempty(e.args)
		
	end
end

"""
gets calls from input expression as array of NameDefs
"""
function get_calls(e::CSTParser.EXPR)::Array{NameDef,1}
	#if count([_checkArgs(x) for x in find_heads(e, :call)])
	if e.head == :function
		tmp = find_heads(e, :call)
		if length(tmp)>1
			tmp = tmp[2:end]
			return unique_sorted_names([scrapeName(x.args[1]) for x in tmp])
		else
			return Array{NameDef,1}(undef, 0)
		end
	else
		unique_sorted_names([scrapeName(x.args[1]) for x in find_heads(e, :call)])
	end
end

function getName(e::CSTParser.EXPR)::String
	# is this a module.name pattern?	
	if isDotOP(e)
		#println(e)
		res = string(getName(e.args[1]),".",getName(e.args[2]))	
	elseif e.head == :call
		res = string([x.val for x in flattenExpr(e)])
	else
		if e.head == :quotenode
			res = e.args[1].val
		else
			res = e.val
		end
	end

	isnothing(res) ? "" : res
end	

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

"""
uses isOP to check if argument expression is a OP: =
"""
function isAssignmentOP(e::CSTParser.EXPR)
	isOP(e,"=")
end

"""
uses isOP to check if argument expression is a OP: ->
"""
function isArrowOP(e::CSTParser.EXPR)
	isOP(e,"->")
end

"""
uses isOP to check if argument expression is a OP: ::
"""
function isTypedefOP(e::CSTParser.EXPR)
	isOP(e,"::")
end

"""
uses isOP to check if argument expression is a OP: .
"""
function isDotOP(e::CSTParser.EXPR)
	isOP(e,".")
end

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

"""
auxiliary function checks wether argument expression has an args parameter that isnt empty
"""
function _checkArgs(e)
	!isnothing(e.args) && !isempty(e.args)
end