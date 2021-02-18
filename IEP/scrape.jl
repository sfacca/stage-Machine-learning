### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 5913aa60-689c-11eb-303f-39f989a6bff5
using Catlab, Catlab.CategoricalAlgebra, DataFrames

# ╔═╡ 6f917b50-6d3d-11eb-219f-cb4da1f6d74e
using Pkg

# ╔═╡ 1341adf0-5cf0-11eb-2779-21605d9879c9
using CSTParser

# ╔═╡ c1acf890-5a89-11eb-2b8c-cbde52b367b7
using Match

# ╔═╡ 06ffac70-66f2-11eb-0991-299ba39e2779
include("parse_folder.jl")

# ╔═╡ 3490ace0-6bc8-11eb-1965-7b3cd7c2e152
include("functions_struct.jl")

# ╔═╡ 72e1e620-706f-11eb-0aa3-03b213873e31
function flattenExpr(arr::Array{CSTParser.EXPR,1})::Array{CSTParser.EXPR}
	res = []
	for e in arr
		res = vcat(res, flattenExpr(e))
	end
	res
end

# ╔═╡ 6cd0dc00-706f-11eb-04a6-ab0aa3d1aa20
function get_all_heads(e::Array{CSTParser.EXPR,1})
	[x.head for x in e]
end	

# ╔═╡ 692c6510-706f-11eb-0b96-6126f4dfc70e
function get_all_vals(e::Array{CSTParser.EXPR,1})
	[x.val for x in e]
end	

# ╔═╡ 11575bd0-6d93-11eb-0ee5-975ec04823ab
"""
recursively views expr tree
returns all expresssions e where e.head == input symbol
"""
function find_heads(x::Array{Any,1}, symbol::Symbol)
	res = []
	for i in 1:length(x)
		elem = x[i]
		len = length(res)
		if typeof(x) in [CSTParser.EXPR, Array{Any,1}]
			try
				res = vcat(res, find_heads(elem, symbol))
			catch err
				println("error at element $i")
				println(err)
			end
		end
		#=
		if len < length(res)
			
		else
			println("loop i")
	end=#
	end
	res
end

# ╔═╡ 336b4250-5f28-11eb-0ddf-45e25c4347e2
function get_all_heads(e::CSTParser.EXPR)
	res = [e.head]
	for expr in e
		res = vcat(res, get_all_heads(expr))
	end
	res
end

# ╔═╡ 884be410-5e7d-11eb-0fb3-33fe00da9b49
"""
recursively views expr tree
returns all expresssions e where e.head == input symbol
"""
function find_heads(e::CSTParser.EXPR, head::Symbol)
	if e.head == head
		res = [e]
	else
		res = []
	end
	
	for x in e
		res = vcat(res, find_heads(x,head))
	end
	
	res
end	

# ╔═╡ eae76590-7075-11eb-3c6c-bb2c5eec7d50
#="""
recursively looks for :call expressions
returns called functions
"""
function get_calls(e::CSTParser.EXPR)::Array{NameDef,1}
	[NameDef(x.args[1]) for x in find_heads(e, :call)]
end=#

# ╔═╡ 52b64082-5e81-11eb-3192-5b0f4f436d55
function find_heads(arr::Array{CSTParser.EXPR,1}, head::Symbol)
	res = []
	for x in arr
		res = vcat(res, find_heads(x, head))
	end
	res
end

# ╔═╡ d7ff1c50-5e7f-11eb-01c0-452cc44a4b0a
"""
overloads Base.keys so it works with CSTParser.EXPR
this is required to make findfirst work with CSTParser.EXPR
"""
function Base.keys(e::CSTParser.EXPR)
	return keys(e.args)
end

# ╔═╡ 6094a710-670e-11eb-1d30-8f39c55a2e8d
function get_leaves(e::CSTParser.EXPR)	
	if isnothing(e.args) || isempty(e.args)
		res = e
	else
		res = []
		for exp in e.args
			res = vcat(res, get_leaves(exp))
		end
	end
	res
end

# ╔═╡ b9a11222-6016-11eb-1af2-d36a85e541cc
function get_leaves(arr::Array{CSTParser.EXPR, 1})
	res = []
	for exp in arr
		res = vcat(res, get_leaves(exp))
	end
	res
end		

# ╔═╡ f75f1010-6702-11eb-23c8-ab21487b79cf
function flatten_EXPR(e::CSTParser.EXPR)
	res = [e]
	if isnothing(e.args)
	else
		for arg in e.args
			res = vcat(res, flatten_EXPR(arg))
		end
	end
	res
end

# ╔═╡ 201f5820-6703-11eb-1992-f9571e34cc54
function flatten_EXPR(arr::Array{CSTParser.EXPR, 1})
	res = []
	for exp in arr
		res = vcat(res, flatten_EXPR(exp))
	end
	res
end		

# ╔═╡ 4bec4910-67b5-11eb-0e83-27cbaa39673e
"""
finds both :IDENTIFIER and OP: . of :IDENTIFIER
returns id name or compound name.name
"""
function find_identifier(e::CSTParser.EXPR, i::Int=1)
	#1 sanity checks
	if isnothing(e.args) || isempty(e.args)
		
	end
end
		

# ╔═╡ b8806a30-6809-11eb-08cc-fb1ce0deac24
function scrape_functions(arr::Array{CSTParser.EXPR,1};source::Union{String,Nothing} = nothing)::Array{FunctionContainer,1}
	res = Array{FunctionContainer,1}(undef,0)
	for x in arr
		res = vcat(res, scrape_functions(x;source=source))
	end
	res
end

# ╔═╡ 825457b0-708c-11eb-18a7-9536214439b8


# ╔═╡ a216a460-6fc7-11eb-12a0-e1e30840a06c
function uniqueidx(x::AbstractArray{T}) where T
    uniqueset = Set{T}()
    ex = eachindex(x)
    idxs = Vector{eltype(ex)}()
    for i in ex
        xi = x[i]
        if !(xi in uniqueset)
            push!(idxs, i)
            push!(uniqueset, xi)
        end
    end
    idxs
end

# ╔═╡ 68aa5292-6805-11eb-3e3e-5591d42758b8
"""
called when e.args[i] is globalrefdoc
returns the index containing the actual docs 
or i if it finds none

"""
function getDocs(e::CSTParser.EXPR, i::Int)	
	if length(e.args) > i
		x = findfirst((x)->(x.head == :TRIPLESTRING), e.args)
		if !isnothing(x)
			i = x
		end
	end
	i
end

# ╔═╡ dda9a240-67dc-11eb-3b7e-6149208727a4
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

# ╔═╡ 107d91f0-67d2-11eb-07b3-477719ca9a9c
"""
uses isOP to check if argument expression is a OP: =
"""
function isAssignmentOP(e::CSTParser.EXPR)
	isOP(e,"=")
end

# ╔═╡ 6f394770-67d2-11eb-3678-570594a0b1b5
"""
uses isOP to check if argument expression is a OP: ->
"""
function isArrowOP(e::CSTParser.EXPR)
	isOP(e,"->")
end

# ╔═╡ 12782210-67d5-11eb-3bb0-b3bd1445f95f
"""
uses isOP to check if argument expression is a OP: ::
"""
function isTypedefOP(e::CSTParser.EXPR)
	isOP(e,"::")
end

# ╔═╡ 69ff54b0-67d8-11eb-1081-ebd4a2f72033
"""
uses isOP to check if argument expression is a OP: .
"""
function isDotOP(e::CSTParser.EXPR)
	isOP(e,".")
end

# ╔═╡ f63b728e-67fd-11eb-2ef5-cd69e95763bd
"""
auxiliary function checks wether argument expression has an args parameter that isnt empty
"""
function _checkArgs(e)
	!isnothing(e.args) && !isempty(e.args)
end

# ╔═╡ 6feff650-706f-11eb-2a74-5b0e8bf2d711
function flattenExpr(e::CSTParser.EXPR)::Array{CSTParser.EXPR}
	res = [e]
	if typeof(e.head) == CSTParser.EXPR
		res = vcat(res, flattenExpr(e.head))
	end
	
	if typeof(e.val) == CSTParser.EXPR
		res = vcat(res, flattenExpr(e.val))
	end
		
	if _checkArgs(e)
		for x in e.args
			res = vcat(res, flattenExpr(x))
		end
	end
	res
end

# ╔═╡ 76034a60-706f-11eb-18d5-09140e84abaf
function make_dict(arr::Array{CSTParser.EXPR,1})
	dic = Dict()
	i = 1
	flat = unique(flattenExpr(arr))
	
	for j in 1:length(flat)
		dic[i] = flat[j]
		i = i + 1
	end
	dic
end

# ╔═╡ 8acfccc0-7079-11eb-21ab-b97820f1eb43
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

# ╔═╡ 272e0a80-7077-11eb-2fad-8d8334435308
"""
returns array of namedefs sorted and unique by getName result
"""
function unique_sorted_names(arr::Array{NameDef,1})::Array{NameDef,1}
	names = [getName(x) for x in arr]
	unames = unique(sort(names))
	res = Array{NameDef,1}(undef, length(unames))
	for i in 1:length(res)
		res[i] = arr[findfirst((x)->(x==unames[i]),names)]
	end
	res
end

# ╔═╡ 52857610-7215-11eb-0d11-79a3d56e7f90
function unique_arrays(arr::Array{Array{NameDef,1}})::Array{Array{NameDef,1}}
	#1 turn every array into an array of getnames
	names = getName(arr)
	unames = unique(names)
	res = Array{Array{NameDef,1},1}(undef,length(unames))
	for i in 1:length(res)
		res[i] = arr[findfirst((x)->(x==unames[i]),names)]
	end
	res
end

# ╔═╡ 1919b3a0-6bcb-11eb-3473-991e753c1f31
"""
takes an expr that defines a function adress/name, returns NameDef
"""
function scrapeName(e::CSTParser.EXPR)::NameDef
	#println("scrapename")
	NameDef(e)
end

# ╔═╡ e952d660-6fc6-11eb-3bf0-a706cc57d0a3
"""
gets calls from input expression as array of NameDefs
"""
function get_calls(e::CSTParser.EXPR)::Array{NameDef,1}
	#if count([_checkArgs(x) for x in find_heads(e, :call)])
	if e.head == :function
		tmp = find_heads(e, :call)
		if length(tmp)>1
			tmp = tmp[2:end]
			return unique_sorted_names([scrapeName(x.args[1]) for x in tmp])
		else
			return Array{NameDef,1}(undef, 0)
		end
	else
		unique_sorted_names([scrapeName(x.args[1]) for x in find_heads(e, :call)])
	end
end

# ╔═╡ ca8be250-67c7-11eb-17d2-9f4ba3be11a7
"""
takes an expr that defines a function adress/name, returns NameDef
"""
function OLDscrapeName(e::CSTParser.EXPR)::NameDef
	# is this a module.name pattern?	
	if isDotOP(e)
		NameDef(
			getName(scrapeName(e.args[2])), 
			getName(scrapeName(e.args[1]))
		)
	else
		if e.head == :quotenode
			NameDef(e.args[1].val, nothing)
		else
			NameDef(e.val, nothing)
		end
	end		
end

# ╔═╡ cdf6aa80-6bcb-11eb-350a-a91d1b2015aa
"""
takes an expr that defines inputs, returns array of InputDef
the expr needs to only contain argument definitions in its .args array
:function -> :call function definitions have their function name in the same args
"""
function scrapeInputs(e::CSTParser.EXPR)::Array{InputDef,1}
	println("scrape inputs")
	if !isnothing(e.args) && !isempty(e.args)
		arr = Array{InputDef,1}(undef, length(e.args))
		for i in 1:length(arr)
			# is this a simple param name or is this a :: OP?
			if isTypedefOP(e.args[i])
				println("TYPEDEFOP")
				try
					if length(e.args[i].args)<2
						#println("args < 2")
						#this is a weird ::Type curly thing probably
						arr[i] = InputDef(
							scrapeName(e.args[i].args[1]),
							scrapeName(e.args[i].args[1])
						)
					else
						#println("args > 2")
						arr[i] = InputDef(
						scrapeName(e.args[i].args[1]),
						scrapeName(e.args[i].args[2])
					)
					end
				catch err
					println("error!")
					println(err)
					#println(e.args)
				end
			else
				arr[i] = InputDef(
					scrapeName(e.args[i]), 
					scrapeName(CSTParser.parse("x::Any").args[2])
				)
			end
		end		
	else
		arr = Array{InputDef,1}(undef, 0)
	end
	println("finished scraping inputs")
	arr
end

# ╔═╡ a9fda510-67c6-11eb-227d-b53cf6674516
"""
checks if argument expression defines a function
if so, returns the FuncDef
otherwise, returns nothing
"""
function scrapeFuncDef(e::CSTParser.EXPR)::Union{FuncDef, Nothing}
	# 1 returns FuncDef if e defines function, Nothing if it doesnt
	if isAssignmentOP(e)
		# an assignment operation can be a function definition 
		# if rvalue is a nameless function, defined with an -> operation
		if isArrowOP(e.args[2])
			# e.args contains the lvalue and rvalue of the -> operation
			# we also now know that the lvalue of the assignment operation 
			# is the function name
			println("funcdef?")
			return FuncDef(
				scrapeName(e.args[1]),
				scrapeInputs(e.args[2].args[1]),
				e
			)
		elseif e.args[1].head == :call
			# we're in the name(vars) = block pattern
			# we can run scrapeinputs on the :call, 
			# the first input will actually be the function name			
			tmp = scrapeInputs(e.args[1])
			inputs = length(tmp) > 1 ? tmp[2:end] : Array{InputDef,1}(undef, 0)
			# the function code will be the rvalue of the assignment operation e
			return FuncDef(
				scrapeName(e.args[1].args[1]),
				inputs,
				e				
			)
		end
	elseif e.head == :function
		# this is the basic function name(args) block pattern
		# args[1] could be the call or an :: OP
		if e.args[1].head == :call
			# we're in the name(vars) = block pattern
			# we can run scrapeinputs on the :call, 
			# the first input will actually be the function name			
			tmp = scrapeInputs(e.args[1])
			inputs = length(tmp) > 1 ? tmp[2:end] : Array{InputDef,1}(undef, 0)
			# the function code will be the rvalue of the assignment operation e
			return FuncDef(
				scrapeName(e.args[1].args[1]),
				inputs,
				e# the whole function				
			)
		elseif isTypedefOP(e.args[1])
			# this function defines its output type
			if _checkArgs(e.args[1])&&_checkArgs(e.args[1].args[1])&&e.args[1].args[1].head == :call
				# we're in the name(vars) = block pattern
				# we can run scrapeinputs on the :call, 
				# the first input will actually be the function name			
				tmp = scrapeInputs(e.args[1].args[1])
				inputs = length(tmp) > 1 ? tmp[2:end] : Array{InputDef,1}(undef, 0)
				
				# the function code will be the rvalue of the assignment operation e
				return FuncDef(
					scrapeName(e.args[1].args[1].args[1]),
					inputs,
					e,
					scrapeName(e.args[1].args[2])
				)
			else
				return FuncDef(
					":function's typedef operator didnt have a :call as its leftvalue",
					e					
				)
			end
		end	
	else
		return nothing
	end
	nothing
end	

# ╔═╡ da5dd4b0-6702-11eb-01e7-8b64690b333f
"""
function iterates over EXPR tree, scrapes function definitions and documentation
"""
function scrape_functions(e::CSTParser.EXPR;source::Union{String,Nothing} = nothing)::Array{FunctionContainer,1}
	if _checkArgs(e)#leaves cant be functions
		#println("expr is not a leaf")
		res = Array{FunctionContainer,1}(undef,0)
		docs = nothing
		# iterates over e.args, looking for functions or docs
		for i in 1:length(e.args)
			if e.args[i].head == :globalrefdoc
				#println("found globalrefdoc")
				i = getDocs(e,i)
				docs = isnothing(e.args[i].val) ? "error finding triplestring" : e.args[i].val
			end
			
			tmp = scrapeFuncDef(e.args[i])
			if !isnothing(tmp)
				res = vcat(res, FunctionContainer(tmp,docs,source))
				docs = nothing
			elseif _checkArgs(e.args[i])
				#println("child has args")
				# if e[i] has args, scrapes e[i]
				res = vcat(res, scrape_functions(e.args[i]; source = source))
			end
		end
		return res
	else
		#println("expr is a leaf")
		return Array{FunctionContainer,1}(undef,0)
	end
end

# ╔═╡ e223a880-6d49-11eb-21e5-dd86f6a47534
function scrape_functions_starter(e::CSTParser.EXPR;source::Union{String,Nothing} = nothing)::Array{FunctionContainer,1}
	tmp = scrapeFuncDef(e)
	if isnothing(tmp)
		res = Array{FunctionContainer,1}(undef,0)
	else
		res = [FunctionContainer(tmp,nothing,source)]
	end
	vcat(res, scrape_functions(e;source=source))
end

# ╔═╡ f5055562-6d54-11eb-0e26-afcb4c50d564
function scrape_check(arr::Array{Any,1})
	res = Array{FunctionContainer,1}(undef, 0)
	fails = []
	for i in 1:length(arr)
		x = arr[i]
		if typeof(x) == Tuple{CSTParser.EXPR,String}
			len = length(res)
			try
				res = vcat(res, scrape_functions_starter(x[1]; source = x[2]))
			catch e
				println("scrape number $i errored")
				println(e)
			end
			if len == length(res)
				println("scrape tuple number $i didnt do anything")
				push!(fails, i)
			end
		end
	end
	return res, fails
end

# ╔═╡ e74d330e-680a-11eb-049d-497985c532f7
function scrape(arr::Array{Any,1})::Array{FunctionContainer,1}
	res = Array{FunctionContainer,1}(undef, 0)
	for i in 1:length(arr)
		x = arr[i]
		if typeof(x) == Tuple{CSTParser.EXPR,String}
			len = length(res)
			try
				res = vcat(res, scrape_functions_starter(x[1]; source = x[2]))
			catch e
				println("scrape number $i errored")
				println(e)
			end
			if len == length(res)
				println("scrape tuple number $i didnt do anything")
				println("")
			end
		end
	end
	res
end

# ╔═╡ 88cf83a0-689c-11eb-31af-5dd802ea42a9
function folder_to_scrape(path::String)
	scrape(read_code(path))
end

# ╔═╡ ccaf8f30-67d3-11eb-16ff-f307795a6ad0
"""
takes an expr that defines inputs, returns array of InputDef
the expr needs to only contain argument definitions in its .args array
:function -> :call function definitions have their function name in the same args
"""
function OLDscrapeInputs(e::CSTParser.EXPR)::Array{InputDef,1}
	if !isnothing(e.args) && !isempty(e.args)
		arr = Array{InputDef,1}(undef, length(e.args))
		for i in 1:length(arr)
			# is this a simple param name or is this a :: OP?
			if isTypedefOP(e.args[i])
				arr[i] = InputDef(
					scrapeName(e.args[i].args[1]),
					scrapeName(e.args[i].args[2])
				)
			else
				arr[i] = InputDef(
					scrapeName(e.args[i]), 
					NameDef("Any",nothing)
				)
			end
		end		
	else
		arr = Array{InputDef,1}(undef, 0)
	end
	arr
end

# ╔═╡ Cell order:
# ╠═06ffac70-66f2-11eb-0991-299ba39e2779
# ╠═3490ace0-6bc8-11eb-1965-7b3cd7c2e152
# ╠═5913aa60-689c-11eb-303f-39f989a6bff5
# ╠═6f917b50-6d3d-11eb-219f-cb4da1f6d74e
# ╠═76034a60-706f-11eb-18d5-09140e84abaf
# ╠═72e1e620-706f-11eb-0aa3-03b213873e31
# ╠═6feff650-706f-11eb-2a74-5b0e8bf2d711
# ╠═6cd0dc00-706f-11eb-04a6-ab0aa3d1aa20
# ╠═692c6510-706f-11eb-0b96-6126f4dfc70e
# ╠═11575bd0-6d93-11eb-0ee5-975ec04823ab
# ╠═88cf83a0-689c-11eb-31af-5dd802ea42a9
# ╠═f5055562-6d54-11eb-0e26-afcb4c50d564
# ╠═e74d330e-680a-11eb-049d-497985c532f7
# ╠═1341adf0-5cf0-11eb-2779-21605d9879c9
# ╠═c1acf890-5a89-11eb-2b8c-cbde52b367b7
# ╠═336b4250-5f28-11eb-0ddf-45e25c4347e2
# ╠═884be410-5e7d-11eb-0fb3-33fe00da9b49
# ╠═eae76590-7075-11eb-3c6c-bb2c5eec7d50
# ╠═52b64082-5e81-11eb-3192-5b0f4f436d55
# ╠═d7ff1c50-5e7f-11eb-01c0-452cc44a4b0a
# ╠═6094a710-670e-11eb-1d30-8f39c55a2e8d
# ╠═b9a11222-6016-11eb-1af2-d36a85e541cc
# ╠═f75f1010-6702-11eb-23c8-ab21487b79cf
# ╠═201f5820-6703-11eb-1992-f9571e34cc54
# ╠═4bec4910-67b5-11eb-0e83-27cbaa39673e
# ╠═e223a880-6d49-11eb-21e5-dd86f6a47534
# ╠═da5dd4b0-6702-11eb-01e7-8b64690b333f
# ╠═b8806a30-6809-11eb-08cc-fb1ce0deac24
# ╠═e952d660-6fc6-11eb-3bf0-a706cc57d0a3
# ╠═825457b0-708c-11eb-18a7-9536214439b8
# ╠═272e0a80-7077-11eb-2fad-8d8334435308
# ╠═52857610-7215-11eb-0d11-79a3d56e7f90
# ╠═8acfccc0-7079-11eb-21ab-b97820f1eb43
# ╠═a216a460-6fc7-11eb-12a0-e1e30840a06c
# ╠═68aa5292-6805-11eb-3e3e-5591d42758b8
# ╠═107d91f0-67d2-11eb-07b3-477719ca9a9c
# ╠═6f394770-67d2-11eb-3678-570594a0b1b5
# ╠═12782210-67d5-11eb-3bb0-b3bd1445f95f
# ╠═69ff54b0-67d8-11eb-1081-ebd4a2f72033
# ╠═dda9a240-67dc-11eb-3b7e-6149208727a4
# ╠═a9fda510-67c6-11eb-227d-b53cf6674516
# ╠═f63b728e-67fd-11eb-2ef5-cd69e95763bd
# ╠═1919b3a0-6bcb-11eb-3473-991e753c1f31
# ╠═ca8be250-67c7-11eb-17d2-9f4ba3be11a7
# ╠═cdf6aa80-6bcb-11eb-350a-a91d1b2015aa
# ╠═ccaf8f30-67d3-11eb-16ff-f307795a6ad0
