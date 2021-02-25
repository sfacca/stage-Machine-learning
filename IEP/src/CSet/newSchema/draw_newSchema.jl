

function draw_newSchema()
	present = Presentation()

	Language, Math_Expressions, Concept, Unit, Code_symbol, Function, Variable, Expr_Symbol = add_types!(present, [
			(:Language, String),
			(:Math_Expressions, String),
			(:Concept, String),
			(:Unit, String),
			(:Code_symbol, String),
			(:Function, String),
			(:Variable, String),
			(:Expr_Symbol, String)
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

			
	TrainDB = present_to_schema(present)


	split(generate_schema_sql(TrainDB()),"\n")


	draw_schema(present)
end