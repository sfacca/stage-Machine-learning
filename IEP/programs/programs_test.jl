### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ f3bc5fa0-5724-11eb-06fb-0d0cde8d01f1
using Pkg

# ╔═╡ 6943ce70-5725-11eb-15b7-5b73f22658f5
using Catlab

# ╔═╡ e41d7fb0-572f-11eb-1d50-59b9e7340deb
using PlutoUI

# ╔═╡ 51416280-5728-11eb-23e1-855ba3662075
include("../scrape_wrap.jl")

# ╔═╡ ee2cd600-572e-11eb-25ce-1bbd4763b6dc
include("../parse.jl")

# ╔═╡ 23f1d5b0-5725-11eb-1816-554b10571104
Pkg.activate(".")

# ╔═╡ 75148e5e-5725-11eb-3b69-1dfaaa8a6a97
# catlab, reexport, compat, MLStyle

# ╔═╡ 47f16160-5725-11eb-2208-e9412992c9bf
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ 4bb76a10-5725-11eb-2681-0f0a3b4f31c5
ingredients("programs.jl")

# ╔═╡ aeebbd20-572a-11eb-1242-f1546ed77d6a
Programs

# ╔═╡ 3d24638e-572a-11eb-0759-7db66f68ea5a
code_1 = Scrape.read_code("./");

# ╔═╡ b656bc80-572b-11eb-357e-2da90e3e55f8
function view_Expr(e::Expr)
	res = [e]# singleton array -> vcat is slow
	if !isnothing(e.args)
		for x in e.args
			#println(typeof(x))
			if typeof(x) == Expr
				#println("true")
				res = vcat(res, view_Expr(x))
			end
		end
	end
	res
end

# ╔═╡ d1ce98c0-572b-11eb-0bc5-0566d9a8853c
[x[2] for x in code_1]

# ╔═╡ eb24f490-572b-11eb-30dd-ff83b1bb7284
code_only = [x[1] for x in code_1];

# ╔═╡ 0ea14680-572c-11eb-2488-c581c5878b71
typeof(code_only)

# ╔═╡ fcc10310-572b-11eb-3084-9546d68e62de
code_views = view_Expr.(code_only);

# ╔═╡ 03063530-572f-11eb-096a-91603394e06b
code_2_defs = Parsers.defs(code_views[2]);

# ╔═╡ 201cf460-572f-11eb-03b3-db5cdd7f0f93
typeof(code_2_defs)

# ╔═╡ 277f5db0-572f-11eb-193e-f1a624c86b47
code_2_defs.modc

# ╔═╡ 81857a60-572f-11eb-29c2-5d897c41fd81
typeof(code_2_defs.exprs[1])

# ╔═╡ 3ffb90b0-5730-11eb-3413-f9fa6ad3ebcc
Slider

# ╔═╡ 9719ec30-572f-11eb-32cb-51f8559f1d80
unique([typeof(x) for x in code_2_defs.exprs])

# ╔═╡ bd983380-572f-11eb-091e-67a242fb94fe
@bind exprs_index Slider(1:length(code_2_defs.exprs))

# ╔═╡ 560ecf70-5730-11eb-37ef-b18b64dac286
md"$exprs_index"

# ╔═╡ b69130a0-572f-11eb-0e98-930f3daa18a0
code_2_defs.exprs[exprs_index]

# ╔═╡ 8fe510a0-5731-11eb-3d23-25104aff8fcb
code_2_defs.exprs[exprs_index>1 ? exprs_index - 1 : 1]

# ╔═╡ eb1380b0-5731-11eb-1a42-b70cb17df699
code_2_defs.exprs[exprs_index>2 ? exprs_index - 2 : 1]

# ╔═╡ f2e59bbe-5731-11eb-22d4-91bcd94057e8
code_2_defs.exprs[exprs_index>3 ? exprs_index - 3 : 1]

# ╔═╡ fa09c390-5731-11eb-10e1-97d876790eb0
code_2_defs.exprs[exprs_index>4 ? exprs_index - 4 : 1]

# ╔═╡ 04d96730-5732-11eb-21e2-3564b12cb1a2
code_2_defs.exprs[exprs_index>5 ? exprs_index - 5 : 1]

# ╔═╡ 0bbe6320-5732-11eb-32f7-5d26a92b0cfe
code_2_defs.exprs[exprs_index>6 ? exprs_index - 6 : 1]

# ╔═╡ 117e4000-5732-11eb-3dd6-2f379808ad22
code_2_defs.exprs[exprs_index>7 ? exprs_index - 7 : 1]

# ╔═╡ 195c1ae2-5732-11eb-3543-796c2359a784
code_2_defs.exprs[exprs_index>8 ? exprs_index - 8 : 1]

# ╔═╡ 219f4740-5732-11eb-0e75-172f87f952ed
code_2_defs.exprs[exprs_index>9 ? exprs_index - 9 : 1]

# ╔═╡ 3f3373d0-5732-11eb-3b19-c1d7fa5e0406
code_2_defs.exprs[exprs_index>10 ? exprs_index - 10 : 1]

# ╔═╡ 44e98cb2-5732-11eb-151b-55a8c7cf3af2
code_2_defs.exprs[exprs_index>11 ? exprs_index - 11 : 1]

# ╔═╡ a17ffbc0-5733-11eb-2440-bf6901a2aa02
Programs.unique_symbols(code_2_defs.exprs[exprs_index])

# ╔═╡ efd1930e-5733-11eb-165f-6f9879181436
dump(Programs)

# ╔═╡ afcdd100-5730-11eb-3bf8-a1b845f7945c
#=
149

for g in args(f)      
    block = compile_block(g, vars, state)     
    code = concat_expr(code, block.code)      
    vars = block.outputs       
end       
=#

# ╔═╡ d2713a00-572e-11eb-0c6a-a7ff5f75f857
typeof(code_views[2])

# ╔═╡ 83289fe0-572b-11eb-022a-9b0cce834ae2
code_2 = view_Expr(code_1[1][1])

# ╔═╡ 96ebb370-5733-11eb-3d4e-a556aeaca869


# ╔═╡ Cell order:
# ╠═f3bc5fa0-5724-11eb-06fb-0d0cde8d01f1
# ╠═23f1d5b0-5725-11eb-1816-554b10571104
# ╠═75148e5e-5725-11eb-3b69-1dfaaa8a6a97
# ╠═47f16160-5725-11eb-2208-e9412992c9bf
# ╠═6943ce70-5725-11eb-15b7-5b73f22658f5
# ╠═4bb76a10-5725-11eb-2681-0f0a3b4f31c5
# ╠═aeebbd20-572a-11eb-1242-f1546ed77d6a
# ╠═51416280-5728-11eb-23e1-855ba3662075
# ╠═3d24638e-572a-11eb-0759-7db66f68ea5a
# ╠═b656bc80-572b-11eb-357e-2da90e3e55f8
# ╠═d1ce98c0-572b-11eb-0bc5-0566d9a8853c
# ╠═eb24f490-572b-11eb-30dd-ff83b1bb7284
# ╠═0ea14680-572c-11eb-2488-c581c5878b71
# ╠═fcc10310-572b-11eb-3084-9546d68e62de
# ╠═ee2cd600-572e-11eb-25ce-1bbd4763b6dc
# ╠═03063530-572f-11eb-096a-91603394e06b
# ╠═201cf460-572f-11eb-03b3-db5cdd7f0f93
# ╠═277f5db0-572f-11eb-193e-f1a624c86b47
# ╠═81857a60-572f-11eb-29c2-5d897c41fd81
# ╠═e41d7fb0-572f-11eb-1d50-59b9e7340deb
# ╠═3ffb90b0-5730-11eb-3413-f9fa6ad3ebcc
# ╠═9719ec30-572f-11eb-32cb-51f8559f1d80
# ╟─560ecf70-5730-11eb-37ef-b18b64dac286
# ╠═bd983380-572f-11eb-091e-67a242fb94fe
# ╠═b69130a0-572f-11eb-0e98-930f3daa18a0
# ╠═8fe510a0-5731-11eb-3d23-25104aff8fcb
# ╠═eb1380b0-5731-11eb-1a42-b70cb17df699
# ╠═f2e59bbe-5731-11eb-22d4-91bcd94057e8
# ╠═fa09c390-5731-11eb-10e1-97d876790eb0
# ╠═04d96730-5732-11eb-21e2-3564b12cb1a2
# ╠═0bbe6320-5732-11eb-32f7-5d26a92b0cfe
# ╠═117e4000-5732-11eb-3dd6-2f379808ad22
# ╠═195c1ae2-5732-11eb-3543-796c2359a784
# ╠═219f4740-5732-11eb-0e75-172f87f952ed
# ╠═3f3373d0-5732-11eb-3b19-c1d7fa5e0406
# ╠═44e98cb2-5732-11eb-151b-55a8c7cf3af2
# ╠═a17ffbc0-5733-11eb-2440-bf6901a2aa02
# ╠═efd1930e-5733-11eb-165f-6f9879181436
# ╠═afcdd100-5730-11eb-3bf8-a1b845f7945c
# ╠═d2713a00-572e-11eb-0c6a-a7ff5f75f857
# ╠═83289fe0-572b-11eb-022a-9b0cce834ae2
# ╠═96ebb370-5733-11eb-3d4e-a556aeaca869
