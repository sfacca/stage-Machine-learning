### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ e9434890-7501-11eb-2edb-81748e905d23
using Catlab

# ╔═╡ e9436fa0-7501-11eb-1b4a-2d494b1fd75e
using Catlab.Theories

# ╔═╡ 49264790-7524-11eb-33c4-8f994da86020
using Catlab.CategoricalAlgebra

# ╔═╡ e946cb00-7501-11eb-0088-31551915d87b
using Catlab.Syntax

# ╔═╡ e9471920-7501-11eb-3a12-ff506e75ba06
using Convex, SCS, TikzPictures

# ╔═╡ ebc5d4c0-7501-11eb-2857-abf958041d8e
using Pkg

# ╔═╡ e94a9b90-7501-11eb-21c8-e9262a1e6f0d
using Compose: draw, PGF

# ╔═╡ e94d5ab0-7501-11eb-12cd-2509abb027e8
using Catlab.Graphics

# ╔═╡ e94da8d0-7501-11eb-2b85-918c1d64a291
using Catlab.Graphics.ComposeWiringDiagrams

# ╔═╡ e9510430-7501-11eb-20f4-3927568402ae
using Catlab.WiringDiagrams

# ╔═╡ 304efe70-7532-11eb-0a3f-95c7fb7330ea
using CSTParser

# ╔═╡ e9512b40-7501-11eb-3e5e-d33905119a23
using Catlab.Programs

# ╔═╡ 8d888650-756a-11eb-300c-c74a2f186659
using AlgebraicRelations

# ╔═╡ f10beb22-756c-11eb-3d22-4dc0bb9809e8
using AlgebraicRelations.DB

# ╔═╡ f2653992-756c-11eb-3605-556902e1182e
using AlgebraicRelations.Queries

# ╔═╡ f26560a0-756c-11eb-238f-b9b3570a017a
using AlgebraicRelations.Presentations

# ╔═╡ f265d5d0-756c-11eb-152a-0bd3855a6709
using AlgebraicRelations.Interface

# ╔═╡ 5826ba10-7518-11eb-23f3-97ca6283475f
include("../IEP.jl")

# ╔═╡ e95486a0-7501-11eb-07f5-b7fe35295f0d
import Catlab.WiringDiagrams: to_hom_expr

# ╔═╡ 0e227820-74fd-11eb-210e-a5ddcaea4c67
#=Science Concepts:
Language
Math Expressions
Concept
Unit

 

Vertex Types:
Code symbols
Functions
Variables
Symbols

... 



Edge Types: SourceType -> DestinationType
IsCalledBy: function -> function
Co-occurs with: Any -> Any
IsComponentOf: {Symbol,Function,Variable} -> {Function, Expression}
IsMeasuredIn: Any -> Unit
Implements: Function -> {Math Expression, Concept}
VERB: Any -> Any
IsSubClassOf: SpecificConcept -> More General Concept=#

# ╔═╡ 41fa654e-7529-11eb-2b56-c9f4736bdd57
#get data
scr = IEP.scrape(IEP.read_code(string(Pkg.dir("Catlab"),"/src")));

# ╔═╡ 4f386fe2-7534-11eb-0375-3f932f5a91b0


# ╔═╡ 8e8a1cd0-7533-11eb-2712-07dc18427c9c
verbs = [x.docs for x in scr]

# ╔═╡ 4fe965d0-7533-11eb-023a-e9786c047157
# get variables
vars_sets = [IEP.find_heads(x.func.block, :IDENTIFIER) for x in scr]

# ╔═╡ 35579940-7532-11eb-1fc2-4f8783f77ea2
# type inference missing

# ╔═╡ 307ec530-752b-11eb-22b8-095fce04407f
# (non unique) sets of code symbols
code_symbols_sets = [IEP.get_all_heads(x.func.block) for x in scr];

# ╔═╡ 4a06b850-752b-11eb-1a55-536df758b4b5
# all unique heads
begin
	code_symbols = []
	for x in code_symbols_sets
		code_symbols = vcat(code_symbols, x)
	end
	code_symbols = unique(code_symbols)
	code_symbols = unique([typeof(x)==Symbol ? x : Symbol(x.val) for x in code_symbols])
end

# ╔═╡ 6ca82580-7529-11eb-0d4d-055b69400a09
# (non unique) sets of calls
calls_sets = [IEP.getName(IEP.get_calls(x.func.block)) for x in scr];

# ╔═╡ ea6e53e0-7529-11eb-187a-39825c083f64
# all unique calls
begin
	calls = []
	for x in calls_sets
		calls = vcat(calls, x)
	end
	calls = unique(calls)
end

# ╔═╡ 599666c0-7504-11eb-1cf6-27051856b4c2
⊗

# ╔═╡ 2c3e7940-7574-11eb-27cb-f7877333d9c7
scr[1].func.name

# ╔═╡ b990cc70-7575-11eb-3195-95e4ad299063
function getheads(e::CSTParser.EXPR)
	if isnothing(e.head)
		res = []
	else
		res = [e.head]
	end
	if !isnothing(e.args) && !isempty(e.args)
		for x in e
			res = vcat(res, getheads(x))
		end
	end
	res
end

# ╔═╡ 80867150-7575-11eb-305c-0d55315a3910
function getvals(e::CSTParser.EXPR)
	if isnothing(e.val)
		res = []
	else
		res = [e.val]
	end
	if !isnothing(e.args) && !isempty(e.args)
		for x in e
			res = vcat(res, getvals(x))
		end
	end
	res
end

# ╔═╡ ad5cd350-7574-11eb-3527-c780500be432
findall((x)->("Module" in getvals(x.func.block)), scr)

# ╔═╡ d326541e-7575-11eb-0613-0f5231124969
Expr(scr[510].func.block)

# ╔═╡ d7ee8000-7574-11eb-0ff7-cd88cef0b663
IEP.get_all_vals([scr[87].func.block])

# ╔═╡ 10bf22f2-7574-11eb-3c4b-a5ea4386a4b9
findall((x)->(IEP.getName(x.func.name) == "⊗"), scr)

# ╔═╡ 48da6320-7574-11eb-3495-5dcbfed43e38
scr[422]

# ╔═╡ 4c4fdace-7574-11eb-04f3-d93f8395103f
scr[423]

# ╔═╡ 43f01e62-7577-11eb-1bae-99f688d3d865
FreeSchema

# ╔═╡ af096320-757a-11eb-2de3-134aaf3ff12f


# ╔═╡ aecaac70-757a-11eb-2254-9ffd556ad183


# ╔═╡ ae867780-757a-11eb-096e-21097a50e468


# ╔═╡ ae3f0e40-757a-11eb-033b-0773190d2097


# ╔═╡ ade63fe0-757a-11eb-0ac1-c7055311137b


# ╔═╡ be491ad0-7569-11eb-103b-096da0254a1b
present = Presentation()

# ╔═╡ 4f88117e-756b-11eb-2bb1-f7b78687e0b5
IEP.FunctionContainer

# ╔═╡ ef02a310-756b-11eb-121b-ef3fd2c5b1db
#=
IsCalledBy: Function -> Function
Co-occurs with: Any -> Any
IsComponentOf: {Symbol,Function,Variable} -> {Function, Expression}
IsMeasuredIn: Any -> Unit
Implements: Function -> {Math Expression, Concept}
VERB: Any -> Any
IsSubClassOf: Concept -> Concept
=#

# ╔═╡ e77b1b00-756a-11eb-2224-57c43aba9c24
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

# ╔═╡ b5d74b10-756e-11eb-2d0d-5325fde6dc02
IEP.FunctionContainer

# ╔═╡ bda5bca0-756e-11eb-31e8-47d1397b8f05
Symbol("Main.workspace3.IEP.FunctionContainer")

# ╔═╡ 99d6538e-756c-11eb-395d-e77b53735053
IsCalledBy, Co_occurs_with, IsComponentOf, IsMeasuredIn, Implements, VERB, IsSubClassOf = add_processes!(present, [
		(:IsCalledBy, Function, Function),
		(:Co_occurs_with, Language⊗Math_Expressions⊗Concept⊗Unit⊗Code_symbol⊗Function⊗Variable⊗Expr_Symbol, Language⊗Math_Expressions⊗Concept⊗Unit⊗Code_symbol⊗Function⊗Variable⊗Expr_Symbol),
		(:IsComponentOf, Expr_Symbol⊗Function⊗Variable, Function⊗Math_Expressions),
		(:IsMeasuredIn, Language⊗Math_Expressions⊗Concept⊗Unit⊗Code_symbol⊗Function⊗Variable⊗Expr_Symbol, Unit),
		(:Implements, Function, Math_Expressions⊗Concept),
		(:VERB, Language⊗Math_Expressions⊗Concept⊗Unit⊗Code_symbol⊗Function⊗Variable⊗Expr_Symbol, Language⊗Math_Expressions⊗Concept⊗Unit⊗Code_symbol⊗Function⊗Variable⊗Expr_Symbol),
		(:IsSubClassOf, Concept, Concept)
		]);

# ╔═╡ f0c07f20-74fc-11eb-2343-ab6e86584e80
@present concSchema(FreeSchema) begin
	(Language, Expression, Concept, Unit)::Ob #Expression == Math Expression
	(Code_symbol, Function, Variable, Symbol)::Ob
	(Any)::Ob
	(uid)::Data
	# freeschema has no ⊗
	#(docs)::Data

	#relazioni
	IsCalledBy::Hom(Function, Function)
	Co_occurs::Hom(Any, Any)
	IsComponentOfFun::Hom(Any, Function)
	IsComponentOfExpr::Hom(Any, Expression)
	IsMeasuredIn::Hom(Any, Unit)
	ImplementsExpr::Hom(Function, Expression)	
	ImplementsConc::Hom(Function, Concept)
	VERB::Hom(Any,Any)
	IsSubClassOf::Hom(Concept, Concept)
	is::Attr(Any, uid)
	
	
end

# ╔═╡ 73ec58d0-7573-11eb-1a89-c135d41c577d
Symbol 

# ╔═╡ 6c47683e-7573-11eb-069b-3bee287d6cfc
TrainDB = present_to_schema(present);

# ╔═╡ a83fbb90-7573-11eb-1c32-9907d003363d
split(generate_schema_sql(TrainDB()),"\n")

# ╔═╡ d7406280-7570-11eb-2b34-257994816bdf
draw_schema(present)

# ╔═╡ Cell order:
# ╠═e9434890-7501-11eb-2edb-81748e905d23
# ╠═e9436fa0-7501-11eb-1b4a-2d494b1fd75e
# ╠═49264790-7524-11eb-33c4-8f994da86020
# ╠═e946cb00-7501-11eb-0088-31551915d87b
# ╠═e9471920-7501-11eb-3a12-ff506e75ba06
# ╠═ebc5d4c0-7501-11eb-2857-abf958041d8e
# ╠═e94a9b90-7501-11eb-21c8-e9262a1e6f0d
# ╠═e94d5ab0-7501-11eb-12cd-2509abb027e8
# ╠═e94da8d0-7501-11eb-2b85-918c1d64a291
# ╠═e9510430-7501-11eb-20f4-3927568402ae
# ╠═304efe70-7532-11eb-0a3f-95c7fb7330ea
# ╠═e9512b40-7501-11eb-3e5e-d33905119a23
# ╠═e95486a0-7501-11eb-07f5-b7fe35295f0d
# ╠═0e227820-74fd-11eb-210e-a5ddcaea4c67
# ╠═41fa654e-7529-11eb-2b56-c9f4736bdd57
# ╠═4f386fe2-7534-11eb-0375-3f932f5a91b0
# ╠═8e8a1cd0-7533-11eb-2712-07dc18427c9c
# ╠═4fe965d0-7533-11eb-023a-e9786c047157
# ╠═35579940-7532-11eb-1fc2-4f8783f77ea2
# ╠═307ec530-752b-11eb-22b8-095fce04407f
# ╠═4a06b850-752b-11eb-1a55-536df758b4b5
# ╠═6ca82580-7529-11eb-0d4d-055b69400a09
# ╠═ea6e53e0-7529-11eb-187a-39825c083f64
# ╠═599666c0-7504-11eb-1cf6-27051856b4c2
# ╠═5826ba10-7518-11eb-23f3-97ca6283475f
# ╠═2c3e7940-7574-11eb-27cb-f7877333d9c7
# ╠═b990cc70-7575-11eb-3195-95e4ad299063
# ╠═80867150-7575-11eb-305c-0d55315a3910
# ╠═ad5cd350-7574-11eb-3527-c780500be432
# ╠═d326541e-7575-11eb-0613-0f5231124969
# ╠═d7ee8000-7574-11eb-0ff7-cd88cef0b663
# ╠═10bf22f2-7574-11eb-3c4b-a5ea4386a4b9
# ╠═48da6320-7574-11eb-3495-5dcbfed43e38
# ╠═4c4fdace-7574-11eb-04f3-d93f8395103f
# ╠═8d888650-756a-11eb-300c-c74a2f186659
# ╠═f10beb22-756c-11eb-3d22-4dc0bb9809e8
# ╠═f2653992-756c-11eb-3605-556902e1182e
# ╠═f26560a0-756c-11eb-238f-b9b3570a017a
# ╠═f265d5d0-756c-11eb-152a-0bd3855a6709
# ╠═43f01e62-7577-11eb-1bae-99f688d3d865
# ╠═f0c07f20-74fc-11eb-2343-ab6e86584e80
# ╠═af096320-757a-11eb-2de3-134aaf3ff12f
# ╠═aecaac70-757a-11eb-2254-9ffd556ad183
# ╠═ae867780-757a-11eb-096e-21097a50e468
# ╠═ae3f0e40-757a-11eb-033b-0773190d2097
# ╠═ade63fe0-757a-11eb-0ac1-c7055311137b
# ╠═be491ad0-7569-11eb-103b-096da0254a1b
# ╠═4f88117e-756b-11eb-2bb1-f7b78687e0b5
# ╠═ef02a310-756b-11eb-121b-ef3fd2c5b1db
# ╠═e77b1b00-756a-11eb-2224-57c43aba9c24
# ╠═b5d74b10-756e-11eb-2d0d-5325fde6dc02
# ╠═bda5bca0-756e-11eb-31e8-47d1397b8f05
# ╠═99d6538e-756c-11eb-395d-e77b53735053
# ╠═73ec58d0-7573-11eb-1a89-c135d41c577d
# ╠═6c47683e-7573-11eb-069b-3bee287d6cfc
# ╠═a83fbb90-7573-11eb-1c32-9907d003363d
# ╠═d7406280-7570-11eb-2b34-257994816bdf
