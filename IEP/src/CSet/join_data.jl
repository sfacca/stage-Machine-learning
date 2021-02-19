
#using JLD2, Catlab, FileIO, Pkg, CSTParser, Catlab.CategoricalAlgebra, DataFrames, Flux

#include("functions_struct.jl")
#include("function_CSet.jl")
#include("unzip.jl")

function join_data(paths::Array{String,1})
	folder_to_CSet(paths)
end

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

function add_module!(data1, mod::String)
	#result1 = folder_to_CSet(string(Pkg.dir("CSTParser"),"/src"));
	result2 = folder_to_CSet(string(Pkg.dir(mod),"/src"))
	#data1 = result1[2];
	data2 = result2[2]
	join_data!(data1, data2)
end

"""
function returns array of every array of namedefs, without repetitions
"""
function join_namedefs( data1, data2)
	println("lengths: $(length(data1)) $(length(data2))")
	unique_arrays(vcat(data1, data2))
end	

function mod_src(str::String)
	string(Pkg.dir(str),"/src")
end

#=begin 
	result = nothing
	@load "src_cstparser.jld2" result
	data1 = result[2]
	@load "src_tokenize.jld2" result
	data2 = result[2]
	result = nothing
end=#

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

# :impl_in, :impl_fun, :impl_calls
# :impl_expr, x:impl_code, x:in_set
# :calls_set, x:func_name, :impl_docs

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