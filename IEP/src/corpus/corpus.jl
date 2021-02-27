### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 45bc8a80-77a7-11eb-051f-f72a421f3795
using Pkg

# ╔═╡ af3fc4e0-7879-11eb-1ae1-6bd4ca887751
using CSTParser

# ╔═╡ bb16a5b0-7881-11eb-0993-e5ddf0253c5d
using FileIO

# ╔═╡ e462fbd0-77aa-11eb-1c62-cf7e5844bb9e
using JLD2

# ╔═╡ 81278630-778c-11eb-27c8-03e3def7f22b
include("../IEP.jl")

# ╔═╡ a3bf774e-77a7-11eb-020c-677baae4eceb
include("unzip.jl")

# ╔═╡ 2f791400-77a7-11eb-2bda-7d61304dd02d
#1 parse some code

# ╔═╡ 07499d00-7825-11eb-3f75-17749dc56811
function read_code(paths::Array{String,1})
	res = []
	for path in paths
		res = vcat(res, read_code(path))
	end
	res	
end

# ╔═╡ 46d39d60-7837-11eb-3c48-090399328e4c
println("asdf")

# ╔═╡ 5c9a9a70-7843-11eb-312c-eda6e0c791ed
names = unique([replace(string(x), r"\r"=>"") for x in split(read("pkg_corpus.txt",String),"\n")])

# ╔═╡ c78e78e0-7872-11eb-15c6-0b15dda320df
"""
macro creates a variable in local scope of name s and value v
"""
macro string_as_varname_macro(s::AbstractString, v::Any)
	s = Symbol(s)
	esc(:($s = $v))
end

# ╔═╡ 378835ce-785c-11eb-1be3-a1b377eb3e2e
@load "registry/registry.jld2"

# ╔═╡ 281664e0-785d-11eb-192c-a3cb9ae4aa2a
function single_scrape_save(dict, name)
	println("gettin module $name")
	mkpath("tmp/$name")
	download(dict[name], "tmp/$name/file.zip")
	unzip("tmp/$name/file.zip","tmp/$name")
	parse = IEP.read_code("tmp/$name")
	rm("tmp/$name", recursive = true)
	scrape = IEP.scrape(parse)
	save("scrapes/$(name).jld2", Dict(name => scrape))
	scrape = nothing
	parse = nothing
end

# ╔═╡ 629f70f0-7882-11eb-35b2-b7de2fdfde38
function save_scrapes_from_Modules(dict, names)
	fails = []
	for name in names
		try
			single_scrape_save(dict, name)
		catch e
			println("error on name: $name")
			println(e)
			push!(fails, name)
		end
	end
	fails
end

# ╔═╡ 78ef91a0-7882-11eb-31cb-b1cbc699a0be
save_scrapes_from_Modules(modules_dict, names)

# ╔═╡ aa8eb102-785a-11eb-0e7b-5f12b8514cb9
function get_Module(dict, name::String)
	mkpath("tmp/$name")
	download(dict[name], "tmp/$name/file.zip")
	unzip("tmp/$name/file.zip","tmp/$name")
	parse = IEP.read_code("tmp/$name")
	rm("tmp/$name", recursive = true)
	parse
end

# ╔═╡ b93d1ffe-785b-11eb-0b87-dfaa5aaf7ad4
function get_Module(dict, names::Array{String,1})
	res = []
	for name in names
		try
			res = vcat(res, get_Module(dict, name))
		catch e
			println("error on name: $name")
			println(e)
			#push!(fails, name)
		end
	end
	res
end

# ╔═╡ b7663d20-785b-11eb-150c-0f02818a72b7
mds = get_Module(modules_dict, names[3:5]);

# ╔═╡ 78524300-783c-11eb-3045-93c3d98ff10f
function find_url(names::Array{SubString{String},1})
	res = []
	for name in names
		try
			res = vcat(res, find_url(name))
		catch e
			println("error with name: $name")
			println(e)
		end
	end
	res
end

# ╔═╡ 6792ff50-7891-11eb-2c98-1f682cdd3325
#dict = get_dict("scrapes")

# ╔═╡ 065fd9d0-7894-11eb-37ec-8dc0c383e3b6
#save("dictionary.jld2", Dict("dictionary"=>dict))

# ╔═╡ b7a21a90-7890-11eb-0c6a-b70ff1c9345c
function _in_src(fda::Array{IEP.FunctionContainer,1})
	res = Array{IEP.FunctionContainer,1}(undef,0)
	for fd in fda
		if _in_src(fd.source)
			push!(res, fd)
		end
	end
	res
end

# ╔═╡ 9b88ce30-7890-11eb-3dae-51ecd93bdb72
function _in_src(fd::IEP.FunctionContainer)
	_in_src(fd.source)
end

# ╔═╡ e8c6ef22-788f-11eb-3611-17cb3e3e2bb8
function _in_src(arr::Array{String,1})
	res = []
	for str in arr
		if _in_src(str)
			push!(res, str)
		end
	end
	res
end

# ╔═╡ 6bc2bbc0-7890-11eb-090f-072d6da42eac
function _in_src(str::String)
	"src" in split(str, "\\")				
end

# ╔═╡ 4ac94b80-788d-11eb-00e1-13a38ee9fc99
function get_dict(dir::String)
	dict = Dict()
	for (root, dirs, files) in walkdir(dir)
		for file in files
			if endswith(file, ".jld2")
				name = string(split(file,".jld2")[1])
				tmp = Array{IEP.FunctionContainer,1}(undef,0)
				tmp = vcat(tmp, load(joinpath(root, file))[name])
				println(unique([typeof(x) for x in tmp]))
				for item in _in_src(tmp)
					dict = merge(dict, IEP.make_head_expr_dict(item.func.block))
				end
				tmp = nothing
			end
		end
	end		
	dict
end

# ╔═╡ e5b42cb0-7896-11eb-1e26-1d78a9c58e66
save("CSet.jld2", Dict(CSet)

# ╔═╡ 36915840-7894-11eb-31c0-0921e00ce8ca
function files_to_cset(dir)
	cset = nothing
	for (root, dirs, files) in walkdir(dir)
		try
			for file in files
				if endswith(file, ".jld2")	
					println("handling $file")
					name = string(split(file,".jld2")[1])
					tmp = Array{IEP.FunctionContainer,1}(undef,0)
					tmp = vcat(tmp, load(joinpath(root, file))[name])
					println(unique([typeof(x) for x in tmp]))
					if isnothing(cset)
						cset = IEP.get_newSchema(tmp)
					else
						println("adding stuff...")
						IEP.handle_FunctionContainer!(tmp,cset)
					end
					tmp = nothing
				end
			end
		catch e
			#println("error at file: $file")
			#println(e)
		end
	end
	cset
end

# ╔═╡ e7f55500-7894-11eb-16ab-2f9b460e26e1
CSet = files_to_cset("scrapes");

# ╔═╡ 235bd320-7896-11eb-1dfc-8bfb02e670b6
sample = load("scrapes/ADI.jld2")["ADI"];

# ╔═╡ Cell order:
# ╠═81278630-778c-11eb-27c8-03e3def7f22b
# ╠═a3bf774e-77a7-11eb-020c-677baae4eceb
# ╠═45bc8a80-77a7-11eb-051f-f72a421f3795
# ╠═2f791400-77a7-11eb-2bda-7d61304dd02d
# ╠═07499d00-7825-11eb-3f75-17749dc56811
# ╠═46d39d60-7837-11eb-3c48-090399328e4c
# ╠═5c9a9a70-7843-11eb-312c-eda6e0c791ed
# ╠═c78e78e0-7872-11eb-15c6-0b15dda320df
# ╠═af3fc4e0-7879-11eb-1ae1-6bd4ca887751
# ╠═378835ce-785c-11eb-1be3-a1b377eb3e2e
# ╠═281664e0-785d-11eb-192c-a3cb9ae4aa2a
# ╠═78ef91a0-7882-11eb-31cb-b1cbc699a0be
# ╠═629f70f0-7882-11eb-35b2-b7de2fdfde38
# ╠═bb16a5b0-7881-11eb-0993-e5ddf0253c5d
# ╠═b7663d20-785b-11eb-150c-0f02818a72b7
# ╠═aa8eb102-785a-11eb-0e7b-5f12b8514cb9
# ╠═b93d1ffe-785b-11eb-0b87-dfaa5aaf7ad4
# ╠═78524300-783c-11eb-3045-93c3d98ff10f
# ╠═6792ff50-7891-11eb-2c98-1f682cdd3325
# ╠═065fd9d0-7894-11eb-37ec-8dc0c383e3b6
# ╠═4ac94b80-788d-11eb-00e1-13a38ee9fc99
# ╠═b7a21a90-7890-11eb-0c6a-b70ff1c9345c
# ╠═9b88ce30-7890-11eb-3dae-51ecd93bdb72
# ╠═e8c6ef22-788f-11eb-3611-17cb3e3e2bb8
# ╠═6bc2bbc0-7890-11eb-090f-072d6da42eac
# ╠═e462fbd0-77aa-11eb-1c62-cf7e5844bb9e
# ╠═e7f55500-7894-11eb-16ab-2f9b460e26e1
# ╠═e5b42cb0-7896-11eb-1e26-1d78a9c58e66
# ╠═36915840-7894-11eb-31c0-0921e00ce8ca
# ╠═235bd320-7896-11eb-1dfc-8bfb02e670b6
