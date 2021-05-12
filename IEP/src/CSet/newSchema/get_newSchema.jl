

function type_to_value(typ::String)# this should be a @match
	if typ == "Code_symbol"
		Symbol("code_symbol")
	elseif typ == "Function"
		Symbol("func")
	elseif typ == "Variable"		
		Symbol("variable")
	elseif typ == "Symbol"		
		Symbol("symbol")
	elseif typ == "Language"		
		Symbol("language")
	elseif typ == "Math_Expression"		
		Symbol("math_expression")
	elseif typ == "Concept"		
		Symbol("concept")
	elseif typ == "Unit"		
		Symbol("unit")
	elseif typ == "Code_block"
		Symbol("block")
	elseif typ == "Module"
		Symbol("modname")
	elseif typ == "Entity"
		Symbol("entity")
	elseif typ == "Ontology"
		Symbol("ontology")
	elseif typ == "File"
		Symbol("filepath")
	end
end

# ╔═╡ fc1da060-75e6-11eb-240c-45586c68abd3
function _checkTyp(typ::String)::Bool
	typ in ["Code_symbol", "Function","Variable", "Symbol", 
				"Language",  "Math_Expression","Concept", "Unit", "Entity", "Ontology", "Code_block", "Module", "File", "Any"]
end

"""
adds information in a funcdef to cset
"""
function handle_FunctionContainer!(fc, data)
	#println("-----------------------")
	#1 get+add the function name
	#println("adding function $(getName(fc.name)) to data")
	i = function_exists(getName(fc.name), data)
	if isnothing(i)
		# we need to add the function
		i = add_parts!(data, :Function, 1)[1]
		data[i, :func] = getName(fc.name)
	end
	# i is now the index of the Function
	#println("adding linked code block")
	#5 add code block
	block_id = add_linked_code_block(i, fc.block, data)
	
	#2 add calls
	#println("adding calls")
	calls = getName(get_calls(fc.block))
	add_calls(block_id, calls, data)
	
	
	#3 add components
	
	#3.1 add .head components (Code_symbols)
	#println("adding head components")
	any_i = get_Any("Function", i, data)
	
	any_block = get_Any("Code_block", block_id, data)
	#println("got any_i")
	heads = _getHeads(fc)
	#println("actual add")
	add_components(any_block, heads, "Code_symbol", data)
	
	#3.2 add variable components (Variable)
	#println("adding variable components")
	vars = [string(get_all_vals(x)) for x in find_heads(fc.block, :IDENTIFIER)]
	add_components(any_block, vars, "Variable", data)
	
	#3.3 add Symbol components (they're actually strings)
	#symbs = unique([String(Symbol(Expr(x))) for x in get_leaves(fc.func.block)])
	#println("adding symbol components")
	symbs = unique(string.(get_all_vals(fc.block)))
	add_components(any_block, symbs, "Symbol", data)
	# 3.4 remove duplicate AComponentOfB
	#removeDuplicates!("AComponentOfB", data)
	
	#4 language is julia
	#println("setting language")
	set_UsesLanguage("Code_block", block_id, "Julia", data)
	#println("finished")
	block_id
end

"""generates a new cset from an array of filedefs"""
function get_newSchema(scrape::Array{FileDef,1}, return_errors = false)
	
	@present newSchema(FreeSchema) begin
		(
			Code_symbol, 
			Function, 
			Variable, 
			Symbol, 
			Language, 
			Math_Expression, 
			Concept, 
			Unit,
			Entity,
			Ontology,
			Code_block,
			Module,
			File,
			Any
			)::Ob
		(value)::Data


		#relazioni
		ImplementsFunc::Hom(Code_block, Function)
		Co_occurs::Hom(Any, Any)
		IsMeasuredIn::Hom(Any, Unit)
		ImplementsExpr::Hom(Function, Math_Expression)	
		ImplementsConc::Hom(Function, Concept)
		VERB::Hom(Any,Any) # ?
		IsSubClassOf::Hom(Concept, Concept)
		ImplementedInModule::Hom(Code_block, Module)
		ImplementedInFile::Hom(Code_block, File)
		SubmoduleOf::Hom(Module, Module)
		DefinedIn::Hom(Module, File)

		UsesLanguage::Hom(Any, Language)

		isLanguage::Hom(Any, Language)
		isMath_Expression::Hom(Any, Math_Expression)
		isConcept::Hom(Any, Concept)
		isUnit::Hom(Any, Unit)	
		isCode_symbol::Hom(Any, Code_symbol)
		isFunction::Hom(Any, Function)
		isVariable::Hom(Any, Variable)
		isSymbol::Hom(Any, Symbol)
		isCode_block::Hom(Any, Code_block)
		isModule::Hom(Any, Module)
		isFile::Hom(Any, File)

		# we handle 1 to many relations with auxiliary Obs
		(AComponentOfB, XCalledByY, CUsesD, EIncludesF)::Ob
		A::Hom(AComponentOfB, Any)	
		B::Hom(AComponentOfB, Any)
		X::Hom(XCalledByY, Function)
		Y::Hom(XCalledByY, Code_block)
		C::Hom(CUsesD, Any)# both a file and module can have a using kw
		D::Hom(CUsesD, Module)
		E::Hom(EIncludesF, Any)# includes can be in files or in modules
		F::Hom(EIncludesF, File)

		#attributi
		language::Attr(Language, value)
		math_expression::Attr(Math_Expression, value)
		concept::Attr(Concept, value)
		unit::Attr(Unit, value)
		code_symbol::Attr(Code_symbol, value)
		func::Attr(Function, value)
		variable::Attr(Variable, value)
		symbol::Attr(Symbol, value)
		entity::Attr(Entity, value)
		ontology::Attr(Ontology, value)
		block::Attr(Code_block, value)
		num_call::Attr(Code_block, value)
		modname::Attr(Module, value)
		filepath::Attr(File, value)
		block_ids::Attr(XCalledByY, value)# lookup goes here
		scope::Attr(Module, value)
	end

	handle_Scrape(scrape, ACSetType(newSchema, index=[:IsSubClassOf]){Any}();return_errors = return_errors)
	
end


function handle_Scrape(fcs::Array{FileDef,1}, data; return_errors = false)
	fails = []
	for i in 1:length(fcs)
		println("handling container $i")
		#try
			handle_FileDef!(fcs[i], data)
		#catch e
		#	println("error on container $i")
		#	push!(fails, ("container $i", e))
		#end
	end
	if return_errors
		data, fails
	else
		data
	end
end
function nothing_or_empty(t)
	isnothing(t) || isempty(t)
end
"""adds info from a filedef into the cset
this returns 0 if the filedef is empty"""
function handle_FileDef!(fd::FileDef,data)
	#0 we're going to ignore files that implement no functions or modules and include no file.
	if nothing_or_empty(fd.modules) && nothing_or_empty(fd.functions) && nothing_or_empty(fd.includes)
		return 0
	end

	#1 check for same filename
	i = file_exists(fd.path, data)
	if isnothing(i)
		#add file
		i = add_parts!(data, :File, 1)[1]
		data[i, :filepath] = fd.path
	end
	# i is now the file id
	# get the any too
	any_i = get_Any("File", i, data)

	#2 handle usings
	# fd.uses contains array of strings, these strings are module names
	for modname in fd.uses
		tmp = module_exists(modname, data)
		if isnothing(tmp)
			tmp = add_parts!(data, :Module, 1)[1]
			data[tmp, :modname] = modname
			data[tmp, :scope] = 0
		end
		add_CUsesD(any_i, tmp, data)
	end

	#3 handle modules
	for moduledef in fd.modules
		# make module if it doesnt exist
		if !nothing_or_empty(moduledef.includes)
			moduledef.includes = [resolve_include_path(fd.path, x) for x in moduledef.includes]#we dont want relative paths
		end
		tmp = handle_ModuleDef!(moduledef, data)
		data[tmp, :DefinedIn] = i
	end

	#4 handle (add) functions
	for funcont in fd.functions
		tmp = handle_FunctionContainer!(funcont, data)
		data[tmp, :ImplementedInFile] = i
	end

	#5 handle includes
	for incl in fd.includes
		tmp = file_exists(incl, data)
		if isnothing(tmp)
			tmp = add_parts!(data, :File, 1)[1]
			data[tmp, :filepath] = incl
		end
		add_EIncludesF(any_i, tmp,data)
	end

	i
end
function handle_FileDef!(fds::Array{FileDef,1},data)
	for fd in fds
		handle_FileDef!(fd, data)
	end	
end	
function handle_ModuleDef!(mdf, data)
	#println("handle $(mdf.name) moduledef start>>>>>>>>>>>>>>>>>>>>>>")
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
	if !isnothing(mdf.submodules)
		for moduledef in mdf.submodules
			tmp = module_exists(moduledef.name, data)
			if isnothing(tmp)
				tmp = add_parts!(data, :Module, 1)[1]
				data[tmp, :modname] = moduledef.name			
				data[tmp, :scope] = 0
			end
			data[tmp, :SubmoduleOf] = i
			#add_CUsesD(any_i, tmp, data)
		end
	end

	# 3 handle usings
	if !isnothing(mdf.usings)
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
	end

	# 4 handle includes
	if !isnothing(mdf.includes)
		for incl in mdf.includes
			tmp = file_exists(incl, data)
			if isnothing(tmp)
				tmp = add_parts!(data, :File, 1)[1]
				data[tmp, :filepath] = incl
			end
			add_EIncludesF(any_i, tmp,data)
		end
	end

	# 5 handle implements (add functions)
	if !isnothing(mdf.implements)
		for fc in mdf.implements		
			#2.1 add fc to cset
			tmp = handle_FunctionContainer!(fc, data)

			#2.2 link the fc to the module
			data[tmp, :ImplementedInModule] = i
			
			tmp = nothing
		end
	end
	#println("handle $(mdf.name) moduledef end<<<<<<<<<<<<<<<<<<<<<<<")

	i
end

function resolve_include_path(origin::String, paths::Array{String,1})::Array{String,1}
    [resolve_include_path(origin, path) for path in paths]
end
function resolve_include_path(origin::String, path::String)::String
    # get base path
    origin = split(origin,"\\")[1:(end-1)]# this removes the filename
    path = split(replace(path, r"/"=>"\\"),"\\")
    for name in path
        if name == ".."
            if length(origin)>0
                origin = origin[1:(end-1)]# "../" means go back one folder
            else
                origin = [".."]
            end
        else
            push!(origin, name)
        end
    end
    string(origin.*"\\"...)[1:(end-1)]
end