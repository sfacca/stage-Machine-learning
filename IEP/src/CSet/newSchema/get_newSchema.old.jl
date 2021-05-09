
function get_newSchema(scrape::Array{FuncDef,1})
	
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
			Any,
			#File
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
		#ModuleInFile::Hom(Module, File)
		#CodeInFile::Hom(Code_block, File)
		#FileUses::

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
		scope::Attr(Module, value)# local scope of module (without external feunction defined in other modules)
		#filepath::Attr(File, value)
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



"""adds data from an array of funcdef to a cset"""
function handle_Scrape(fcs::Array{FuncDef,1}, data)
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