
"""
adds a new Math_Expression"""
function new_Math_Expression(expr::String, data)
	i = add_parts!(data, :Math_Expression, 1)[1]
	data[i, :math_expression] = lang
	i
end

"""adds a new language"""
function new_Language(lang::String, data)
	i = add_parts!(data, :Language, 1)[1]
	data[i, :language] = lang
	i
end

"""adds an unit"""
function new_Unit(lang::String, data)
	i = add_parts!(data, :Unit, 1)[1]
	data[i, :unit] = lang
	i
end

"""
adds calledby relations from every function in calls_set to the func function
if a function in called_by is not present in data, it is added 
    """
function add_calls(func::Union{String, Int}, calls_set::Array{String,1}, data)
	if typeof(func) == String
		i = findfirst((x)->(x == func), data[:,:func])
		if isnothing(i)
			i = add_parts!(data, :Function, 1)[1]
			data[i,:func] = func
		end
		func = i
	end
	
	for call in calls_set
		#1
		i = function_exists(call, data)
		if isnothing(i)
			i = add_parts!(data, :Function, 1)[1]
			data[i,:func] = call
		end
		add_XCalledByY(i, func, data) #func calls call -> call is called by func
	end
end


function add_AComponentOfB(a::Int, b::Int, data)
	i = add_parts!(data, :AComponentOfB, 1)[1]
	data[i, :A] = a	
	data[i, :B] = b
	i
end

function add_XCalledByY(x::Int, y::Int, data)
	i = add_parts!(data, :XCalledByY, 1)[1]
	data[i, :X] = x	
	data[i, :Y] = y
	i
end

function new_Concept(expr::String, data)
	i = add_parts!(data, :Concept, 1)[1]
	data[i, :concept] = expr
	i
end


function create_Ob(typ::String, value::String, data)
	if _checkTyp(typ)
		i = add_parts!(data, Symbol(typ), 1)[1]
		data[i, type_to_value(typ)] = value
		i
	else
		throw("typ is not an Ob name")
	end
end

"""
adds componentof relations from every element in components to the item (given as index of an :Any type Ob)
all components must be of component_type
components not already in data are added
    """
function add_components(
		anyB::Int, components::Array{String,1}, component_type::String, data
		)
	for comp in components
		#println("does component exist?")
		i = find_Ob(component_type, comp, data)
		if isnothing(i)
			# creating comp
			i = create_Ob(component_type, comp, data)
		end
		#println("adding a component")
		add_AComponentOfB(get_Any(component_type, i, data), anyB, data)
	end
end	