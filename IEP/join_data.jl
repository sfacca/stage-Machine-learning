### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 49d553e0-6d2f-11eb-071c-4f84a5704dfa
using JLD2

# ╔═╡ b1e7c140-6d32-11eb-02c7-eb9b4a45dc4c
using Catlab

# ╔═╡ 6b6028e0-6d99-11eb-27d2-471d72e43c0d
using FileIO

# ╔═╡ 4bd35e20-6eed-11eb-0931-f3bb6c921d39
using Pkg

# ╔═╡ 64b698a0-6fa4-11eb-038a-3ddb71541c9a
using CSTParser

# ╔═╡ c1564bf0-6fa4-11eb-25f4-7b733748886b
using Catlab.CategoricalAlgebra, DataFrames

# ╔═╡ b4734e20-6d32-11eb-01a5-1d57875474c5
#include("functions_struct.jl")

# ╔═╡ 718b3da0-6eec-11eb-33f4-b5eae63a17fa
#include("function_CSet.jl")

# ╔═╡ 3674fb00-6eee-11eb-145a-69f58cb398cc
#=
@present implementationsSchema(FreeSchema) begin
		(Function, Implementation, Inputs, Calls)::Ob
		(code, setInp, setExpr, setCalls, docs, name, source)::Data
		
		impl_in::Hom(Implementation, Inputs)# ogni implem ha degli input	
		impl_fun::Hom(Implementation, Function)# ogni impl implementa una funzione
		impl_expr::Attr(Implementation, setExpr)#ogni impl è composta da expr
		impl_calls::Hom(Implementation, Calls)

		# link objects to their actual data
		impl_code::Attr(Implementation, code)
		in_set::Attr(Inputs, setInp)
		calls_set::Attr(Calls, setCalls)

		# more attributes
		func_name::Attr(Function, name)
		impl_docs::Attr(Implementation, docs)
	end
	impls = add_parts!(data, :Implementation, N)
	fs = add_parts!(data, :Function, length(unique(names)))
	inps = add_parts!(data, :Inputs, length(unique(inputs)))
=#

# ╔═╡ 0788c630-6f90-11eb-3556-95b86f0e85f5
function join_data!(data1, data2)
	#=result1 = folder_to_CSet(string(Pkg.dir("CSTParser"),"/src"));
	result2 = folder_to_CSet(string(Pkg.dir("Catlab"),"/src"));
	data1 = result1[2];
	data2 = result2[2];=#
	n_impls = add_parts!(data1, :Implementation, length(data2[:,:impl_in]))
	n_funcs = add_parts!(data1, :Function, length(data2[:,:func_name]))
	n_inps = add_parts!(data1, :Inputs, length(data2[:,:in_set]))
	data1[n_impls, :impl_code] = data2[:, :impl_code]
	data1[n_funcs, :func_name] = data2[:, :func_name]
	data1[n_inps, :in_set] = data2[:, :in_set]	
	data1[n_impls, :impl_expr] = data2[:, :impl_expr]
	data1[n_impls, :impl_docs] = data2[:, :impl_docs]
	# n_impls[1], n_funcs[1], n_inps[1]
	#homs are a bit complicated
	data1[n_impls, :impl_in] = data2[:, :impl_in]
	data1[n_impls, :impl_fun] = data2[:, :impl_fun]
	for i in n_impls
		data1[i, :impl_in]+= n_inps[1]-1
		data1[i, :impl_fun]+= n_funcs[1]-1
	end
end

# ╔═╡ ee89a590-6fa4-11eb-1dff-65a6f1098dc7
function add_module!(data1, mod::String)
	#result1 = folder_to_CSet(string(Pkg.dir("CSTParser"),"/src"));
	result2 = folder_to_CSet(string(Pkg.dir(mod),"/src"))
	#data1 = result1[2];
	data2 = result2[2]
	n_impls = add_parts!(data1, :Implementation, length(data2[:,:impl_in]))
	n_funcs = add_parts!(data1, :Function, length(data2[:,:func_name]))
	n_inps = add_parts!(data1, :Inputs, length(data2[:,:in_set]))
	data1[n_impls, :impl_code] = data2[:, :impl_code]
	data1[n_funcs, :func_name] = data2[:, :func_name]
	data1[n_inps, :in_set] = data2[:, :in_set]	
	data1[n_impls, :impl_expr] = data2[:, :impl_expr]
	data1[n_impls, :impl_docs] = data2[:, :impl_docs]
	# n_impls[1], n_funcs[1], n_inps[1]
	#homs are a bit complicated
	data1[n_impls, :impl_in] = data2[:, :impl_in]
	data1[n_impls, :impl_fun] = data2[:, :impl_fun]
	for i in n_impls
		data1[i, :impl_in]+= n_inps[1]-1
		data1[i, :impl_fun]+= n_funcs[1]-1
	end
end

# ╔═╡ 236d9cb0-6eee-11eb-2c36-9fba3d685a8a
# :impl_in, :impl_fun, :impl_calls
# :impl_expr, x:impl_code, x:in_set
# :calls_set, x:func_name, :impl_docs

# ╔═╡ bef1d0a2-6d97-11eb-3f57-a7eba5d095a5
#=begin 
	result = nothing
	@load "src_cstparser.jld2" result
	data1 = result[2]
	@load "src_tokenize.jld2" result
	data2 = result[2]
	result = nothing
end=#

# ╔═╡ 6f5e87b0-6eee-11eb-2233-2fd90d7f6584
"join_data!, add_module!"

# ╔═╡ Cell order:
# ╠═49d553e0-6d2f-11eb-071c-4f84a5704dfa
# ╠═b1e7c140-6d32-11eb-02c7-eb9b4a45dc4c
# ╠═6b6028e0-6d99-11eb-27d2-471d72e43c0d
# ╠═4bd35e20-6eed-11eb-0931-f3bb6c921d39
# ╠═64b698a0-6fa4-11eb-038a-3ddb71541c9a
# ╠═b4734e20-6d32-11eb-01a5-1d57875474c5
# ╠═718b3da0-6eec-11eb-33f4-b5eae63a17fa
# ╠═3674fb00-6eee-11eb-145a-69f58cb398cc
# ╠═c1564bf0-6fa4-11eb-25f4-7b733748886b
# ╠═0788c630-6f90-11eb-3556-95b86f0e85f5
# ╠═ee89a590-6fa4-11eb-1dff-65a6f1098dc7
# ╠═236d9cb0-6eee-11eb-2c36-9fba3d685a8a
# ╠═bef1d0a2-6d97-11eb-3f57-a7eba5d095a5
# ╠═6f5e87b0-6eee-11eb-2233-2fd90d7f6584
