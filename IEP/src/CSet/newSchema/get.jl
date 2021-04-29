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

function _getUsings(module_id, data)
	data[findall((x)->(x==module_id), data[:,:C]), :D]
end

function get_scope(module_id, data)
	#1 got scope?
	####### 
	res = data[module_id, :scope] # this is fast

	if res == 0	# this is not
		#1 get all block ids
		ids = findall((x)->(x == module_id), data[:, :DefinedIn])
		#2 get names of functions
		funs = data[data[ids, :ImplementsFunc], :func]
		res = Array{Tuple{Int64,String},1}(undef, length(ids))
		for i in 1:length(ids)
			res[i] = (ids[i], func[i])
		end
		data[module_id, :scope] = res
	end

	using_ids = _getUsings(module_id, data)

	#get scope of submodules
	for id in using_ids
		res = vcat(res, get_scope(id, data))
	end

	res
end
