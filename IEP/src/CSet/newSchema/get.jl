"""
looks for the Any Ob of the index Ob of type typ, makes one if none is found
returns index of said Any Ob
"""
function get_Any(typ::String, index::Int, data)
	res = nothing
	if _checkTyp(typ)
		#1 finds correct any
		res = findfirst((x)->(x == index), data[:,Symbol(string("is",typ))])
		if isnothing(res)
			# makes an any
			res = add_parts!(data, :Any, 1)[1]
			data[res, Symbol(string("is",typ))] = index
		end
	else
		throw("typ: $typ is not an Ob name")
	end
	res
end
