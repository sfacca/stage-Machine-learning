# with AST
function generateFN(scrape::Array{FileDef,1}, return_errors = false)
	
	@present ASTSchema(FreeSchema) begin
		(
			Function,			
			Math_Expression,
			Module,
            Scope,
            Component,# ~ EXPR
            Variable,
			Any
			)::Ob
		(value)::Data


		#relazioni
		inModule::Hom(Function, Module)
        inScope::Hom(Variable, Scope)
        parentScope::Hom(Scope, Scope)
        firstArg::Hom(Component, Component)
        nextSibling::Hom(Component, Component)
        parent::Hom(Component, Component)
        isVariable::Hom(Component, Variable)

		# we handle 1 to many relations with auxiliary Obs
		(ACallsB, CUsesD)::Ob
		A::Hom(ACallsB, Function)	
		B::Hom(ACallsB, Function)
        C::Hom(CUsesD, Module)
        D::Hom(CUsesD, Module)

		#attributi
		uses::Attr(Module, value)
        func::Attr(Function, value)
        math_expression::Attr(Math_Expression, value)
        modname::Attr(Module, value)
        unsolved_calls::Attr(Function, value)
        doc::Attr(Function, value)
        block::Attr(Function, value)
        varname::Attr(Variable, value)
        head::Attr(Component, value)
        val::Attr(Component, value)
	end

	handle_Scrape(scrape, ACSetType(ASTSchema, index=[:inModule]){Any}();return_errors = return_errors)
	
end

#without AST
function generateFN(scrape::Array{FileDef,1})
	
	@present FNSchema(FreeSchema) begin
		(
			Function,			
			Math_Expression,
			Module,
            Scope,
			Any
			)::Ob
		(value)::Data

		#relazioni
		inModule::Hom(Function, Module)
        moduleScope::Hom(Module, Scope)
        functionScope::Hom(Function, Scope)
        parentScope::Hom(Scope, Scope)

		# we handle 1 to many relations with auxiliary Obs
		(ACallsB, CUsesD)::Ob
		A::Hom(ACallsB, Function)	
		B::Hom(ACallsB, Function)
        C::Hom(CUsesD, Module)
        D::Hom(CUsesD, Module)

		#attributi
        math_expression::Attr(Math_Expression, value)
		uses::Attr(Module, value)
        modname::Attr(Module, value)
        func::Attr(Function, value)
        unsolved_calls::Attr(Function, value)
        doc::Attr(Function, value)
        block::Attr(Function, value)
        scope_type::Attr(Scope, value)
        scope_name::Attr(Scope, value)
        unhandled_scope_extensions::Attr(Scope, value)        
	end

	add_scrape_to_FN!(scrape, ACSetType(FNSchema, index=[:inModule]){Any}())
	
end

function add_scrape_to_FN!(fcs::Array{FileDef,1}, data)
	fails = []
	for i in 1:length(fcs)
		println("handling container $i")
		add_FileDef_to_FN!(fcs[i], data)
	end
	data
end
function add_FileDef_to_FN!(fd::FileDef, cset)
    # @scope:
    # every function in the same file is in the scope of every other function in the same file
    # every file included shares its scope in the scope it is included in
    # every function inside the file defines a scope that has the file's scope as its parent
    #1 generate scope

    scope_i = scope_exists("file", fd.path, cset)# we shouldnt need to do this!
    if isnothing(scope_i)
        scope_i = add_scope!("file", fd.path, cset)
        if scope_i == 0
            throw("add_scope! returned 0")
        end
    end
    #1.1 add included files as  "unhandled_scope_extensions"
    if !isnothing(fd.includes) $$ !isempty(fd.includes)
        if typeof(fd.includes) != Array{String,1}
            tmp_includes = Array{String,1}(length(fd.includes), undef)
            for pointer in 1:length(tmp_includes)
                tmp_includes[pointer] = string(fd.includes[pointer])
            end
            cset[scope_i, :unhandled_scope_extensions] = unique(vcat(cset[scope_i, :unhandled_scope_extensions], resolve_include_path(fd.path, tmp_includes) ))
        else
            cset[scope_i, :unhandled_scope_extensions] = unique(vcat(cset[scope_i, :unhandled_scope_extensions], resolve_include_path(fd.path, fd.includes) ))
        end
    end    
    
    #2 add functions to scope
    if !isnothing(fd.functions) $$ !isempty(fd.functions)
        for funcdef in fd.functions
            add_FuncDef_to_FN!(funcdef, cset, scope_i)
        end
    end

    #3 add modules to scope


end

function add_FuncDef_to_FN!(funcdef::FuncDef, cset, parent_scope::Int, module_i=0)  
    #1 create function
    if module_i == 0
        # we dont have a module, function name is just function name
        func_name = getName(funcdef.name)
    else
        # function name is modulename.functionname
        func_name = string(cset[module_i,:modname], ".", getName(funcdef.name))
    end
    i = add_function!(func_name, funcdef, cset)

    #2 linking function to module
    if module_i != 0
        cset[i, :inModule] = module_i
    end

    #3 create scope functionScope::Hom(Function, Scope)
    scope_name = func_name
    if scope_exists("function", scope_name, cset)
        scope_name = string(scope_name,"_1")
        count = 1
        while(scope_exists("function", scope_name, cset))
            scope_name = string(scope_name[1:end-(length(string(count)))],string(count+1))
            count+=1
        end
    end
    scope_i = add_scope!("function", scope_name, cset)

    
    #=
    inModule::Hom(Function, Module)
    
    A::Hom(ACallsB, Function)	
    B::Hom(ACallsB, Function)

    func::Attr(Function, value)
    unsolved_calls::Attr(Function, value)
    doc::Attr(Function, value)
    block::Attr(Function, value)
    =#        

    i
end

function add_ModuleDef_to_FN!(mdef::ModuleDef, )

end


function scope_exists(type, name, cset)
    tmp = findall((x)->(x == name), cset[:,:scope_name])
    if !isnothing(tmp) && !isempty(tmp)
        tmp = findfirst((x)->(x == type), cset[tmp, :scope_type])
    else
        tmp = nothing
    end
    tmp
end

function add_scope!(type, name, cset)
    i = 0
    if type in ["file", "module", "function"]
        i = add_parts!(cset, :Scope, 1)[1]
        cset[i,:scope_name] = name
        cset[i,:scope_type] = type
        cset[i,:unhandled_scope_extensions] = []
    else
        throw("trying to add scope of type $type, only file, module and function types are allowed")
    end
    i
end

function add_function!(func_name::String, funcdef::FuncDef, cset)
    i = add_parts!(cset, :Function, 1)[1]
    cset[i, :func] = func_name
    cset[i, :block] = funcdef.block
    cset[i, :unsolved_calls] = getName(get_calls(funcdef.block))
    cset[i, :doc] = docs
end


#### remove these
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