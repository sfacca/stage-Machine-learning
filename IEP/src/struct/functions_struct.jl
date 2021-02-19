#=########################################################################
    contains struct definitions for:
        FunctionContainer
        NameDef
        FuncDef
        InputDef

=########################################################################

struct NameDef
	name::CSTParser.EXPR
	padding::Nothing
	NameDef(n) = new(n, nothing)
end

struct InputDef
	name::NameDef
	type::NameDef
	#InputDef(x::NameDef) = new(x, NameDef("Any"))
end

struct FuncDef
	name::NameDef
	inputs::Array{InputDef,1}
	block::CSTParser.EXPR
	output::Union{Nothing,NameDef}
	FuncDef(n::NameDef,i::Array{InputDef,1},b::CSTParser.EXPR,o::NameDef) = new(n,i,b,o)
	FuncDef(n::NameDef,i::Array{InputDef,1},b::CSTParser.EXPR) = new(n,i,b,nothing)
	FuncDef(error::String, block::CSTParser.EXPR) = new(
		NameDef(error,"FUNCDEF_ERROR"),
		Array{InputDef,1}(undef, 0),
		block,
		nothing
	)
end

struct FunctionContainer
	func::FuncDef
	docs::Union{String,Nothing}
	source::Union{String,Nothing}
	
	FunctionContainer(
		f::FuncDef;
		docs::Union{String,Nothing}=nothing,
		source::Union{String,Nothing}=nothing) = new(f,docs,source)
	
	FunctionContainer(
		f::FuncDef,
		d::String,
		s::String
	) = new(f,d,s)
	
	FunctionContainer(
		f::FuncDef,
		d::String,
		s::Nothing
	) = new(f,d,s)
	
	FunctionContainer(
		f::FuncDef,
		d::Nothing,
		s::String
	) = new(f,d,s)
	
	FunctionContainer(
		f::FuncDef,
		d::Nothing,
		s::Nothing
	) = new(f,d,s)
	
	FunctionContainer(
		f::FuncDef,
	) = new(f,nothing,nothing)
end

"FunctionContainer
NameDef
FuncDef
InputDef"

