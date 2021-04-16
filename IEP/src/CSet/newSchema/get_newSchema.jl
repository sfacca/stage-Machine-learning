"""
initializes a concept CSet using function containers to populate function, symbol, code_symbol and variable data
"""
function get_newSchema(scrape::Array{FunctionContainer,1})
	
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
		DefinedIn::Hom(Code_block, Module)

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

		# we handle 1 to many relations with auxiliary Obs
		(AComponentOfB, XCalledByY, CUsesD)::Ob
		A::Hom(AComponentOfB, Any)	
		B::Hom(AComponentOfB, Any)
		X::Hom(XCalledByY, Function)
		Y::Hom(XCalledByY, Code_block)
		C::Hom(CUsesD, Module)
		D::Hom(CUsesD, Module)

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
	end

	handle_Scrape(scrape, ACSetType(newSchema, index=[:IsSubClassOf]){Any}())
	
end



# auxiliary functions

function removeDuplicates!(typ::String, data)
	if typ == "XCalledByY"
		new = []
		for i in 1:length(data[:,:isUnit])
			ids = findall((x)->(x==i)data[:,:X])
			if isnothing(ids)
				push!(new, [])
			else
				push!(new, unique(data[ids,:Y]))
			end
		end

		rem_parts!(data, :XCalledByY, length(data[:,:isUnit]))
		for i in 1:length(new)
			xs = add_parts!(data, :XCalledByY, length(new[i]))
			data[xs, :X] = repeat([i], length(new[i]))
			data[xs, :Y] = new[i]
		end
	elseif typ == "AComponentOfB"
		new = []
		for i in 1:length(data[:,:isUnit])
			ids = findall((x)->(x==i)data[:,:A])
			if isnothing(ids)
				push!(new, [])
			else
				push!(new, unique(data[ids,:B]))
			end
		end

		rem_parts!(data, :AComponentOfB, length(data[:,:isUnit]))
		for i in 1:length(new)
			xs = add_parts!(data, :AComponentOfB, length(new[i]))
			data[xs, :A] = repeat([i], length(new[i]))
			data[xs, :B] = new[i]
		end
	end
	# how
	#=
	for every :Any id -> n
	find every :X/:A == id -> n
	find every :Y/:B that is the same
		-> n^2
	remove every relation -> n^2
	add new relations -> n^2
	
	O(n^2)
	
		kinda bad
	=#
end

function type_to_value(typ::String)# this should be a @match
	if typ == "Code_symbol"
		Symbol("code_symbol")
	elseif typ == "Function"
		Symbol("func")
	elseif typ == "Variable"		
		Symbol("variable")
	elseif typ ==	"Symbol"		
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
	end
end
# ╔═╡ fc1da060-75e6-11eb-240c-45586c68abd3
function _checkTyp(typ::String)::Bool
	typ in ["Code_symbol", "Function","Variable", "Symbol", 
				"Language",  "Math_Expression","Concept", "Unit", "Code_block", "Module"]
end


function handle_FunctionContainer!(fc::FunctionContainer, data)
	println("-----------------------")
	#1 get+add the function name
	println("adding function $(getName(fc.func.name)) to data")
	i = function_exists(getName(fc.func.name), data)
	if isnothing(i)
		# we need to add the function
		i = add_parts!(data, :Function, 1)[1]
		data[i, :func] = getName(fc.func.name)
	end
	# i is now the index of the Function

	#5 add code block
	block_id = add_linked_code_block(i, fc.func.block, data)
	
	#2 add calls
	#println("adding calls")
	calls = getName(get_calls(fc.func.block))
	add_calls(block_id, calls, data)
	#2.2 remove duplicate XCalledByY	
	#removeDuplicates!("XCalledByY", data)
	
	
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
	vars = [string(get_all_vals(x)) for x in find_heads(fc.func.block, :IDENTIFIER)]
	add_components(any_block, vars, "Variable", data)
	
	#3.3 add Symbol components (they're actually strings)
	#symbs = unique([String(Symbol(Expr(x))) for x in get_leaves(fc.func.block)])
	#println("adding symbol components")
	symbs = unique(string.(get_all_vals(fc.func.block)))
	add_components(any_block, symbs, "Symbol", data)
	# 3.4 remove duplicate AComponentOfB
	#removeDuplicates!("AComponentOfB", data)
	
	#4 language is julia
	#println("setting language")
	set_UsesLanguage("Code_block", block_id, "Julia", data)

	block_id
end		

function handle_ModuleDef!(mdf, data)
	#1 make the module if it doesnt exist
	i = module_exists(mdf.name, data)
	if isnothing(i)
		i = add_parts!(data, :Module, 1)[1]
		data[i, :modname] = mdf.name
	end
	# i is now the module id

	#2 handle the module's function containers
	for fc in mdf.implements		
		#2.1 add fc to cset
		tmp = handle_FunctionContainer!(fc, data)

		#2.2 link the fc to the module
		data[tmp, :DefinedIn] = i
		
		tmp = nothing
	end
	
	#3 handle the usings
	for used in mdf.usings
		#3.1 gets the module id
		tmp = module_exists(used, data)
		if isnothing(tmp)
			tmp = add_parts!(data, :Module, 1)[1]
			data[tmp, :modname] = used
		end

		#3.2 links the modules
		add_CUsesD(i,tmp,data)

		tmp = nothing
	end

	i
end

#=
struct ModuleDef
    name::String
    submodules::Union{Array{String,1},Nothing}
    usings::Union{Array{String,1},Nothing}
    includes::Union{Array{String,1},Nothing}
    implements::Array{FunctionContainer, 1}
end
=#

# ╔═╡ afed1ae0-7613-11eb-1b5d-f9e0d740d3ac
function handle_Scrape(fcs::Array{FunctionContainer,1}, data)
	for i in 1:length(fcs)
		println("handling container $i")
		try
			handle_FunctionContainer!(fcs[i], data)
		catch e
			println("error at container: $i")
			println(e)
		end
	end
	data
end