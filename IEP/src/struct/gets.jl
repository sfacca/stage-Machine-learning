#=
    getters for FunctionContainer, NameDef, FuncDef, InputDef
=#

"""
getter for code block
"""
function getCode(fc::FunctionContainer)::CSTParser.EXPR
	getCode(fd.func)
end

"""
getter for code block
"""
function getCode(fd::FuncDef)::CSTParser.EXPR
	fd.block
end

function getInputs(fc::FunctionContainer)::Array{InputDef,1}
	getInputs(fc.func)
end

function getInputs(fd::FuncDef)::Array{InputDef,1}
	fd.inputs
end

function OLDgetName(nd::NameDef)
	isnothing(nd.mod) ? nd.name : string(getName(nd.mod),".",nd.name)
end

function getName(e::NameDef)::String
	getName(e.name)
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
# to fix: curly, brackets, ref, Tuple

function getName(arr::Array{NameDef,1})::Array{String,1}
	[getName(x.name) for x in arr]
end

function getName(arr::Array{Array{NameDef,1},1})::Array{Array{String,1},1}
	[getName(x) for x in arr]
end

function getName(arr::Array{CSTParser.EXPR,1})::Array{String,1}
	[getName(x) for x in arr]
end	

"""
takes an expr that defines a function adress/name, returns NameDef
"""
function scrapeName(e::CSTParser.EXPR)::NameDef
	NameDef(e)
end

function isequal(x::NameDef, y::NameDef)
	getName(x)==getName(y)
end

function isequal(x::Array{NameDef,1}, y::Array{NameDef,1})
	if length(x)==length(y)
		res = true
		for i in 1:length(x)
			if isequal(x[i], y[i])
			else
				res = false
			end
		end
	else
		res = false
	end
	res
end

function Base.isless(a::NameDef, b::NameDef)
	isless(getName(a), getName(b))
end



"""
returns array of namedefs sorted and unique by getName result
"""
function unique_sorted_names(arr::Array{NameDef,1})::Array{NameDef,1}
	names = [getName(x) for x in arr]
	unames = unique(sort(names))
	res = Array{NameDef,1}(undef, length(unames))
	for i in 1:length(res)
		res[i] = arr[findfirst((x)->(x==unames[i]),names)]
	end
	res
end

function unique_arrays(arr::Array{Array{NameDef,1}})::Array{Array{NameDef,1}}
	#1 turn every array into an array of getnames
	names = getName(arr)
	unames = unique(names)
	res = Array{Array{NameDef,1},1}(undef,length(unames))
	for i in 1:length(res)
		res[i] = arr[findfirst((x)->(x==unames[i]),names)]
	end
	res
end

function getCalls(fc::FunctionContainer)::Array{String,1}
	getName(get_calls(fc.func.block))
end

function _getHeads(fc::FunctionContainer)::Array{String,1}
	r = get_all_heads(fc.func.block)# returns array of Union(EXPR, Symbol)
	x = Array{String,1}(undef, length(r))
	for i in 1:length(r)
		if typeof(r[i]) == CSTParser.EXPR
			x[i] = string(Symbol(Expr(r[i])))			
		else #it's a Symbol
			x[i] = string(r[i])
		end			
	end
	x
end