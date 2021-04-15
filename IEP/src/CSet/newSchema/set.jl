
# :setters

function set_ImplementsExpr(index::Int, expr::String, data)
	ind = expression_exists(expr, data)
	if isnothing(ind)
		ind = new_Math_Expression(expr, data)
	end
	data[index, :ImplementsExpr] = ind
end

function set_ImplementsConc(index::Int, conc::String, data)
	ind = concept_exists(conc, data)
	if isnothing(ind)
		ind = new_Concept(conc, data)
	end
	data[index, :ImplementsConc] = ind
end

function set_IsSubClassOf(index::Int, concept::String, data)
	ind = concept_exists(conc, data)
	if isnothing(ind)
		ind = new_Concept(conc, data)
	end
	data[index, :IsSubClassOf] = ind
end


function set_UsesLanguage(typ::String, index::Int, language::String, data)
	if _checkTyp(typ)
		lind = language_exists(language, data)
		if !isnothing(lind)
			data[get_Any(typ, index, data),:UsesLanguage] = lind
		else
			data[get_Any(typ, index, data),:UsesLanguage] = new_Language(language, data)
		end
	else
		throw("typ is not an Ob name")
	end
end

function set_Unit(typ::String, index::Int, unit::Union{String,Int}, data)
	if _checkTyp(typ)
		if typeof(unit) == Int
			data[get_Any(typ, index, data), :IsMeasuredIn] = unit
		else
			uni = unit_exists(unit, data)
			if !isnothing(uni)
				data[get_Any(typ, index, data), :IsMeasuredIn] = uni
			else
				data[get_Any(typ, index, data), :IsMeasuredIn] = new_Unit(unit, data)
			end			
		end
	else
		throw("typ is not an Ob name")
	end
end

"""sets what function a code_block implements"""
function set_ImplementsFunc(fun_id::Int, block_id::Int, data)
	data[:block_id, :ImplementsFunc] = fun_id
end