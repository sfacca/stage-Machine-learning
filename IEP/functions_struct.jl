### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 8537b8e0-6886-11eb-220d-772f608c8fec
using CSTParser

# ╔═╡ 65518600-6886-11eb-2776-d7ee66912406
struct NameDef
	name::String
	mod::Union{String, Nothing}
	NameDef(n::String, m::Union{String, Nothing}) = new(n,m)
	NameDef(n::String) = NameDef(n,nothing)
	NameDef(n::Nothing,m::Nothing) = new("name error", "NAMEDEF ERROR")
end

# ╔═╡ 828c5280-6887-11eb-2541-8f3b335b070c
CSTParser.EXPR(:NOTHING,Array{CSTParser.EXPR,1}(undef,0))

# ╔═╡ 6b7f3fe2-6886-11eb-3bdf-134b3a0a7c23
function getName(nd::NameDef)
	isnothing(nd.mod) ? nd.name : string(nd.mod,".",nd.name)
end

# ╔═╡ 81635852-6886-11eb-2c6f-87508e2fb483
struct InputDef
	name::NameDef
	type::NameDef
	#InputDef(x::NameDef) = new(x, NameDef("Any"))
end

# ╔═╡ 6e995122-6886-11eb-0b2c-61c9bcd6e120
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

# ╔═╡ 41bd3f40-6886-11eb-04de-79b43888982a
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
		
end

# ╔═╡ 628e2ad0-6887-11eb-21c3-51761a5ac788
"""
getter for code block
"""
function getCode(fc::FunctionContainer)::CSTParser.EXPR
	getCode(fd.func)
end

# ╔═╡ 02c618f0-6888-11eb-273c-8f2024774a11
function getInputs(fc::FunctionContainer)::Array{InputDef,1}
	getInputs(fc.func)
end

# ╔═╡ bb4fe0a0-6887-11eb-0201-4364c087b95f
"""
getter for code block
"""
function getCode(fd::FuncDef)::CSTParser.EXPR
	fd.block
end

# ╔═╡ 21f94f80-6888-11eb-19c4-8333b0af80ee
function getInputs(fd::FuncDef)::Array{InputDef,1}
	fd.inputs
end

# ╔═╡ 47ba9c80-6895-11eb-128c-ff9a08a82bf1
function Base.isless(a::NameDef, b::NameDef)
	isless(getName(a), getName(b))
end

# ╔═╡ ada660b0-6895-11eb-1263-09c7b8b73fbd
#=function Base.convert(::Type{InputDef}, x::NameDef)::InputDef
	InputDef(x,NameDef("Any"))
	=#
	

# ╔═╡ cf41e280-6886-11eb-1a27-39d38b8bcb76
"structs InputDef, FuncDef, FunctionContainer, NameDef and function getName(NameDef) defined"

# ╔═╡ Cell order:
# ╠═8537b8e0-6886-11eb-220d-772f608c8fec
# ╠═41bd3f40-6886-11eb-04de-79b43888982a
# ╠═65518600-6886-11eb-2776-d7ee66912406
# ╠═828c5280-6887-11eb-2541-8f3b335b070c
# ╠═628e2ad0-6887-11eb-21c3-51761a5ac788
# ╠═bb4fe0a0-6887-11eb-0201-4364c087b95f
# ╠═02c618f0-6888-11eb-273c-8f2024774a11
# ╠═21f94f80-6888-11eb-19c4-8333b0af80ee
# ╠═6b7f3fe2-6886-11eb-3bdf-134b3a0a7c23
# ╠═6e995122-6886-11eb-0b2c-61c9bcd6e120
# ╠═81635852-6886-11eb-2c6f-87508e2fb483
# ╠═47ba9c80-6895-11eb-128c-ff9a08a82bf1
# ╠═ada660b0-6895-11eb-1263-09c7b8b73fbd
# ╠═cf41e280-6886-11eb-1a27-39d38b8bcb76
