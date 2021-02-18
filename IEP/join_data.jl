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

# ╔═╡ e9fbcac0-71ee-11eb-27b0-99dad4346692
using Flux

# ╔═╡ b4734e20-6d32-11eb-01a5-1d57875474c5
include("functions_struct.jl")

# ╔═╡ 718b3da0-6eec-11eb-33f4-b5eae63a17fa
include("function_CSet.jl")

# ╔═╡ f94cfee0-71ee-11eb-043f-33829905c438
include("unzip.jl")

# ╔═╡ 52b1e3d0-7242-11eb-32e8-79675a99e35f
function join_data(paths::Array{String,1})
	folder_to_CSet(paths)
end

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

# ╔═╡ 0f9bad22-7138-11eb-3de4-6b0e5fe27a2a
#=
CSTParser.EXPR,#code, 
Array{NameDef,1},#setInp, 
Array{CSTParser.EXPR,1},# setExpr, 
Array{NameDef,1},# setCalls, 
String,# docs, 
NameDef,# name, 
Union{String,Nothing}# source

impl_in::Hom(Implementation, Inputs) data[:impl_in]::Array{Int,1}
impl_fun::Hom(Implementation, Function) data[:impl_fun]::Array{Int,1}
impl_calls::Hom(Implementation, Calls) data[:impl_calls]::Array{Int,1}

impl_expr::Attr(Implementation, setExpr) -> data[:, :impl_expr]::Array{}
impl_code::Attr(Implementation, code) -> data[:, :impl_code]::Array{CSTParser.EXPR,1}
impl_docs::Attr(Implementation, docs)

in_set::Attr(Inputs, setInp) -> data[:,:in_set]::Array{Array{NameDef,1},1}
calls_set::Attr(Calls, setCalls) -> data[:,:calls_set]::Array{Array{NameDef,1},1}
func_name::Attr(Function, name) -> data[:,:func_name]::Array{String,1}

=#

# ╔═╡ efcc454e-7131-11eb-121c-134289da23a6


# ╔═╡ ff222e00-7129-11eb-180d-459ce87fde42
"""
function returns array of every array of namedefs, without repetitions
"""
function join_namedefs( data1, data2)
	println("lengths: $(length(data1)) $(length(data2))")
	unique_arrays(vcat(data1, data2))
end	

# ╔═╡ 0788c630-6f90-11eb-3556-95b86f0e85f5
function join_data!(data1, data2)
	#=result1 = folder_to_CSet(string(Pkg.dir("CSTParser"),"/src"));
	result2 = folder_to_CSet(string(Pkg.dir("Catlab"),"/src"));
	data1 = result1[2];
	data2 = result2[2];=#
	#handle implementations
	println("handle implementations")
	n_impls = add_parts!(data1, :Implementation, length(data2[:,:impl_in]))
	data1[n_impls, :impl_code] = data2[:, :impl_code]
	data1[n_impls, :impl_expr] = data2[:, :impl_expr]
	data1[n_impls, :impl_docs] = data2[:, :impl_docs]
	
	#handle inputs
	println("handle inputs")
	tmp_inp = join_namedefs(data1[:,:in_set], data2[:,:in_set])
	println(length(tmp_inp))
	println(length(data2[:,:in_set]))
	n_inps = add_parts!(
		data1, 
		:Inputs, 
		length(tmp_inp)-length(data2[:,:in_set])
	)
	#link implementations with inputs
	println("link implementations with inputs")
	for i in 1:(length(data1[:,:impl_in]))
		println("hghghghghghg")
		if i < n_impls[1] #if it's from data1
			println("i < n_impls")
			data1[i,:impl_in] = findfirst(
				(x)->(x == data1[data1[i,:impl_in], :in_set]), 
				tmp_inp
			)
		else #if it's from data2
			println("i >= n_impls")
			data1[i,:impl_in] = findfirst(
				(x)->(x == data2[data2[i-n_impls[1]+1,:impl_in], :in_set]), 
				tmp_inp
			)
		end
	end
	data1[:,:in_set] = tmp_inp
	tmp_inp = nothing
	
	#handle funcs
	println("handle funcs")
	tmp_func = unique(vcat(data1[:,:func_name], data2[:,:func_name]))
	n_funcs = add_parts!(
		data1, 
		:Function, 
		length(tmp_func) - length(data2[:,:func_name])
	)
	#link implementations with funcs
	println("link implementations with funcs")
	for i in 1:(length(data1[:,:impl_fun]))
		if i < n_impls[1]
			data1[i,:impl_fun] = findfirst(
				(x)->(x == data1[data1[i,:impl_fun],:func_name]),
				tmp_func
			)
		else
			data1[i,:impl_fun] = findfirst(
				(x)->(x == data2[data2[i-n_impls[1]+1,:impl_fun],:func_name]),
				tmp_func			
			)
		end
	end
	data1[:,:func_name] = tmp_func
		
	#handle calls
	println("handle calls")
	tmp_calls = join_namedefs(data1[:,:in_set], data2[:,:in_set])
	n_calls = add_parts!(
		data1,
		:Calls,
		length(tmp_calls) - length(data1[:,:in_set])	
	)	
	#link implementations with calls
	println("link implementations with calls")
	for i in 1:(length(data1[:, :impl_calls]))
		if i < n_impls[1]
			data1[i,:impl_calls] = findfirst(
				(x)->(x == data1[data1[i,:impl_calls],:calls_set]),
				tmp_calls
			)
		else
			data1[i,:impl_calls] = findfirst(
				(x)->(x == data2[data2[i-n_impls[1]+1,:impl_calls],:calls_set]),
				tmp_calls			
			)
		end
	end
	data1[:,:calls_set] = tmp_calls
	
	data1	
end

# ╔═╡ ee89a590-6fa4-11eb-1dff-65a6f1098dc7
function add_module!(data1, mod::String)
	#result1 = folder_to_CSet(string(Pkg.dir("CSTParser"),"/src"));
	result2 = folder_to_CSet(string(Pkg.dir(mod),"/src"))
	#data1 = result1[2];
	data2 = result2[2]
	join_data!(data1, data2)
end

# ╔═╡ fb3e7a62-7209-11eb-39c9-49961f17ddc5


# ╔═╡ 236d9cb0-6eee-11eb-2c36-9fba3d685a8a
# :impl_in, :impl_fun, :impl_calls
# :impl_expr, x:impl_code, x:in_set
# :calls_set, x:func_name, :impl_docs

# ╔═╡ e75c8ed0-71ee-11eb-0c8e-73bcdb848126
function mod_src(str::String)
	string(Pkg.dir(str),"/src")
end

# ╔═╡ 76afa61e-7213-11eb-3bf2-95606dd0def6
unique_arrays

# ╔═╡ eed4f120-71ee-11eb-11c0-45a8c5425409
res1 = folder_to_CSet(mod_src("Flux"));

# ╔═╡ f27dd4e0-71ee-11eb-3dcc-55c5254aba19
data = res1[2];

# ╔═╡ fcbb4aa0-71ee-11eb-1244-41250147bf30
#=begin
	mkpath("tmp/zoo")
	download("https://github.com/FluxML/model-zoo/archive/master.zip", "tmp/zoo/master.zip")
	unzip("tmp/zoo/master.zip")
	res2 = folder_to_CSet("tmp/zoo")
end
	rm("tmp/zoo"; recursive = true)
	data[data[3,:impl_in],:
	#join_data!(data, res2[2])
end=#

# ╔═╡ e2b476a0-7206-11eb-0d8a-c30c424394a9
res2 = folder_to_CSet("tmp/zoo");

# ╔═╡ 57d4f0d0-7208-11eb-0fb8-119ac401e476
data1 = data;

# ╔═╡ 604d5e00-7208-11eb-391a-ffce1b2ff851
data2 = res2[2];

# ╔═╡ f9ef6fb0-720a-11eb-23ed-cba90ff8ad77
length(data1[:,:in_set])

# ╔═╡ 00e66d00-720b-11eb-1c6b-cf88a819c4be
length(data2[:,:in_set])

# ╔═╡ 024ee362-721b-11eb-0a9b-cbaad36c1217
data2[:,:in_set]

# ╔═╡ 1e8e5230-7217-11eb-0afe-9fba8f6926d0
data2[:,:in_set]

# ╔═╡ b23b53f0-721e-11eb-2027-95697875d5d1
findfirst((x)->(x == 13), data2[:, :impl_in])

# ╔═╡ c6438070-721e-11eb-3345-713e43535b65
data2[3, :impl_in]

# ╔═╡ 9e681190-7207-11eb-3524-718e640be8bc
tmp_inp = join_namedefs(data2[:,:in_set], data2[:,:in_set])

# ╔═╡ 0d5038a0-720b-11eb-1a48-af51782d2f37
length(tmp_inp)

# ╔═╡ 4c16c720-720b-11eb-1e37-e380b7986042
length(join_namedefs(tmp_inp, tmp_inp))

# ╔═╡ 0ff328a0-720c-11eb-09ad-f7fb12cb3e8b
getName(data1[:,:in_set][3][1])

# ╔═╡ 3b32b370-720a-11eb-112f-35217643540a
length(unique(data1[:,:in_set]))

# ╔═╡ 31d25740-720a-11eb-1107-f1982f2158e7
println(data1[:,:in_set])

# ╔═╡ 67b8ef0e-7208-11eb-038b-7fd498151cc6
println(length(tmp_inp))

# ╔═╡ 67b93d30-7208-11eb-2a8f-398f136418f8
println(length(data2[:,:in_set]))

# ╔═╡ 79d50d90-7209-11eb-0dea-ada32a3f5a88
data1[:,:in_set][3][1].name.args[1].val

# ╔═╡ 364f1e10-7210-11eb-2d00-b9c903429d8c
data1[:,:in_set][3][1].name.args[2].val

# ╔═╡ 777cd6a0-7212-11eb-1c1a-29be3912dc96
Expr(data1[:,:in_set][3][1].name)

# ╔═╡ 67b98b50-7208-11eb-0647-f7886e368991
n_inps = add_parts!(
		data1, 
		:Inputs, 
		length(tmp_inp)-length(data2[:,:in_set])
	)

# ╔═╡ 67c10562-7208-11eb-1056-e11c4931f71e
#link implementations with inputs
	println("link implementations with inputs")

# ╔═╡ 67c5e760-7208-11eb-1f40-5fd15ee59060
for i in 1:(length(data1[:,:impl_in]))
		println("hghghghghghg")
		if i < n_impls[1] #if it's from data1
			println("i < n_impls")
			data1[i,:impl_in] = findfirst(
				(x)->(x == data1[data1[i,:impl_in], :in_set]), 
				tmp_inp
			)
		else #if it's from data2
			println("i >= n_impls")
			data1[i,:impl_in] = findfirst(
				(x)->(x == data2[data2[i-n_impls[1]+1,:impl_in], :in_set]), 
				tmp_inp
			)
		end
	end

# ╔═╡ 6524cb20-7212-11eb-3c66-f3d855cb4a7b
flattenExpr

# ╔═╡ 6392d6ee-7206-11eb-2266-abfcf71c7400
data[3,:impl_in] = findfirst(
				(x)->(x == data[data[3,:impl_in], :in_set]), 
				tmp_inp
			)

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
# ╠═52b1e3d0-7242-11eb-32e8-79675a99e35f
# ╠═3674fb00-6eee-11eb-145a-69f58cb398cc
# ╠═c1564bf0-6fa4-11eb-25f4-7b733748886b
# ╠═0f9bad22-7138-11eb-3de4-6b0e5fe27a2a
# ╠═0788c630-6f90-11eb-3556-95b86f0e85f5
# ╠═ee89a590-6fa4-11eb-1dff-65a6f1098dc7
# ╠═efcc454e-7131-11eb-121c-134289da23a6
# ╠═ff222e00-7129-11eb-180d-459ce87fde42
# ╠═fb3e7a62-7209-11eb-39c9-49961f17ddc5
# ╠═236d9cb0-6eee-11eb-2c36-9fba3d685a8a
# ╠═e75c8ed0-71ee-11eb-0c8e-73bcdb848126
# ╠═e9fbcac0-71ee-11eb-27b0-99dad4346692
# ╠═76afa61e-7213-11eb-3bf2-95606dd0def6
# ╠═eed4f120-71ee-11eb-11c0-45a8c5425409
# ╠═f27dd4e0-71ee-11eb-3dcc-55c5254aba19
# ╠═f94cfee0-71ee-11eb-043f-33829905c438
# ╠═fcbb4aa0-71ee-11eb-1244-41250147bf30
# ╠═e2b476a0-7206-11eb-0d8a-c30c424394a9
# ╠═57d4f0d0-7208-11eb-0fb8-119ac401e476
# ╠═604d5e00-7208-11eb-391a-ffce1b2ff851
# ╠═f9ef6fb0-720a-11eb-23ed-cba90ff8ad77
# ╠═00e66d00-720b-11eb-1c6b-cf88a819c4be
# ╠═024ee362-721b-11eb-0a9b-cbaad36c1217
# ╠═1e8e5230-7217-11eb-0afe-9fba8f6926d0
# ╠═b23b53f0-721e-11eb-2027-95697875d5d1
# ╠═c6438070-721e-11eb-3345-713e43535b65
# ╠═9e681190-7207-11eb-3524-718e640be8bc
# ╠═0d5038a0-720b-11eb-1a48-af51782d2f37
# ╠═4c16c720-720b-11eb-1e37-e380b7986042
# ╠═0ff328a0-720c-11eb-09ad-f7fb12cb3e8b
# ╠═3b32b370-720a-11eb-112f-35217643540a
# ╠═31d25740-720a-11eb-1107-f1982f2158e7
# ╠═67b8ef0e-7208-11eb-038b-7fd498151cc6
# ╠═67b93d30-7208-11eb-2a8f-398f136418f8
# ╠═79d50d90-7209-11eb-0dea-ada32a3f5a88
# ╠═364f1e10-7210-11eb-2d00-b9c903429d8c
# ╠═777cd6a0-7212-11eb-1c1a-29be3912dc96
# ╠═67b98b50-7208-11eb-0647-f7886e368991
# ╠═67c10562-7208-11eb-1056-e11c4931f71e
# ╠═67c5e760-7208-11eb-1f40-5fd15ee59060
# ╠═6524cb20-7212-11eb-3c66-f3d855cb4a7b
# ╠═6392d6ee-7206-11eb-2266-abfcf71c7400
# ╠═bef1d0a2-6d97-11eb-3f57-a7eba5d095a5
# ╠═6f5e87b0-6eee-11eb-2233-2fd90d7f6584
