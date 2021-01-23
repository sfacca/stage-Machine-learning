### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 1341adf0-5cf0-11eb-2779-21605d9879c9
using CSTParser

# ╔═╡ c1acf890-5a89-11eb-2b8c-cbde52b367b7
using Match

# ╔═╡ 65b70120-5caa-11eb-05a9-bd4239022c3e
include("corpus_struct.jl")

# ╔═╡ 6a656b30-5cf0-11eb-37f3-a3c326b4c4b0
function scrape_expr(e::CSTParser.EXPR; d = nothing)
	if e.head in [:function, :struct, :abstract] || !isnothing(d)
		res = [(docs = d, type = e.head, content = handle_Content(e))]
	else
		res = []
	end
	docs = nothing
	# CSTParser.EXPR is iterable, needs no checks on args
	for subexpr in e
		if doc
			docs = e
		else
		res = vcat(res, scrape_expr(e, d))
		docs = nothing
	end
	res
end

# ╔═╡ 069ea9e0-5cf0-11eb-3d1b-2149bf325319
"""
fuynction to scrape from CSTParser.EXPR
"""
function scrape_Docs(e::CSTParser.EXPR)
	# CSTParser.EXPR is iterable, no need for .args size checks	
	res = ()
end

# ╔═╡ 62f8bd22-5a89-11eb-3158-cba0a98fb785
"""
:function Expr handler

returns tuple (name, input_variables)
"""
function get_inputs(e::Expr)
	# assumtion: e.head == :function
	# 1 find the :call
	name = nothing
	params = []
	call_found = false
	tmp = e
	call = nothing
	while !call_found
		if tmp.args[1].head == :call
			println(tmp.args[1])
			call_found = true
			call = tmp.args[1]
		else
			if typeof(tmp.args[1]) == Expr
				tmp = tmp.args[1]
			else
				call_found = true
				call = nothing
			end
		end
	end
	
	println(call)
	if !isnothing(call)
		if typeof(call.args[1]) == Symbol
			println("found name")
			name = call.args[1]
		else
			name = nothing
		end
		# we scrape :: and :parameters heads			
		for arg in call.args
			if typeof(arg)== Expr 
				if arg.head == :(::) || arg.head == :parameters 
					push!(params, arg)
				end
			end
		end
	end
	#=println("""function $name has inputs: $(
		string([[x.args[1], "of type", x.args[2]] for x in filter(x->(length(x.args)>1),params)]) 
		)""")=#
	(name = name, input_variables = [x.head == :parameters ? x : (name = x.args[1], type = x.args[2]) for x in params])
end

# ╔═╡ 5e799da0-5a89-11eb-28a3-6fc5463b63e4
"""
middleware to handle different kind of Expr differently
"""
function handle_Content(e::Expr)
	@match e.head begin
		:function => get_inputs(e)
		_ => e
	end
end

# ╔═╡ db681500-5a5a-11eb-0de7-fd488e8ecb46
"""
function iterates over input Expr and its subexpr, returns array of every function, abstract, struct and of every expression with doicumentation

output format is array of (docs::Unions{String,Nothing}, type::Symbol, content)
"""
function scrape_expr(e::Expr; d = nothing)
	if e.head in [:function, :struct, :abstract] || !isnothing(d)
		res = [(docs = d, type = e.head, content = handle_Content(e))]
	else
		res = []
	end
	docs = nothing
	#doc = GlobalRef(Core, Symbol("@doc"))
	if !isempty(e.args)
		for i in 1:length(e.args)
			if e.args[i] == GlobalRef(Core, Symbol("@doc"))
				docs = e.args[findfirst(
						(x)->(typeof(x)==String),
						e.args[i:end]
						)]
			elseif typeof(e.args[i])==Expr
				res = vcat(res, scrape_expr(e.args[i],d= docs))
				docs = nothing# attaches docs to next expression, then clears docs
			end
		end	
	end
	res
end

# ╔═╡ 5af37660-5a84-11eb-39b1-7bcd6c24d815
"""
finds documentation on input expressions
"""
function scrape_Docs(e::Expr)
	#1 find the Core.var"@doc"
	res = (docs = nothing, content = nothing, type = e.head)
	tmp = e
	found_doc = false
	doc = GlobalRef(Core, Symbol("@doc"))
	while !found_doc
		if tmp.args[1] == doc
			
			found_doc = true
			if typeof(tmp.args[end]) == Expr
				res = (
					docs = tmp.args[minimum([3, length(tmp.args)])],
					content = handle_Content(tmp.args[end]),
					type = tmp.args[end].head
				)
			else
				res = (
					docs = tmp.args[minimum([3, length(tmp.args)])],
					content = tmp.args[end],
					type = typeof(tmp.args[end])				
				)
			end
		else
			if typeof(tmp.args[1]) == Expr
				tmp = tmp.args[1]
			else
				found_doc = true
			end
		end
	end
	res
end

# ╔═╡ 5a8dbd70-5a89-11eb-104f-192cb5f012d7
"""
finds documentation on input expressions
"""
function scrape_Docs_alt(e::Expr)
	#1 find the Core.var"@doc"
	res = (docs = nothing, content = nothing)
	tmp = e
	found_doc = false
	doc = GlobalRef(Core, Symbol("@doc"))
	if tmp.args[1] == doc

		found_doc = true
		if typeof(tmp.args[end]) == Expr
			res = (
				docs = tmp.args[minimum([3, length(tmp.args)])],
				content = handle_Content(tmp.args[end]),
				type = tmp.args[end].head
			)
		else
			res = (
				docs = tmp.args[minimum([3, length(tmp.args)])],
				content = tmp.args[end],
				type = typeof(tmp.args[end])				
			)
		end
	else
		if typeof(tmp.args[1]) == Expr
			tmp = tmp.args[1]
		else
			found_doc = true
		end
	end
	res
end

# ╔═╡ 70a65360-5a89-11eb-2898-37b1b52852bf
function make_struct(funcs::Array{Expr,1})
	res = Array{func,1}(undef,length(funcs))
	for i in 1:length(funcs)
		# for each function		
		called_symbols = [
			x.args[1] for x in filter(
					(x)->(x.head == :call), view_Expr(funcs[i])
				)
		]
		println([
				(x, typeof(x)) for x in
			filter(
					(x)->(typeof(x) != Symbol), called_symbols
				)
			])	
		res[i] = func(
			length(called_symbols)>=1 ? called_symbols[1] : nothing,
			length(called_symbols)>1 ? called_symbols[2:end] : [],
			[]
		)
	end
	# set called_bys
	for i in res
		for j in res
			if i.symbol in j.calls
				push!(i.called_by, j.symbol)
			end
		end
	end
	res
end

# ╔═╡ Cell order:
# ╠═65b70120-5caa-11eb-05a9-bd4239022c3e
# ╠═db681500-5a5a-11eb-0de7-fd488e8ecb46
# ╠═6a656b30-5cf0-11eb-37f3-a3c326b4c4b0
# ╠═5af37660-5a84-11eb-39b1-7bcd6c24d815
# ╠═1341adf0-5cf0-11eb-2779-21605d9879c9
# ╠═069ea9e0-5cf0-11eb-3d1b-2149bf325319
# ╠═5a8dbd70-5a89-11eb-104f-192cb5f012d7
# ╠═c1acf890-5a89-11eb-2b8c-cbde52b367b7
# ╠═5e799da0-5a89-11eb-28a3-6fc5463b63e4
# ╠═62f8bd22-5a89-11eb-3158-cba0a98fb785
# ╠═70a65360-5a89-11eb-2898-37b1b52852bf
