### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 2dc88a50-7856-11eb-0d03-dfa131e7216d
using JLD2

# ╔═╡ 032f3a50-7847-11eb-0a4a-6f9d5a8cdfe1
include("../unzip.jl")

# ╔═╡ 8e3e70c0-7847-11eb-110c-19b1bcef8a47
struct ModuleDef
	version::String
	url::String
	name::String
	ModuleDef() = new("","","")
	ModuleDef(a::String, b::String, c::String) = new(a,b,c)
end

# ╔═╡ 1a4c2b70-7848-11eb-140e-c7dc624b2f8b
function Toml_to_ModuleDef(path::String)
	pkgtoml = read(path, String)
	items = split(pkgtoml, "\n")
	#find repo
	i = 1
	f = false
	name = nothing
	url = nothing
	version = nothing
	for part in items
		if occursin(r"repo =", part)
			url = replace(
				string(
					split(part, "\"")[2]
					,
					"12 34"),
				r".git12 34"=>"/archive/master.zip"
			)
		elseif occursin(r"uuid = ", part)
			version = split(part, "\"")[2]
		elseif occursin(r"name = ", part)
			name = split(part, "\"")[2]
		end
	end
	
	if isnothing(name) || isnothing(url) || isnothing(version)
		ModuleDef()
	else
		ModuleDef(string(version), string(url), string(name))
	end		
end

# ╔═╡ fe851dc0-7847-11eb-0b8d-bb5b049a48fd
function get_ModuleDefs(dir)
	res = Array{ModuleDef,1}(undef,0)
	i = 1
	for (root, dirs, files) in walkdir(dir)	
        for file in files
            if endswith(file, ".toml")
              	push!(res, Toml_to_ModuleDef(joinpath(root, file)))
            end
			println("######## FILE $i DONE ########")
			i+=1
        end
    end
	unique(res)
end

# ╔═╡ 6ae2f6d0-7853-11eb-084a-1b82a9d9523d
function mds_to_dict(arr::Array{ModuleDef,1})
	dict = Dict()
	for md in arr
		if md.name == "" || md.url == ""
		else
			push!(dict, md.name => md.url)
		end
	end
	return dict
end

# ╔═╡ 216dd7b0-7847-11eb-02c1-5bbc2b004711
begin
	mkpath("tmp")
	println("downloading registry...")
	download("https://github.com/JuliaRegistries/General/archive/master.zip","tmp/master.zip")

	println("unzipping...")
	unzip("tmp/master.zip")

	println("scraping module definitions...")
	mds = unique(get_ModuleDefs("tmp/General-master"))

	println("making dictionary...")
	modules_dict = mds_to_dict(mds)

	println("removing temporary folder...")
	rm("tmp", recursive=true)
	
	println("saving...")
	save( "registry.jld2", Dict("registry"=>modules_dict))

end

# ╔═╡ Cell order:
# ╠═032f3a50-7847-11eb-0a4a-6f9d5a8cdfe1
# ╠═2dc88a50-7856-11eb-0d03-dfa131e7216d
# ╠═216dd7b0-7847-11eb-02c1-5bbc2b004711
# ╠═8e3e70c0-7847-11eb-110c-19b1bcef8a47
# ╠═1a4c2b70-7848-11eb-140e-c7dc624b2f8b
# ╠═fe851dc0-7847-11eb-0b8d-bb5b049a48fd
# ╠═6ae2f6d0-7853-11eb-084a-1b82a9d9523d
