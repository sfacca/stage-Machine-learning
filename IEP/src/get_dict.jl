using Pkg, Catlab, JLD2, FileIO, CSTParser

#include("functions_struct.jl")
#include("function_CSet.jl")
#

"""
makes complete dict of expressions, heads and vals
"""
function make_dict_complete(arr::Array{CSTParser.EXPR,1})
	dic = Dict()
	i = 1
	flat = unique(flattenExpr(arr))
	
	for j in 1:length(flat)
		dic[i] = flat[j]
		i = i + 1
	end
	heads = unique(get_all_heads(flat))
	for j in 1:length(heads)		
		dic[i] =heads[j]
		i = i + 1
	end
	vals = unique(get_all_vals(flat))	
	for j in 1:length(vals)
		dic[i] =vals[j]
		i = i + 1
	end
	return dic
	
end

"""
makes a Dict(Symbol, CSTParser.EXPR)
where dict[symbol] = expr where expr.head = symbol
"""
function make_head_expr_dict(arr::Array{CSTParser.EXPR,1})
	dic = Dict()
	flat = unique(flattenExpr(arr))	
	for j in 1:length(flat)
		if typeof(flat[j].head) == Symbol
			dic[flat[j].head] = flat[j]
		end
	end
	dic	
end

function make_dict(arr::Array{CSTParser.EXPR,1})
	dic = Dict()
	i = 1
	flat = unique(flattenExpr(arr))
	
	for j in 1:length(flat)
		dic[i] = flat[j]
		i = i + 1
	end
	dic
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