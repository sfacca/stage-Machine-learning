### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 47636ac0-58fd-11eb-2a11-1df666f2940f
using Pkg

# ╔═╡ 2922f5a0-591e-11eb-2981-b3829eb9cf2d
using Catlab.WiringDiagrams

# ╔═╡ 2e11edf0-591e-11eb-0282-2bb1c8a9dd91
using Catlab.Graphics

# ╔═╡ 2e126320-591e-11eb-3233-336d8b7effe6
using Catlab.Theories

# ╔═╡ 25cc59f0-5905-11eb-1b0c-a3f93544fc0d
include("scrape.jl")

# ╔═╡ 9ef7a370-5905-11eb-21d1-4d8558210a3d
include("view_Expr.jl")

# ╔═╡ 1b4b4fb0-58fe-11eb-04ff-3310a888d337
Pkg.activate(".")

# ╔═╡ 23e1cc30-58fe-11eb-2d99-3df1efd8ebdd
md"1. parse files"

# ╔═╡ 599c5be0-5905-11eb-3fb8-792fb6f02bd3
parsed_funcs = [x[1] for x in read_code("sample")]

# ╔═╡ a4767fb0-5905-11eb-3767-fdac31b14e89
# 2. extract function definitions

# ╔═╡ 7bd5b440-590a-11eb-13c2-3db7b32afff7
function make_Diagram(e::Expr;parent=nothing)
	#1 make box of Expr
	me = nothing
	if !isnothing(parent)
		#1.5 wire box of e to box of parent
	end	
	for x in e.args
		if typeof(x)==Expr && x.head == :function
			#2 run on found expr
			make_Diagram(x, me)
		end
	end
	return me
end

# ╔═╡ 792b1df0-591b-11eb-2059-e3dd49470fde
mutable struct func
	symbol::Symbol
	calls::Array{Symbol,1}
	called_by::Array{Symbol,1}
end

# ╔═╡ 60202d90-591c-11eb-0d18-c74b2eb1b131
filter((x)->(x.head == :function), view_Expr(parsed_funcs[1]))

# ╔═╡ d3ce6f90-591c-11eb-09bd-f7bdbfefd225
calls = filter((x)->(x.head == :call), view_Expr(parsed_funcs[1]))

# ╔═╡ 0f0a50b0-591d-11eb-008c-796c1b1ef934
called =[x.args[1] for x in calls]

# ╔═╡ d89eb4f0-591f-11eb-2d08-ab73486e4452


# ╔═╡ 9c6536c0-591b-11eb-370b-77472efd45d4
function make_struct(funcs::Array{Expr,1})
	res = Array{func,1}(undef,length(funcs))
	for i in 1:length(funcs)
		# for each function		
		called_symbols = [
			x.args[1] for x in filter(
					(x)->(x.head == :call), view_Expr(funcs[i]))
		]	
		res[i] = func(
			called_symbols[1],
			called_symbols[2:end],
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

# ╔═╡ 9e7f7952-591d-11eb-08f6-dd7c3db68079
my_struct = make_struct(parsed_funcs)

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

# ╔═╡ adf40c90-5920-11eb-2d65-f31f9193860a
function make_diagram(structs::Array{func,1})
	res = Array{Box{Symbol},1}(undef, length(structs))
	
	#1 make a box for every function
	for i in 1:length(structs)
		res[i] = Wiring
end

# ╔═╡ Cell order:
# ╠═47636ac0-58fd-11eb-2a11-1df666f2940f
# ╠═1b4b4fb0-58fe-11eb-04ff-3310a888d337
# ╟─23e1cc30-58fe-11eb-2d99-3df1efd8ebdd
# ╠═25cc59f0-5905-11eb-1b0c-a3f93544fc0d
# ╠═599c5be0-5905-11eb-3fb8-792fb6f02bd3
# ╠═9ef7a370-5905-11eb-21d1-4d8558210a3d
# ╠═a4767fb0-5905-11eb-3767-fdac31b14e89
# ╠═7bd5b440-590a-11eb-13c2-3db7b32afff7
# ╠═792b1df0-591b-11eb-2059-e3dd49470fde
# ╠═60202d90-591c-11eb-0d18-c74b2eb1b131
# ╠═d3ce6f90-591c-11eb-09bd-f7bdbfefd225
# ╠═0f0a50b0-591d-11eb-008c-796c1b1ef934
# ╠═d89eb4f0-591f-11eb-2d08-ab73486e4452
# ╠═9c6536c0-591b-11eb-370b-77472efd45d4
# ╠═9e7f7952-591d-11eb-08f6-dd7c3db68079
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
# ╠═adf40c90-5920-11eb-2d65-f31f9193860a
