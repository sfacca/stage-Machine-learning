### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 47636ac0-58fd-11eb-2a11-1df666f2940f
using Pkg

# ╔═╡ c8a16ca0-59bf-11eb-1fa1-1983215b50dc
using Match #used my handle_Expr

# ╔═╡ 15c32f20-59c3-11eb-0d06-8775ac176324
include("view_Expr.jl")

# ╔═╡ 25cc59f0-5905-11eb-1b0c-a3f93544fc0d
include("parse_folder.jl")

# ╔═╡ c3326aa0-5a8a-11eb-0c02-fbe837715974
include("scrape.jl")

# ╔═╡ 1b4b4fb0-58fe-11eb-04ff-3310a888d337
Pkg.activate(".")

# ╔═╡ c19ba242-59bf-11eb-3d60-dfeff5c4698e
Pkg.add("Match")

# ╔═╡ 23e1cc30-58fe-11eb-2d99-3df1efd8ebdd
md"1. parse files"

# ╔═╡ 599c5be0-5905-11eb-3fb8-792fb6f02bd3
parsed_funcs = [x[1] for x in read_code("programs")];#drop source path

# ╔═╡ 58384ad0-5a80-11eb-0884-d59d694b3ac2
scrape_expr(parsed_funcs[2])

# ╔═╡ a4767fb0-5905-11eb-3767-fdac31b14e89
# 2. extract function definitions

# ╔═╡ b7a7bbd0-59c3-11eb-04af-259418d5094e
begin
	total_view = view_Expr.(parsed_funcs);
	total_view = vcat(total_view...)
	0
end

# ╔═╡ 6be1cca0-5a6c-11eb-3a0f-51ef8ff41888
for i in 1:length(total_view)
	if isempty(total_view[i].args)
		println("--------")
		println("index: $i")
		println(total_view[i].args)
	end
	#println(length(x))
end

# ╔═╡ bdcc6932-5a6c-11eb-17be-9169f6f76af9
isempty

# ╔═╡ 5b214060-59c4-11eb-2fd0-c93d18ca52f9
function scrape_Docs(a::Array{Expr,1})
	res = []
	for expr in a
		c = scrape_Docs(expr)
		println(c)#=
		if isnothing(c[1]) && isnothing(c[2])
			#do nothing
	else=#
			vcat(res, c)
		 #end
	end
	res
	#[length(x.args)>0 ? scrape_Docs_alt(x) : nothing for x in a]
end

# ╔═╡ 1e92d1de-5a64-11eb-3c9e-7b45f0977029
scrape_Docs(view_Expr(parsed_funcs[2])[4])

# ╔═╡ 92544240-59aa-11eb-3d8f-91760a512329
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
			

# ╔═╡ 7c0354a0-5a62-11eb-3d3a-bb4f3339dd9e
begin
	global viewed_expr = []
	for x in parsed_funcs
		global viewed_expr = vcat(viewed_expr, view_Expr(x))
	end
end

# ╔═╡ ea0764a0-5a62-11eb-2e18-b137c7258b82
begin 
	global double_view = []
	for x in viewed_expr
		global double_view = vcat(double_view, view_Expr(x))
	end
end	

# ╔═╡ 9c6536c0-591b-11eb-370b-77472efd45d4
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

# ╔═╡ b8964c3e-599c-11eb-35a4-81ba325c50d0
md"""
### docu extraction

if args[1] is (Core.var"@doc") (typeof GlobalRef) -> args[3] is comment to args[4]"""

# ╔═╡ adf40c90-5920-11eb-2d65-f31f9193860a
function make_diagram(structs::Array{func,1})
	res = Array{Box{Symbol},1}(undef, length(structs))
	
	#1 make a box for every function
	for i in 1:length(structs)
		res[i] = Wiring
end

# ╔═╡ 7ddb7140-59b8-11eb-39f8-b39d99f09a3d
Core.var"@doc"

# ╔═╡ Cell order:
# ╠═47636ac0-58fd-11eb-2a11-1df666f2940f
# ╠═1b4b4fb0-58fe-11eb-04ff-3310a888d337
# ╠═c19ba242-59bf-11eb-3d60-dfeff5c4698e
# ╠═c8a16ca0-59bf-11eb-1fa1-1983215b50dc
# ╠═15c32f20-59c3-11eb-0d06-8775ac176324
# ╟─23e1cc30-58fe-11eb-2d99-3df1efd8ebdd
# ╠═25cc59f0-5905-11eb-1b0c-a3f93544fc0d
# ╠═c3326aa0-5a8a-11eb-0c02-fbe837715974
# ╠═599c5be0-5905-11eb-3fb8-792fb6f02bd3
# ╠═58384ad0-5a80-11eb-0884-d59d694b3ac2
# ╠═a4767fb0-5905-11eb-3767-fdac31b14e89
# ╠═b7a7bbd0-59c3-11eb-04af-259418d5094e
# ╠═6be1cca0-5a6c-11eb-3a0f-51ef8ff41888
# ╠═bdcc6932-5a6c-11eb-17be-9169f6f76af9
# ╠═1e92d1de-5a64-11eb-3c9e-7b45f0977029
# ╠═5b214060-59c4-11eb-2fd0-c93d18ca52f9
# ╠═92544240-59aa-11eb-3d8f-91760a512329
# ╠═7c0354a0-5a62-11eb-3d3a-bb4f3339dd9e
# ╠═ea0764a0-5a62-11eb-2e18-b137c7258b82
# ╠═9c6536c0-591b-11eb-370b-77472efd45d4
# ╟─b8964c3e-599c-11eb-35a4-81ba325c50d0
# ╠═adf40c90-5920-11eb-2d65-f31f9193860a
# ╠═7ddb7140-59b8-11eb-39f8-b39d99f09a3d
