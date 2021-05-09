module_exists = IEP.module_exists
add_CUsesD = IEP.add_CUsesD
function handle_ModuleDef!(mdf::ModuleDef, data)
	println("handle $(mdf.name) moduledef start>>>>>>>>>>>>>>>>>>>>>>")
	#1 make the module if it doesnt exist
	i = module_exists(mdf.name, data)
	if isnothing(i)
		i = add_parts!(data, :Module, 1)[1]
		data[i, :modname] = mdf.name		
		data[i, :scope] = 0
	end
	# i is now the module id
	# get the any too
	any_i = get_Any("Module", i, data)

	# 2 handle submodules
	for moduledef in mdf.submodules
		tmp = module_exists(modname, data)
		if isnothing(tmp)
			tmp = add_parts!(data, :Module, 1)[1]
			data[tmp, :modname] = modname			
			data[tmp, :scope] = 0
		end
		add_CUsesD(any_i, tmp, data)
	end

	# 3 handle usings
	for used in mdf.usings
		#3.1 gets the module id
		tmp = module_exists(used, data)
		if isnothing(tmp)
			tmp = add_parts!(data, :Module, 1)[1]
			data[tmp, :modname] = used			
			data[tmp, :scope] = 0
		end
		#3.2 links the modules
		add_CUsesD(any_i,tmp,data)
	end

	# 4 handle includes
	for incl in mdf.includes
		tmp = file_exists(incl, data)
		if isnothing(tmp)
			tmp = add_parts!(data, :File, 1)[1]
			data[tmp, :filepath] = incl
		end
		add_EIncludesF(any_i, tmp,data)
	end

	# 5 handle implements (add functions)
	for fc in mdf.implements		
		#2.1 add fc to cset
		tmp = handle_FunctionContainer!(fc, data)

		#2.2 link the fc to the module
		data[tmp, :] = i
		
		tmp = nothing
	end
	println("handle $(mdf.name) moduledef end<<<<<<<<<<<<<<<<<<<<<<<")

	i
end