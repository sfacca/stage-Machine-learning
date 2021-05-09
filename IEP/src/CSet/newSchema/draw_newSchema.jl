

function draw_newSchema()
	present = Presentation()

	#=Language, Math_Expressions, Concept, Unit, Code_symbol, Function, Variable, Expr_Symbol = add_types!(present, [
			(:Language, String),
			(:Math_Expressions, String),
			(:Concept, String),
			(:Unit, String),
			(:Code_symbol, String),
			(:Function, String),
			(:Variable, String),
			(:Expr_Symbol, String)
			]);=#
	Code_symbol, Function, Variable, Symbol, Language, Math_Expression, Concept, Unit, Entity, Ontology, Code_block, Module, Any = dd_types!(present, [
		(:Code_symbol, String), 
		(:Function, String), 
		(:Variable, String), 
		(:Symbol, String), 
		(:Language, String), 
		(:Math_Expression, String), 
		(:Concept, String), 
		(:Unit, String), 
		(:Entity, String), 
		(:Ontology, String), 
		(:Code_block, String), 
		(:Module, String), 
		(:Any, String)
		]);

	IsCalledBy, Co_occurs_with, IsComponentOf, IsMeasuredIn, Implements, VERB, IsSubClassOf = add_processes!(present, [
			(:IsCalledBy, Function, Function),
			(:Co_occurs_with, Language⊗Math_Expressions⊗Concept⊗Unit⊗Code_symbol⊗Function⊗Variable⊗Expr_Symbol, Language⊗Math_Expressions⊗Concept⊗Unit⊗Code_symbol⊗Function⊗Variable⊗Expr_Symbol),
			(:IsComponentOf, Expr_Symbol⊗Function⊗Variable, Function⊗Math_Expressions),
			(:IsMeasuredIn, Language⊗Math_Expressions⊗Concept⊗Unit⊗Code_symbol⊗Function⊗Variable⊗Expr_Symbol, Unit),
			(:Implements, Function, Math_Expressions⊗Concept),
			(:VERB, Language⊗Math_Expressions⊗Concept⊗Unit⊗Code_symbol⊗Function⊗Variable⊗Expr_Symbol, Language⊗Math_Expressions⊗Concept⊗Unit⊗Code_symbol⊗Function⊗Variable⊗Expr_Symbol),
			(:IsSubClassOf, Concept, Concept)
			]);

		#=	
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
		scope::Attr(Module, value)# local scope of module (without external feunction defined in other modules) =#
	TrainDB = present_to_schema(present)


	split(generate_schema_sql(TrainDB()),"\n")


	draw_schema(present)
end