
#include("parse_folder.jl")
#include("functions_struct.jl")

#using Catlab, Catlab.CategoricalAlgebra, DataFrames, Pkg, CSTParser, Match

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

function folder_to_scrape(path::String)
	scrape(read_code(path))
end

function scrape_check(arr::Array{Any,1})
	res = Array{FunctionContainer,1}(undef, 0)
	fails = []
	for i in 1:length(arr)
		x = arr[i]
		if typeof(x) == Tuple{CSTParser.EXPR,String}
			len = length(res)
			try
				res = vcat(res, scrape_functions_starter(x[1]; source = x[2]))
			catch e
				println("scrape number $i errored")
				println(e)
			end
			if len == length(res)
				println("scrape tuple number $i didnt do anything")
				push!(fails, i)
			end
		end
	end
	return res, fails
end


"""
takes output of read_code, returns info on functions defined in the EXPRs
"""
function scrape(arr::Array{Any,1})::Array{FunctionContainer,1}
	res = Array{FunctionContainer,1}(undef, 0)
	for i in 1:length(arr)
		x = arr[i]
		if typeof(x) == Tuple{CSTParser.EXPR,String}
			len = length(res)
			try
				res = vcat(res, scrape_functions_starter(x[1]; source = x[2]))
			catch e
				println("scrape number $i errored")
				println(e)
			end
			if len == length(res)
				println("scrape tuple number $i didnt do anything")
				println("")
			end
		end
	end
	res
end
		
function scrape_functions_starter(e::CSTParser.EXPR;source::Union{String,Nothing} = nothing)::Array{FunctionContainer,1}
	tmp = scrapeFuncDef(e)
	if isnothing(tmp)
		res = Array{FunctionContainer,1}(undef,0)
	else
		res = [FunctionContainer(tmp,nothing,source)]
	end
	vcat(res, scrape_functions(e;source=source))
end

"""
function iterates over EXPR tree, scrapes function definitions and documentation
"""
function scrape_functions(e::CSTParser.EXPR;source::Union{String,Nothing} = nothing)::Array{FunctionContainer,1}
	if _checkArgs(e)#leaves cant be functions
		#println("expr is not a leaf")
		res = Array{FunctionContainer,1}(undef,0)
		docs = nothing
		# iterates over e.args, looking for functions or docs
		for i in 1:length(e.args)
			if e.args[i].head == :globalrefdoc
				#println("found globalrefdoc")
				i = getDocs(e,i)
				docs = isnothing(e.args[i].val) ? "error finding triplestring" : e.args[i].val
			end
			
			tmp = scrapeFuncDef(e.args[i])
			if !isnothing(tmp)
				res = vcat(res, FunctionContainer(tmp,docs,source))
				docs = nothing
			elseif _checkArgs(e.args[i])
				#println("child has args")
				# if e[i] has args, scrapes e[i]
				res = vcat(res, scrape_functions(e.args[i]; source = source))
			end
		end
		return res
	else
		#println("expr is a leaf")
		return Array{FunctionContainer,1}(undef,0)
	end
end

function scrape_functions(arr::Array{CSTParser.EXPR,1};source::Union{String,Nothing} = nothing)::Array{FunctionContainer,1}
	res = Array{FunctionContainer,1}(undef,0)
	for x in arr
		res = vcat(res, scrape_functions(x;source=source))
	end
	res
end

"""
checks if argument expression defines a function
if so, returns the FuncDef
otherwise, returns nothing
"""
function scrapeFuncDef(e::CSTParser.EXPR)::Union{FuncDef, Nothing}
	# 1 returns FuncDef if e defines function, Nothing if it doesnt
	if isAssignmentOP(e)
		# an assignment operation can be a function definition 
		# if rvalue is a nameless function, defined with an -> operation
		if isArrowOP(e.args[2])
			# e.args contains the lvalue and rvalue of the -> operation
			# we also now know that the lvalue of the assignment operation 
			# is the function name
			println("funcdef?")
			return FuncDef(
				scrapeName(e.args[1]),
				scrapeInputs(e.args[2].args[1]),
				e
			)
		elseif e.args[1].head == :call
			# we're in the name(vars) = block pattern
			# we can run scrapeinputs on the :call, 
			# the first input will actually be the function name			
			tmp = scrapeInputs(e.args[1])
			inputs = length(tmp) > 1 ? tmp[2:end] : Array{InputDef,1}(undef, 0)
			# the function code will be the rvalue of the assignment operation e
			return FuncDef(
				scrapeName(e.args[1].args[1]),
				inputs,
				e				
			)
		end
	elseif e.head == :function
		# this is the basic function name(args) block pattern
		# args[1] could be the call or an :: OP
		if e.args[1].head == :call
			# we're in the name(vars) = block pattern
			# we can run scrapeinputs on the :call, 
			# the first input will actually be the function name			
			tmp = scrapeInputs(e.args[1])
			inputs = length(tmp) > 1 ? tmp[2:end] : Array{InputDef,1}(undef, 0)
			# the function code will be the rvalue of the assignment operation e
			return FuncDef(
				scrapeName(e.args[1].args[1]),
				inputs,
				e# the whole function				
			)
		elseif isTypedefOP(e.args[1])
			# this function defines its output type
			if _checkArgs(e.args[1])&&_checkArgs(e.args[1].args[1])&&e.args[1].args[1].head == :call
				# we're in the name(vars) = block pattern
				# we can run scrapeinputs on the :call, 
				# the first input will actually be the function name			
				tmp = scrapeInputs(e.args[1].args[1])
				inputs = length(tmp) > 1 ? tmp[2:end] : Array{InputDef,1}(undef, 0)
				
				# the function code will be the rvalue of the assignment operation e
				return FuncDef(
					scrapeName(e.args[1].args[1].args[1]),
					inputs,
					e,
					scrapeName(e.args[1].args[2])
				)
			else
				return FuncDef(
					":function's typedef operator didnt have a :call as its leftvalue",
					e					
				)
			end
		end	
	else
		return nothing
	end
	nothing
end	

"""
takes an expr that defines a function adress/name, returns NameDef
"""
function scrapeName(e::CSTParser.EXPR)::NameDef
	#println("scrapename")
	NameDef(e)
end

"""
takes an expr that defines a function adress/name, returns NameDef
"""
function OLDscrapeName(e::CSTParser.EXPR)::NameDef
	# is this a module.name pattern?	
	if isDotOP(e)
		NameDef(
			getName(scrapeName(e.args[2])), 
			getName(scrapeName(e.args[1]))
		)
	else
		if e.head == :quotenode
			NameDef(e.args[1].val, nothing)
		else
			NameDef(e.val, nothing)
		end
	end		
end

"""
takes an expr that defines inputs, returns array of InputDef
the expr needs to only contain argument definitions in its .args array
:function -> :call function definitions have their function name in the same args
"""
function scrapeInputs(e::CSTParser.EXPR)::Array{InputDef,1}
	println("scrape inputs")
	if _checkArgs(e)
		arr = Array{InputDef,1}(undef, length(e.args))
		for i in 1:length(arr)
			# is this a simple param name or is this a :: OP?
			if isTypedefOP(e.args[i])
				println("TYPEDEFOP")
				try
					if length(e.args[i].args)<2
						#println("args < 2")
						#this is a weird ::Type curly thing probably
						arr[i] = InputDef(
							scrapeName(e.args[i].args[1]),
							scrapeName(e.args[i].args[1])
						)
					else
						#println("args > 2")
						arr[i] = InputDef(
						scrapeName(e.args[i].args[1]),
						scrapeName(e.args[i].args[2])
					)
					end
				catch err
					println("error!")
					println(err)
					#println(e.args)
				end
			else
				arr[i] = InputDef(
					scrapeName(e.args[i]), 
					scrapeName(CSTParser.parse("x::Any").args[2])
				)
			end
		end		
	else
		arr = Array{InputDef,1}(undef, 0)
	end
	println("finished scraping inputs")
	arr
end

"""
takes an expr that defines inputs, returns array of InputDef
the expr needs to only contain argument definitions in its .args array
:function -> :call function definitions have their function name in the same args
"""
function OLDscrapeInputs(e::CSTParser.EXPR)::Array{InputDef,1}
	if !isnothing(e.args) && !isempty(e.args)
		arr = Array{InputDef,1}(undef, length(e.args))
		for i in 1:length(arr)
			# is this a simple param name or is this a :: OP?
			if isTypedefOP(e.args[i])
				arr[i] = InputDef(
					scrapeName(e.args[i].args[1]),
					scrapeName(e.args[i].args[2])
				)
			else
				arr[i] = InputDef(
					scrapeName(e.args[i]), 
					NameDef("Any",nothing)
				)
			end
		end		
	else
		arr = Array{InputDef,1}(undef, 0)
	end
	arr
end

function uniqueidx(x::AbstractArray{T}) where T
    uniqueset = Set{T}()
    ex = eachindex(x)
    idxs = Vector{eltype(ex)}()
    for i in ex
        xi = x[i]
        if !(xi in uniqueset)
            push!(idxs, i)
            push!(uniqueset, xi)
        end
    end
    idxs
end

"""we want this function to tell us what modules are included"""
function module_scrape()

end

"""given the read_code (EXPR,file path) array result, we want to make an include tree"""
function include_tree(arr)
	#1 sort by source path
	srcs = [x[2] for x in arr]
	permut = sortperm(srcs)
	sorted_arr = arr[permut]

	#2 we only need includes
end

"""
this function returns included file if the given expr is an include, nothing otherwise"""
function is_include(e::CSTParser.EXPR)::Union{Nothing, String}
    res = nothing
    if e.head == :call
        # it's a call, let's check called function
        if !isnothing(e.args) && length(e.args)>1
            if e.args[1].head == :IDENTIFIER && e.args[1].val == "include"
                res = e.args[2].val
            end
        end
    end
    res
end



function scrape_includes(e::CSTParser.EXPR)::Array{String}
	res = Array{String,1}(undef, 0)
	tmp = is_include(e)
	if !isnothing(tmp)
		res = [tmp]
	else
        if _checkArgs(e)
            for sube in e.args
                res = vcat(res, scrape_includes(sube))
            end
        end
	end
    #println(typeof(res))
	res
end


function scrape_includes(arr::Array{CSTParser.EXPR,1})::Array{String}
	res = Array{String,1}(undef, 0)
	for e in arr
        res = vcat(res,scrape_includes(e))
	end
	res
end


function scrape_includes(tuple::Tuple{CSTParser.EXPR,String})
	(scrape_includes(tuple[1]), tuple[2])
end


function aux_stuff(arr)
	res = []
	for tuple in arr
		push!(res, scrape_includes(tuple))
	end
	res
end





	
