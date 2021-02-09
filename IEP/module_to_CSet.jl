### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 79110330-6b17-11eb-3262-df93ff39cab8
using Pkg

# ╔═╡ 88be3a00-6b17-11eb-3dc3-dbc9e3a4a6ab
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

# ╔═╡ 42e3be0e-6b1c-11eb-2923-a951db651f22
function module_to_CSet(sym::Symbol)
	module_to_CSet(string(sym))
end

# ╔═╡ Cell order:
# ╠═79110330-6b17-11eb-3262-df93ff39cab8
# ╠═88be3a00-6b17-11eb-3dc3-dbc9e3a4a6ab
# ╠═42e3be0e-6b1c-11eb-2923-a951db651f22
