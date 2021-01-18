### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 47636ac0-58fd-11eb-2a11-1df666f2940f
using Pkg

# ╔═╡ c8a16ca0-59bf-11eb-1fa1-1983215b50dc
using Match #used my handle_Expr

# ╔═╡ 2922f5a0-591e-11eb-2981-b3829eb9cf2d
using Catlab.WiringDiagrams

# ╔═╡ 2e11edf0-591e-11eb-0282-2bb1c8a9dd91
using Catlab.Graphics

# ╔═╡ 2e126320-591e-11eb-3233-336d8b7effe6
using Catlab.Theories

# ╔═╡ 15c32f20-59c3-11eb-0d06-8775ac176324
include("view_Expr.jl")

# ╔═╡ 25cc59f0-5905-11eb-1b0c-a3f93544fc0d
include("scrape.jl")

# ╔═╡ 1b4b4fb0-58fe-11eb-04ff-3310a888d337
Pkg.activate(".")

# ╔═╡ c19ba242-59bf-11eb-3d60-dfeff5c4698e
Pkg.add("Match")

# ╔═╡ 22b4a150-59c3-11eb-1b55-09d54d764919
view_Expr

# ╔═╡ 23e1cc30-58fe-11eb-2d99-3df1efd8ebdd
md"1. parse files"

# ╔═╡ 599c5be0-5905-11eb-3fb8-792fb6f02bd3
parsed_funcs = [x[1] for x in read_code("programs")];#drop source path

# ╔═╡ a4767fb0-5905-11eb-3767-fdac31b14e89
# 2. extract function definitions

# ╔═╡ 8a9f3b30-59a1-11eb-3cb2-651336a0be7e
function scrape_docs(arr::Array{Expr,1}; res=[])
	res = []
	asdf = Core.var"@doc"
	for expr in arr
		for arg in expr.args
			println(arg)
			if arg == asdf
				push!(res, expr)
			end
		end
	end
	res
end

# ╔═╡ f3396440-59a6-11eb-0376-ed219e6a6d25
macrocalls = filter((x)->(x.head== :macrocall), view_Expr(parsed_funcs[2]));

# ╔═╡ 75d96ec0-59c7-11eb-0f94-05de1211c596
begin 
	full_macrocalls = nothing
	for x in parsed_funcs
		if isnothing(full_macrocalls)
			full_macrocalls = filter((x)->(x.head== :macrocall), view_Expr(x))
		else
			full_macrocalls = vcat(full_macrocalls, filter((x)->(x.head== :macrocall), view_Expr(x)))
		end
	end
end

# ╔═╡ d046d8c0-59c7-11eb-2560-f1a22412e4b0
size(full_macrocalls)

# ╔═╡ b7a7bbd0-59c3-11eb-04af-259418d5094e
total_view = view_Expr.(parsed_funcs);

# ╔═╡ b504eb50-59a0-11eb-1a7f-d7d37db76632
functions = filter((x)->(x.head == :function), view_Expr(parsed_funcs[2]));

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
			

# ╔═╡ 9c1157e0-59bf-11eb-232a-fffde20e5eca
function handle_Content(e::Expr)
	@match e.head begin
		:function => get_inputs(e)
		_ => e
	end
end

# ╔═╡ 29e251f0-59b6-11eb-2be6-6d4900a29093
function scrape_Docs(e::Expr)
	#1 find the Core.var"@doc"
	res = (docs = nothing, content = nothing)
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

# ╔═╡ df9d4bc0-59c1-11eb-2713-83f7273bd56f
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

# ╔═╡ 1e0e1920-59c2-11eb-19c5-53d9914b2a23
scrape_Docs_alt.(macrocalls)

# ╔═╡ 5b214060-59c4-11eb-2fd0-c93d18ca52f9
function scrape_Docs(a::Array{Expr,1})
	[length(x.args)>0 ? scrape_Docs_alt(x) : nothing for x in a]
end

# ╔═╡ a1376c20-59c7-11eb-04bc-fb6da6c5d76b
scrape_Docs(full_macrocalls)

# ╔═╡ 055e4870-59c0-11eb-39e0-0ba7772237f0
scrape_Docs.(macrocalls)

# ╔═╡ 921e6660-59c4-11eb-1358-e9f902945318
total_scrape = scrape_Docs.(total_view)

# ╔═╡ 1b9a1ba0-59b1-11eb-1fc7-d1c681f92c63
functions_with_inputs = get_inputs.(functions)

# ╔═╡ 9fdca5a0-599c-11eb-1587-3dc3cb5e8ecf
parsed_funcs[7].args

# ╔═╡ e0cf8a02-599c-11eb-1d23-f53ab2b67060
parsed_funcs[7].args[3]

# ╔═╡ acafcc50-599a-11eb-02fe-8d50220632f3
parsed_funcs[7].args[4]

# ╔═╡ dbcca670-599a-11eb-06e9-67cd1aac7e6e
parsed_funcs[20].args[1]

# ╔═╡ d3ce6f90-591c-11eb-09bd-f7bdbfefd225
calls = filter((x)->(x.head == :call), view_Expr(parsed_funcs[2]))

# ╔═╡ 0f0a50b0-591d-11eb-008c-796c1b1ef934
called =[x.args[1] for x in calls]

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

# ╔═╡ d38b3350-5990-11eb-11c6-3d1cc655cc59
println("divider")

# ╔═╡ 4b651a70-598d-11eb-0638-bfbf918b9178
typeof(parsed_funcs[1].args[1])

# ╔═╡ 08e8e280-5983-11eb-2971-cbf8601f002d
parsed_funcs[1].args

# ╔═╡ 2e121502-591e-11eb-1d41-9345a894fe39
import Catlab.Graphics: Graphviz

# ╔═╡ bfef0b50-591d-11eb-310a-9b5e87d5c6ea
#1 create a box for each symbol

# ╔═╡ 38276950-591e-11eb-2c55-b326369b5f95
FreeBiproductCategory

# ╔═╡ 561c3700-591f-11eb-27c7-2321f6e14865
typeof(WiringDiagram([:A], [:B]))

# ╔═╡ a2dbee40-5920-11eb-0613-11dce3e3b56e
show_diagram(d::WiringDiagram) = to_graphviz(d,
  orientation=LeftToRight,
  labels=true, label_attr=:xlabel,
  node_attrs=Graphviz.Attributes(
    :fontname => "Courier",
  ),
  edge_attrs=Graphviz.Attributes(
    :fontname => "Courier",
  )
)

# ╔═╡ 896909c0-5920-11eb-0756-551f446be440
f = Box(:f, [:A], [:B])

# ╔═╡ c51bc890-5920-11eb-1ef6-6765f43250c9
typeof(f)

# ╔═╡ 8aaaffa0-5920-11eb-192c-716cf2c5f3d3
g = Box(:g, [:B], [:C])

# ╔═╡ 8aab4dc0-5920-11eb-1eb8-d559e1ca2c92
h = Box(:h, [:C], [:D])

# ╔═╡ 725c4fd0-5920-11eb-040a-8bdb64613d66
d = WiringDiagram([:A], [:C])

# ╔═╡ 74a2e470-5920-11eb-0173-9b9cc67c7e2d
fv = add_box!(d, f)

# ╔═╡ 3edb3bc0-5921-11eb-2b97-27e99c3412c4
typeof(fv)

# ╔═╡ 74a33292-5920-11eb-2fd0-6b634d577451
gv = add_box!(d, g)

# ╔═╡ 74a380b0-5920-11eb-130a-5577e1f323cd
add_wires!(d, [
  (input_id(d),1) => (fv,1),
  (fv,1) => (gv,1),
  (gv,1) => (output_id(d),1),
])

# ╔═╡ 74a94d10-5920-11eb-032f-114c321eb55f
nboxes(d)

# ╔═╡ 978910de-5920-11eb-140d-7364338b0e23
show_diagram(d)

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
# ╠═22b4a150-59c3-11eb-1b55-09d54d764919
# ╟─23e1cc30-58fe-11eb-2d99-3df1efd8ebdd
# ╠═25cc59f0-5905-11eb-1b0c-a3f93544fc0d
# ╠═599c5be0-5905-11eb-3fb8-792fb6f02bd3
# ╠═a4767fb0-5905-11eb-3767-fdac31b14e89
# ╠═8a9f3b30-59a1-11eb-3cb2-651336a0be7e
# ╠═f3396440-59a6-11eb-0376-ed219e6a6d25
# ╠═75d96ec0-59c7-11eb-0f94-05de1211c596
# ╠═d046d8c0-59c7-11eb-2560-f1a22412e4b0
# ╠═a1376c20-59c7-11eb-04bc-fb6da6c5d76b
# ╠═29e251f0-59b6-11eb-2be6-6d4900a29093
# ╠═df9d4bc0-59c1-11eb-2713-83f7273bd56f
# ╠═9c1157e0-59bf-11eb-232a-fffde20e5eca
# ╠═055e4870-59c0-11eb-39e0-0ba7772237f0
# ╠═1e0e1920-59c2-11eb-19c5-53d9914b2a23
# ╠═b7a7bbd0-59c3-11eb-04af-259418d5094e
# ╠═921e6660-59c4-11eb-1358-e9f902945318
# ╠═5b214060-59c4-11eb-2fd0-c93d18ca52f9
# ╠═b504eb50-59a0-11eb-1a7f-d7d37db76632
# ╠═92544240-59aa-11eb-3d8f-91760a512329
# ╠═1b9a1ba0-59b1-11eb-1fc7-d1c681f92c63
# ╠═9fdca5a0-599c-11eb-1587-3dc3cb5e8ecf
# ╠═e0cf8a02-599c-11eb-1d23-f53ab2b67060
# ╠═acafcc50-599a-11eb-02fe-8d50220632f3
# ╠═dbcca670-599a-11eb-06e9-67cd1aac7e6e
# ╠═d3ce6f90-591c-11eb-09bd-f7bdbfefd225
# ╠═0f0a50b0-591d-11eb-008c-796c1b1ef934
# ╠═9c6536c0-591b-11eb-370b-77472efd45d4
# ╠═d38b3350-5990-11eb-11c6-3d1cc655cc59
# ╠═4b651a70-598d-11eb-0638-bfbf918b9178
# ╠═08e8e280-5983-11eb-2971-cbf8601f002d
# ╠═2922f5a0-591e-11eb-2981-b3829eb9cf2d
# ╠═2e11edf0-591e-11eb-0282-2bb1c8a9dd91
# ╠═2e121502-591e-11eb-1d41-9345a894fe39
# ╠═2e126320-591e-11eb-3233-336d8b7effe6
# ╠═bfef0b50-591d-11eb-310a-9b5e87d5c6ea
# ╠═38276950-591e-11eb-2c55-b326369b5f95
# ╠═561c3700-591f-11eb-27c7-2321f6e14865
# ╠═a2dbee40-5920-11eb-0613-11dce3e3b56e
# ╠═896909c0-5920-11eb-0756-551f446be440
# ╠═c51bc890-5920-11eb-1ef6-6765f43250c9
# ╠═8aaaffa0-5920-11eb-192c-716cf2c5f3d3
# ╠═8aab4dc0-5920-11eb-1eb8-d559e1ca2c92
# ╠═725c4fd0-5920-11eb-040a-8bdb64613d66
# ╠═74a2e470-5920-11eb-0173-9b9cc67c7e2d
# ╠═3edb3bc0-5921-11eb-2b97-27e99c3412c4
# ╠═74a33292-5920-11eb-2fd0-6b634d577451
# ╠═74a380b0-5920-11eb-130a-5577e1f323cd
# ╠═74a94d10-5920-11eb-032f-114c321eb55f
# ╠═978910de-5920-11eb-140d-7364338b0e23
# ╟─b8964c3e-599c-11eb-35a4-81ba325c50d0
# ╠═adf40c90-5920-11eb-2d65-f31f9193860a
# ╠═7ddb7140-59b8-11eb-39f8-b39d99f09a3d
