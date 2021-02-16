### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 425d8630-7042-11eb-1766-c3cfd5b7bd13
using Pkg

# ╔═╡ 504bcef0-7042-11eb-292f-eb4e9c82b380
using Catlab

# ╔═╡ 53e59780-7042-11eb-2b07-db9f047142df
using JLD2

# ╔═╡ 5855e9f0-7042-11eb-2db1-7fa3d5048825
using FileIO

# ╔═╡ 09e98130-704e-11eb-1e07-31a126204edc
using CSTParser

# ╔═╡ 663026c0-7048-11eb-248c-61acca51d830
include("functions_struct.jl")

# ╔═╡ 5b26e442-7042-11eb-1683-5f4fb9b10098
include("function_CSet.jl")

# ╔═╡ 838695c0-7042-11eb-0169-590b56f57faa
#@load "flux_plus_zoo.jld2"

# ╔═╡ 1216ea60-7048-11eb-0f12-1917f5cfd59c
#data = res1[2];

# ╔═╡ 08bfdd00-7048-11eb-0e9a-455dda132019
#data[:,:gimme_names]

# ╔═╡ 44790472-7048-11eb-395a-b7f36560ea6d
#make_dict(data)

# ╔═╡ 97a09c90-7042-11eb-2499-c5097d26d42d
#=function make_dict(data)
	dic = Dict()
	for i in 1:length(data[:,:func_name])
		push!(dic, getName(data[i,:func_name]), findall((x)->(x==i),data[:,:impl_fun]))
	end
	dic
end=#

# ╔═╡ 5a835bd0-7043-11eb-2635-f9b038841f73
parsed = read_code(string(Pkg.dir("CSTParser"),"/src"));

# ╔═╡ 7cdccd10-704d-11eb-2b40-8b43c3a95362
expr_only = [x[1] for x in parsed];

# ╔═╡ eb488640-7052-11eb-0504-6b0e161c9598


# ╔═╡ b0bf0200-704e-11eb-167d-e798205a7f64
function flattenExpr(arr::Array{CSTParser.EXPR,1})::Array{CSTParser.EXPR}
	res = []
	for e in arr
		res = vcat(res, flattenExpr(e))
	end
	res
end

# ╔═╡ c870f210-704d-11eb-3048-7f78817e11b8
function flattenExpr(e::CSTParser.EXPR)::Array{CSTParser.EXPR}
	res = [e]
	if _checkArgs(e)
		for x in e.args
			res = vcat(res, flattenExpr(x))
		end
	end
	res
end

# ╔═╡ bb3bcde0-7052-11eb-13dc-19388cb48181
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

# ╔═╡ 7cbb8ca0-7051-11eb-1882-617de42a71bc
make_dict(expr_only)

# ╔═╡ 10b74ba0-704e-11eb-12fa-43f229dda10c
function get_all_heads(e::Array{CSTParser.EXPR,1})
	[x.head for x in e]
end	

# ╔═╡ 3616403e-704e-11eb-0f65-c9d1b10e5610
function get_all_vals(e::Array{CSTParser.EXPR,1})
	[x.val for x in e]
end	

# ╔═╡ 4b46e730-704e-11eb-1044-f9d8ba5b769c
"""
makes complete dict of expressions, heads and vals
"""
function make_dict_complete(arr::Array{CSTParser.EXPR,1})
	dic = Dict()
	i = 1
	flat = unique(flattenExpr(arr))
	
	for j in 1:length(flat)
		dic[i] = flat[j]
		i = i + 1
	end
	heads = unique(get_all_heads(flat))
	for j in 1:length(heads)		
		dic[i] =heads[j]
		i = i + 1
	end
	vals = unique(get_all_vals(flat))	
	for j in 1:length(vals)
		dic[i] =vals[j]
		i = i + 1
	end
	return dic
	
end

# ╔═╡ f5ed4950-7052-11eb-3535-35dc92fd985e
md"
# estrazione docstring
"

# ╔═╡ 0488e912-7053-11eb-0b0a-17da3947c6ed
sample = read_code("sample");

# ╔═╡ 0c33a600-7053-11eb-1bd8-67dcbcf7ccd2
sample_code = [x[1] for x in sample];#per l'esempio ci servono solo le expr

# ╔═╡ 2884cb40-7053-11eb-2d7a-fb50c1ab474e
sample_expr = sample_code[1]#vediamo una funzione

# ╔═╡ 3689d050-7053-11eb-1f05-7d24fd19b7bc
sample_expr.args #vediamo nodi sibling dell'expr

# ╔═╡ 3bddcc00-7053-11eb-03c6-39ee63128e03
sample_expr.args[1] # quasta expr notifica presenza docstring

# ╔═╡ 53da8b40-7053-11eb-3fe6-272f6f5252b3
sample_expr.args[1].head

# ╔═╡ 59918e80-7053-11eb-0abc-efec93a48a72
sample_expr.args[1].val

# ╔═╡ 5c8e05a0-7053-11eb-10e5-bd4d75101dfb
sample_expr.args[3] 
#contenuti docstring sono nell var del nodo triplestring successivo (dopo un sibling vuoto)

# ╔═╡ 7e4268ce-7053-11eb-06ff-2598cada082f
sample_expr.args[3].head

# ╔═╡ 6f437360-7053-11eb-0c85-c587f2ec6a29
sample_expr.args[3].val

# ╔═╡ Cell order:
# ╠═425d8630-7042-11eb-1766-c3cfd5b7bd13
# ╠═504bcef0-7042-11eb-292f-eb4e9c82b380
# ╠═53e59780-7042-11eb-2b07-db9f047142df
# ╠═5855e9f0-7042-11eb-2db1-7fa3d5048825
# ╠═09e98130-704e-11eb-1e07-31a126204edc
# ╠═663026c0-7048-11eb-248c-61acca51d830
# ╠═5b26e442-7042-11eb-1683-5f4fb9b10098
# ╠═838695c0-7042-11eb-0169-590b56f57faa
# ╠═1216ea60-7048-11eb-0f12-1917f5cfd59c
# ╠═08bfdd00-7048-11eb-0e9a-455dda132019
# ╠═44790472-7048-11eb-395a-b7f36560ea6d
# ╠═97a09c90-7042-11eb-2499-c5097d26d42d
# ╠═5a835bd0-7043-11eb-2635-f9b038841f73
# ╠═7cdccd10-704d-11eb-2b40-8b43c3a95362
# ╠═7cbb8ca0-7051-11eb-1882-617de42a71bc
# ╠═eb488640-7052-11eb-0504-6b0e161c9598
# ╠═4b46e730-704e-11eb-1044-f9d8ba5b769c
# ╠═bb3bcde0-7052-11eb-13dc-19388cb48181
# ╠═b0bf0200-704e-11eb-167d-e798205a7f64
# ╠═c870f210-704d-11eb-3048-7f78817e11b8
# ╠═10b74ba0-704e-11eb-12fa-43f229dda10c
# ╠═3616403e-704e-11eb-0f65-c9d1b10e5610
# ╟─f5ed4950-7052-11eb-3535-35dc92fd985e
# ╠═0488e912-7053-11eb-0b0a-17da3947c6ed
# ╠═0c33a600-7053-11eb-1bd8-67dcbcf7ccd2
# ╠═2884cb40-7053-11eb-2d7a-fb50c1ab474e
# ╠═3689d050-7053-11eb-1f05-7d24fd19b7bc
# ╠═3bddcc00-7053-11eb-03c6-39ee63128e03
# ╠═53da8b40-7053-11eb-3fe6-272f6f5252b3
# ╠═59918e80-7053-11eb-0abc-efec93a48a72
# ╠═5c8e05a0-7053-11eb-10e5-bd4d75101dfb
# ╠═7e4268ce-7053-11eb-06ff-2598cada082f
# ╠═6f437360-7053-11eb-0c85-c587f2ec6a29
