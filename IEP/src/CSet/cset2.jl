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

# ╔═╡ d3af1dd0-7612-11eb-28fd-05c15df9085e
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

# ╔═╡ 35579940-7532-11eb-1fc2-4f8783f77ea2
# type inference missing

# ╔═╡ 4154a1d2-760d-11eb-3954-6145d523d907
typeof(scr[1].func.block)

# ╔═╡ a9be6de0-75d7-11eb-027f-49bb68554444
data = ACSetType(newSchema, index=[:IsSubClassOf]){Any}()

# ╔═╡ 50c285b0-760d-11eb-24c0-c30fb540c1da
FunctionContainer = IEP.FunctionContainer

# ╔═╡ 8564cbc0-760d-11eb-266c-f309099faedb
getName = IEP.getName

# ╔═╡ 381a00a2-760e-11eb-2bb1-b76c9523e0d1
get_calls = IEP.get_calls

# ╔═╡ b8866fd0-760e-11eb-2170-41050131aa03
IEP.get_all_heads

# ╔═╡ bf989640-760e-11eb-3288-115fd1634927
get_all_heads = IEP.get_all_heads

# ╔═╡ 42843640-760f-11eb-2798-afc9b5de7f35
find_heads = IEP.find_heads

# ╔═╡ 5cc910c0-760f-11eb-1010-6fa5b08fdaf6
get_all_vals = IEP.get_all_vals

# ╔═╡ 1cbffce2-761f-11eb-0c5a-75e5bdcc451c
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
	

# ╔═╡ 6ca5eca0-761b-11eb-2887-45b820d47c11
Symbol(:Function)

# ╔═╡ e1577fc0-7619-11eb-1cfb-1b3800037bd0
function getCalls(fc::FunctionContainer)::Array{String,1}
	getName(get_calls(fc.func.block))
end

# ╔═╡ 21363f90-761b-11eb-087e-a5eb8720d023
function _getHeads(fc::FunctionContainer)::Array{String,1}
	r = get_all_heads(fc.func.block)# returns array of Union(EXPR, Symbol)
	x = Array{String,1}(undef, length(r))
	for i in 1:length(r)
		if typeof(r[i]) == CSTParser.EXPR
			x[i] = string(Symbol(Expr(r[i])))			
		else #it's a Symbol
			x[i] = string(r[i])
		end			
	end
	x
end

# ╔═╡ d6aed700-7617-11eb-0981-85e86669ee57
string(nothing)

# ╔═╡ 7b451a60-7611-11eb-187f-79e8fc4410a8
get_leaves = IEP.get_leaves

# ╔═╡ d6ded7c0-7603-11eb-25bc-49dc125fe657
function function_exists(func::String, data)	
	findfirst((x)->(x==func), data[:,:func])
end

# ╔═╡ 1149e640-7602-11eb-390d-ff23d84222b1
function add_XCalledByY(x::Int, y::Int, data)
	i = add_parts!(data, :XCalledByY, 1)[1]
	data[i, :X] = x	
	data[i, :Y] = y
	i
end

# ╔═╡ 8a0e7eb0-7602-11eb-3025-2736702ea172
function add_calls(func::Union{String, Int}, calls_set::Array{String,1}, data)
	if typeof(func) == String
		i = findfirst((x)->(x == func), data[:,:func])
		if isnothing(i)
			i = add_parts!(data, :Function, 1)[1]
			data[i,:func] = func
		end
		func = i
	end
	
	for call in calls_set
		#1
		i = function_exists(call, data)
		if isnothing(i)
			i = add_parts!(data, :Function, 1)[1]
			data[i,:func] = call
		end
		add_XCalledByY(i, func, data) #func calls call -> call is called by func
	end
end

# ╔═╡ d6200680-7601-11eb-0eb3-f34a4f2d9b0d
function add_AComponentOfB(a::Int, b::Int, data)
	i = add_parts!(data, :AComponentOfB, 1)[1]
	data[i, :A] = a	
	data[i, :B] = b
	i
end

# ╔═╡ 0138f050-761d-11eb-0ad9-3740292cf6f5
function findXYRelation(x::Int,y::Int,typ::String, data)# this is incredibly slow
	if typ == "AComponentOfB"
		ids = findall((a)->(a==x),data[:,:A])
		return findfirst((b)->(b==y), data[ids,:B])
	elseif typ == "XCalledByY"		
		ids = findall((a)->(a==x),data[:,:X])
		return findfirst((b)->(b==y), data[ids,:Y])
	else
		return nothing
	end
end

# ╔═╡ 6491b090-75fc-11eb-3d01-c30a9e9a14ab
function new_Concept(expr::String, data)
	i = add_parts!(data, :Concept, 1)[1]
	data[i, :concept] = expr
	i
end

# ╔═╡ 4f82e980-75fc-11eb-381f-0f2bdf64e801
function concept_exists(conc::String, data)
	findfirst((x)->(x==conc), data[:,:concept])
end

# ╔═╡ da028a20-75fc-11eb-0e8f-8d785633cf8d
function set_IsSubClassOf(index::Int, concept::String, data)
	ind = concept_exists(conc, data)
	if isnothing(ind)
		ind = new_Concept(conc, data)
	end
	data[index, :IsSubClassOf] = ind
end

# ╔═╡ f4f944f0-75fb-11eb-2b50-e7d355b14c6c
function set_ImplementsConc(index::Int, conc::String, data)
	ind = concept_exists(conc, data)
	if isnothing(ind)
		ind = new_Concept(conc, data)
	end
	data[index, :ImplementsConc] = ind
end

# ╔═╡ d2833f70-75fb-11eb-2bcc-c1844360087a
function new_Math_Expression(expr::String, data)
	i = add_parts!(data, :Math_Expression, 1)[1]
	data[i, :math_expression] = lang
	i
end

# ╔═╡ f4472c9e-75f3-11eb-1cfb-1f284f37c7e8
function new_Language(lang::String, data)
	i = add_parts!(data, :Language, 1)[1]
	data[i, :language] = lang
	i
end

# ╔═╡ c7fa5080-75f5-11eb-1308-ab50cea57beb
function new_Unit(lang::String, data)
	i = add_parts!(data, :Unit, 1)[1]
	data[i, :unit] = lang
	i
end

# ╔═╡ f1f5a310-7615-11eb-0408-ef90621b7557
function type_to_value(typ::String)
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
	end
end

# ╔═╡ b6825d10-75fb-11eb-30aa-475921847a0f
function expression_exists(expr::String, data)
	findfirst((x)->(x==expr), data[:,:math_expression])
end

# ╔═╡ 33ce6ee0-75fb-11eb-34d0-bf578458104b
function set_ImplementsExpr(index::Int, expr::String, data)
	ind = expression_exists(expr, data)
	if isnothing(ind)
		ind = new_Math_Expression(expr, data)
	end
	data[index, :ImplementsExpr] = ind
end

# ╔═╡ 4ca18860-75e4-11eb-2801-b5df1165f961
function language_exists(lang::String, data)
	findfirst((x)->(x==lang), data[:,:language])
end

# ╔═╡ 5fdc06d0-75f3-11eb-2bdc-6bd0d23a64a0
function unit_exists(lang::String, data)
	findfirst((x)->(x==lang), data[:,:unit])
end

# ╔═╡ fc1da060-75e6-11eb-240c-45586c68abd3
function _checkTyp(typ::String)::Bool
	typ in ["Code_symbol", "Function","Variable", "Symbol", 
				"Language",  "Math_Expression","Concept", "Unit"]
end

# ╔═╡ 19a2c7e0-75de-11eb-36be-7f287868e6ed
function set_UsesLanguage(typ::String, index::Int, language::String, data)
	if _checkTyp(typ)
		lind = language_exists(language, data)
		if !isnothing(lind)
			data[get_Any(typ, index, data),:UsesLanguage] = lind
		else
			data[get_Any(typ, index, data),:UsesLanguage] = new_Language(language, data)
		end
	else
		throw("typ is not an Ob name")
	end
end

# ╔═╡ c24ba420-7615-11eb-2748-11f390fd6a29
function find_Ob(typ::String, value, data)
	if _checkTyp(typ)
		findfirst((x)->(x==value), data[:,type_to_value(typ)])
	else
		throw("typ is not an Ob name")
	end
end

# ╔═╡ cca3b150-7616-11eb-07d3-cd283f8b8ef3
function create_Ob(typ::String, value::String, data)
	if _checkTyp(typ)
		i = add_parts!(data, Symbol(typ), 1)[1]
		data[i, type_to_value(typ)] = value
		i
	else
		throw("typ is not an Ob name")
	end
end

# ╔═╡ 2f2308e0-75f3-11eb-1a13-f188d5153e9c
function set_Unit(typ::String, index::Int, unit::Union{String,Int}, data)
	if _checkTyp(typ)
		if typeof(unit) == Int
			data[get_Any(typ, index, data), :IsMeasuredIn] = unit
		else
			uni = unit_exists(unit, data)
			if !isnothing(uni)
				data[get_Any(typ, index, data), :IsMeasuredIn] = uni
			else
				data[get_Any(typ, index, data), :IsMeasuredIn] = new_Unit(unit, data)
			end			
		end
	else
		throw("typ is not an Ob name")
	end
end

# ╔═╡ aa410300-75e5-11eb-3386-f5485894969b
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
		throw("typ is not an Ob name")
	end
	res
end

# ╔═╡ 84a86fb0-7604-11eb-2164-3dabcfde5ce8
function add_components(
		anyB::Int, components::Array{String,1}, component_type::String, data
	)
	for comp in components
		#println("does component exist?")
		i = find_Ob(component_type, comp, data)
		if isnothing(i)
			# creating comp
			i = create_Ob(component_type, comp, data)
		end
		#println("adding a component")
		add_AComponentOfB(get_Any(component_type, i, data), anyB, data)
	end
end	

# ╔═╡ 3c77f900-760d-11eb-2573-5d03dea63b7c
function handle_FunctionContainer(fc::FunctionContainer, data)
	println("-----------------------")
	#1 get+add the function name
	println("adding function to data")
	i = function_exists(getName(fc.func.name), data)
	if isnothing(i)
		# we need to add the function
		i = add_parts!(data, :Function, 1)[1]
		data[i, :func] = getName(fc.func.name)
	end
	# i is now the index of the Function
	
	#2 add calls
	println("adding calls")
	calls = getName(get_calls(fc.func.block))
	add_calls(i, calls, data)
	#2.2 remove duplicate XCalledByY	
	#removeDuplicates!("XCalledByY", data)
	
	
	#3 add components
	
	#3.1 add .head components (Code_symbols)
	println("adding head components")
	any_i = get_Any("Function", i, data)
	println("got any_i")
	heads = _getHeads(fc)
	println("actual add")
	add_components(any_i, heads, "Code_symbol", data)
	
	#3.2 add variable components (Variable)
	println("adding variable components")
	vars = [string(get_all_vals(x)) for x in find_heads(fc.func.block, :IDENTIFIER)]
	add_components(any_i, vars, "Variable", data)
	
	#3.3 add Symbol components (they're actually strings)
	#symbs = unique([String(Symbol(Expr(x))) for x in get_leaves(fc.func.block)])
	println("adding symbol components")
	symbs = unique(string.(get_all_vals(fc.func.block)))
	add_components(any_i, symbs, "Symbol", data)
	# 3.4 remove duplicate AComponentOfB
	#removeDuplicates!("AComponentOfB", data)
	
	#4 language is julia
	println("setting language")
	set_UsesLanguage("Function", i, "Julia", data)
	
end		

# ╔═╡ afed1ae0-7613-11eb-1b5d-f9e0d740d3ac
function handle_Scrape(fcs::Array{FunctionContainer,1}, data)
	for i in 1:length(fcs)
		println("handling container $i")
		handle_FunctionContainer(fcs[i], data)
	end
	data
end

# ╔═╡ 9c578650-7613-11eb-039a-9380c9d84cfb
handle_Scrape(scr, data);

# ╔═╡ f43f55e0-761e-11eb-1656-15e7f7dd6683
data[:,:func]

# ╔═╡ be491ad0-7569-11eb-103b-096da0254a1b
present = Presentation()

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
@present newSchema(FreeSchema) begin
	(
		Code_symbol, 
		Function, 
		Variable, 
		Symbol, 
		Language, 
		Math_Expression, 
		Concept, 
		Unit
		)::Ob
	(Any)::Ob
	(value)::Data
	# freeschema has no ⊗
	#(docs)::Data
	

	#relazioni
	#IsCalledBy::Hom(Function, Function)
	Co_occurs::Hom(Any, Any)
	#IsComponentOfFun::Hom(Any, Function)
	#IsComponentOfExpr::Hom(Any, Math_Expression)
	IsMeasuredIn::Hom(Any, Unit)
	ImplementsExpr::Hom(Function, Math_Expression)	
	ImplementsConc::Hom(Function, Concept)
	VERB::Hom(Any,Any) # ?
	IsSubClassOf::Hom(Concept, Concept)
	
	UsesLanguage::Hom(Any, Language)
	
	isLanguage::Hom(Any, Language)
	isMath_Expression::Hom(Any, Math_Expression)
	isConcept::Hom(Any, Concept)
	isUnit::Hom(Any, Unit)	
	isCode_symbol::Hom(Any, Code_symbol)
	isFunction::Hom(Any, Function)
	isVariable::Hom(Any, Variable)
	isSymbol::Hom(Any, Symbol)
	
	# we handle 1 to many relations with auxiliary Obs
	(AComponentOfB, XCalledByY)::Ob
	A::Hom(AComponentOfB, Any)	
	B::Hom(AComponentOfB, Any)
	X::Hom(XCalledByY, Function)
	Y::Hom(XCalledByY, Function)
	
	
	
	#attributi
	language::Attr(Language, value)
	math_expression::Attr(Math_Expression, value)
	concept::Attr(Concept, value)
	unit::Attr(Unit, value)
	code_symbol::Attr(Code_symbol, value)
	func::Attr(Function, value)
	variable::Attr(Variable, value)
	symbol::Attr(Symbol, value)	
	
	
	
end

# ╔═╡ 73ec58d0-7573-11eb-1a89-c135d41c577d
Symbol 

# ╔═╡ 6c47683e-7573-11eb-069b-3bee287d6cfc
TrainDB = present_to_schema(present)

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
# ╠═d3af1dd0-7612-11eb-28fd-05c15df9085e
# ╠═0e227820-74fd-11eb-210e-a5ddcaea4c67
# ╠═41fa654e-7529-11eb-2b56-c9f4736bdd57
# ╠═35579940-7532-11eb-1fc2-4f8783f77ea2
# ╠═8d888650-756a-11eb-300c-c74a2f186659
# ╠═f10beb22-756c-11eb-3d22-4dc0bb9809e8
# ╠═f2653992-756c-11eb-3605-556902e1182e
# ╠═f26560a0-756c-11eb-238f-b9b3570a017a
# ╠═f265d5d0-756c-11eb-152a-0bd3855a6709
# ╠═f0c07f20-74fc-11eb-2343-ab6e86584e80
# ╠═4154a1d2-760d-11eb-3954-6145d523d907
# ╠═a9be6de0-75d7-11eb-027f-49bb68554444
# ╠═50c285b0-760d-11eb-24c0-c30fb540c1da
# ╠═8564cbc0-760d-11eb-266c-f309099faedb
# ╠═381a00a2-760e-11eb-2bb1-b76c9523e0d1
# ╠═b8866fd0-760e-11eb-2170-41050131aa03
# ╠═bf989640-760e-11eb-3288-115fd1634927
# ╠═42843640-760f-11eb-2798-afc9b5de7f35
# ╠═5cc910c0-760f-11eb-1010-6fa5b08fdaf6
# ╠═3c77f900-760d-11eb-2573-5d03dea63b7c
# ╠═1cbffce2-761f-11eb-0c5a-75e5bdcc451c
# ╠═6ca5eca0-761b-11eb-2887-45b820d47c11
# ╠═e1577fc0-7619-11eb-1cfb-1b3800037bd0
# ╠═21363f90-761b-11eb-087e-a5eb8720d023
# ╠═d6aed700-7617-11eb-0981-85e86669ee57
# ╠═7b451a60-7611-11eb-187f-79e8fc4410a8
# ╠═84a86fb0-7604-11eb-2164-3dabcfde5ce8
# ╠═8a0e7eb0-7602-11eb-3025-2736702ea172
# ╠═d6ded7c0-7603-11eb-25bc-49dc125fe657
# ╠═1149e640-7602-11eb-390d-ff23d84222b1
# ╠═d6200680-7601-11eb-0eb3-f34a4f2d9b0d
# ╠═0138f050-761d-11eb-0ad9-3740292cf6f5
# ╠═da028a20-75fc-11eb-0e8f-8d785633cf8d
# ╠═33ce6ee0-75fb-11eb-34d0-bf578458104b
# ╠═f4f944f0-75fb-11eb-2b50-e7d355b14c6c
# ╠═6491b090-75fc-11eb-3d01-c30a9e9a14ab
# ╠═4f82e980-75fc-11eb-381f-0f2bdf64e801
# ╠═19a2c7e0-75de-11eb-36be-7f287868e6ed
# ╠═d2833f70-75fb-11eb-2bcc-c1844360087a
# ╠═f4472c9e-75f3-11eb-1cfb-1f284f37c7e8
# ╠═c7fa5080-75f5-11eb-1308-ab50cea57beb
# ╠═c24ba420-7615-11eb-2748-11f390fd6a29
# ╠═cca3b150-7616-11eb-07d3-cd283f8b8ef3
# ╠═f1f5a310-7615-11eb-0408-ef90621b7557
# ╠═2f2308e0-75f3-11eb-1a13-f188d5153e9c
# ╠═b6825d10-75fb-11eb-30aa-475921847a0f
# ╠═4ca18860-75e4-11eb-2801-b5df1165f961
# ╠═5fdc06d0-75f3-11eb-2bdc-6bd0d23a64a0
# ╠═aa410300-75e5-11eb-3386-f5485894969b
# ╠═fc1da060-75e6-11eb-240c-45586c68abd3
# ╠═afed1ae0-7613-11eb-1b5d-f9e0d740d3ac
# ╠═9c578650-7613-11eb-039a-9380c9d84cfb
# ╠═f43f55e0-761e-11eb-1656-15e7f7dd6683
# ╠═be491ad0-7569-11eb-103b-096da0254a1b
# ╠═ef02a310-756b-11eb-121b-ef3fd2c5b1db
# ╠═e77b1b00-756a-11eb-2224-57c43aba9c24
# ╠═b5d74b10-756e-11eb-2d0d-5325fde6dc02
# ╠═bda5bca0-756e-11eb-31e8-47d1397b8f05
# ╠═99d6538e-756c-11eb-395d-e77b53735053
# ╠═73ec58d0-7573-11eb-1a89-c135d41c577d
# ╠═6c47683e-7573-11eb-069b-3bee287d6cfc
# ╠═a83fbb90-7573-11eb-1c32-9907d003363d
# ╠═d7406280-7570-11eb-2b34-257994816bdf
