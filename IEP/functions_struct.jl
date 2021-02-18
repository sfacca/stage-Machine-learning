### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 8537b8e0-6886-11eb-220d-772f608c8fec
using CSTParser

# ╔═╡ 920d3300-6bc5-11eb-2d96-d364612ff4f3
struct NameDef
	name::CSTParser.EXPR
	padding::Nothing
	NameDef(n) = new(n, nothing)
end

# ╔═╡ 65518600-6886-11eb-2776-d7ee66912406
#=struct NameDef
	name::String
	mod::Union{String, Nothing}
	NameDef(n::String, m::Union{String, Nothing}) = new(n,m)
	NameDef(n::String) = NameDef(n,nothing)
	NameDef(n::Nothing,m::Nothing) = new("name error", "NAMEDEF ERROR")
end=#

# ╔═╡ 4ee76a40-6bdf-11eb-1e2d-6fb34dcd096c
function getName(e::NameDef)::String
	getName(e.name)
end	

# ╔═╡ a7567990-707c-11eb-35db-11a0c04cf3dc
function getName(arr::Array{NameDef,1})::Array{String,1}
	[getName(x.name) for x in arr]
end

# ╔═╡ 32785c90-709c-11eb-04e5-4518605435bc
function getName(arr::Array{Array{NameDef,1},1})::Array{Array{String,1},1}
	[getName(x) for x in arr]
end

# ╔═╡ d2d34990-707c-11eb-3168-e734a41690fb
function getName(arr::Array{CSTParser.EXPR,1})::Array{String,1}
	[getName(x) for x in arr]
end	

# ╔═╡ 2a158550-6bdd-11eb-0df5-c1730803f3db
"""
takes an expr that defines a function adress/name, returns NameDef
"""
function scrapeName(e::CSTParser.EXPR)::NameDef
	NameDef(e)
end

# ╔═╡ 5488fba0-6bdd-11eb-1962-b5fd1da15c93
"""
after sanity checks, checks wether argument expression is operator op
"""
function isOP(e::CSTParser.EXPR, op::String)
	if !isnothing(e.head) && typeof(e.head) == CSTParser.EXPR
		if !isnothing(e.head.head) && e.head.head == :OPERATOR && e.head.val == op
			true
		else
			false
		end
	else
		false
	end
end

# ╔═╡ 4b5c80b0-6bdd-11eb-19ee-c9402337d564
"""
uses isOP to check if argument expression is a OP: .
"""
function isDotOP(e::CSTParser.EXPR)
	isOP(e,".")
end

# ╔═╡ 2072373e-6bde-11eb-3ea4-adee2653cedb
function getName(e::CSTParser.EXPR)::String
	# is this a module.name pattern?	
	if isDotOP(e)
		#println(e)
		res = string(getName(e.args[1]),".",getName(e.args[2]))	
	elseif e.head == :call
		res = string([x.val for x in flattenExpr(e)])
	else
		if e.head == :quotenode
			res = e.args[1].val
		else
			res = e.val
		end
	end

	isnothing(res) ? "" : res
end	

# ╔═╡ 6b7f3fe2-6886-11eb-3bdf-134b3a0a7c23
function OLDgetName(nd::NameDef)
	isnothing(nd.mod) ? nd.name : string(getName(nd.mod),".",nd.name)
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
	
	FunctionContainer(
		f::FuncDef,
		d::Nothing,
		s::Nothing
	) = new(f,d,s)
	
	FunctionContainer(
		f::FuncDef,
	) = new(f,nothing,nothing)
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

# ╔═╡ 6f878690-712a-11eb-267c-195237396cd0
function isequal(x::NameDef, y::NameDef)
	getName(x)==getName(y)
end

# ╔═╡ 86bde890-712a-11eb-1730-8bd98af43031
function isequal(x::Array{NameDef,1}, y::Array{NameDef,1})
	if length(x)==length(y)
		res = true
		for i in 1:length(x)
			if isequal(x[i], y[i])
			else
				res = false
			end
		end
	else
		res = false
	end
	res
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
# ╠═920d3300-6bc5-11eb-2d96-d364612ff4f3
# ╠═65518600-6886-11eb-2776-d7ee66912406
# ╠═628e2ad0-6887-11eb-21c3-51761a5ac788
# ╠═bb4fe0a0-6887-11eb-0201-4364c087b95f
# ╠═02c618f0-6888-11eb-273c-8f2024774a11
# ╠═21f94f80-6888-11eb-19c4-8333b0af80ee
# ╠═6b7f3fe2-6886-11eb-3bdf-134b3a0a7c23
# ╠═4ee76a40-6bdf-11eb-1e2d-6fb34dcd096c
# ╠═2072373e-6bde-11eb-3ea4-adee2653cedb
# ╠═a7567990-707c-11eb-35db-11a0c04cf3dc
# ╠═32785c90-709c-11eb-04e5-4518605435bc
# ╠═d2d34990-707c-11eb-3168-e734a41690fb
# ╠═2a158550-6bdd-11eb-0df5-c1730803f3db
# ╠═4b5c80b0-6bdd-11eb-19ee-c9402337d564
# ╠═5488fba0-6bdd-11eb-1962-b5fd1da15c93
# ╠═6e995122-6886-11eb-0b2c-61c9bcd6e120
# ╠═81635852-6886-11eb-2c6f-87508e2fb483
# ╠═6f878690-712a-11eb-267c-195237396cd0
# ╠═86bde890-712a-11eb-1730-8bd98af43031
# ╠═47ba9c80-6895-11eb-128c-ff9a08a82bf1
# ╠═ada660b0-6895-11eb-1263-09c7b8b73fbd
# ╠═cf41e280-6886-11eb-1a27-39d38b8bcb76
