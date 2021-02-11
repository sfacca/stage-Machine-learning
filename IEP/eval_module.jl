### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 5d2ad4e0-6c00-11eb-29e0-5f97083a4ed4
using CSTParser

# ╔═╡ 49216ee0-6c0b-11eb-2054-f1b1e32ac42a
using Pkg

# ╔═╡ c89f7be2-6c0a-11eb-0e9f-8de3a79a3920
#all functions, all structs

# ╔═╡ a693e612-6c0c-11eb-18b5-2724ec517bc0
function eval_array(arr::Array{Any,1})
	res = Array{Bool,1}(undef, length(arr))
	for i in 1:length(res)
		try
			eval(Expr(arr[i]))
			res[i] = true
		catch e
			println(e)
			res[i] = false
		end
	end
	res
end
			

# ╔═╡ c93572f0-6c0d-11eb-2979-539aeaafbb31
function eval_module(mod::String)	
	raw_parse = read_code(string(Pkg.dir(mod),"/src"))
	code_only = [x[1] for x in raw_parse]
	modules = find_heads(code_only, :module)
	structs = find_heads(code_only, :struct)
	functions = find_heads(code_only, :function)
	results = vcat(eval_array(modules), eval_array(structs), eval_array(functions))
	sources = vcat(structs, functions)
	return (sources = sources, results = results)
end

# ╔═╡ Cell order:
# ╠═5d2ad4e0-6c00-11eb-29e0-5f97083a4ed4
# ╠═c89f7be2-6c0a-11eb-0e9f-8de3a79a3920
# ╠═49216ee0-6c0b-11eb-2054-f1b1e32ac42a
# ╠═c93572f0-6c0d-11eb-2979-539aeaafbb31
# ╠═a693e612-6c0c-11eb-18b5-2724ec517bc0
