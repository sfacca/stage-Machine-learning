
#=
using Markdown
using InteractiveUtils
using Pkg=#
"""
takes a module name as a string
if it's not installed already, installs it
then scrapes into a CSet the /src folder

note: precompile wont work unless module is already  using-ed
"""
function module_to_CSet(mod::String)
	if isnothing(Pkg.dir(mod))
		Pkg.add(mod)
	end
	
	if isnothing(Pkg.dir(mod))
		throw("could not install module $(mod)")
	else
		folder_to_CSet(string(Pkg.dir(mod),"src"))
	end
end	

function module_to_CSet(sym::Symbol)
	module_to_CSet(string(sym))
end