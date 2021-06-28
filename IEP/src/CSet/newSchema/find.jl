

"""searches data for a math_expression of value expr, returns its index or nothing if none is found"""
function expression_exists(expr::String, data)
	findfirst((x)->(x==expr), data[:,:math_expression])
end
"""searches data for a code_block of value expr, returns its index or nothing if none is found"""
function codeblock_exists(expr::String, data)
	findfirst((x)->(x==expr), data[:,:code_block])
end

"""searches data for a language of value lang, returns its index or nothing if none is found"""
function language_exists(lang::String, data)
	findfirst((x)->(x==lang), data[:,:language])
end

"""searches data for a function of value func, returns its index or nothing if none is found"""
function function_exists(func::String, data)	
	findfirst((x)->(x==func), data[:,:func])
end

"""searches data for a concept of value conc, returns its index or nothing if none is found"""
function concept_exists(conc::String, data)
	findfirst((x)->(x==conc), data[:,:concept])
end

"""searches data for a unit of value lang, returns its index or nothing if none is found"""
function unit_exists(lang::String, data)
	findfirst((x)->(x==lang), data[:,:unit])
end

"""searches data for a module of value name, returns its index or nothing if none is found"""
function module_exists(name::String, data)
	findfirst((x)->(x==name), data[:,:modname])
end

function file_exists(path::String, data)
	findfirst((x)->(x==path), data[:,:filepath])
end

"""searches data for a AComponentOfB or XCalledByY item linking Any Obs x to y
returns its index or nothing is no item is found"""
function findXYRelation(x::Int,y::Int,typ::String, data)# this is incredibly slow
	if typ == "AComponentOfB"
		ids = findall((a)->(a==x),data[:,:A])
		return findfirst((b)->(b==y), data[ids,:B])
	elseif typ == "XCalledByY"		
		ids = findall((a)->(a==x),data[:,:X])
		return findfirst((b)->(b==y), data[ids,:Y])
	else
		return nothing
	end
end

"""generic function searches for Ob of type typ and value value"""
function find_Ob(typ::String, value, data)
	if _checkTyp(typ)
		findfirst((x)->(x==value), data[:,type_to_value(typ)])
	else
		throw("typ is not an Ob name")
	end
end
