### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 45bc8a80-77a7-11eb-051f-f72a421f3795
using Pkg, CSTParser, FileIO, JLD2

# ╔═╡ 81278630-778c-11eb-27c8-03e3def7f22b
include("../IEP.jl")

# ╔═╡ a3bf774e-77a7-11eb-020c-677baae4eceb
include("unzip.jl")

# ╔═╡ 07499d00-7825-11eb-3f75-17749dc56811
function read_code(paths::Array{String,1})
	res = []
	for path in paths
		res = vcat(res, read_code(path))
	end
	res	
end

# ╔═╡ c78e78e0-7872-11eb-15c6-0b15dda320df
function add_folder_to_cset!(dir, cset)
	for (root, dirs, files) in walkdir(dir)
		try
			len = length(files)
			i = 1
			for file in files
				if endswith(file, ".jld2")	
					println("handling $file")
					name = string(split(file,".jld2")[1])
					tmp = Array{IEP.FunctionContainer,1}(undef,0)
					tmp = vcat(tmp, load(joinpath(root, file))[name])
					println(unique([typeof(x) for x in tmp]))
					if isnothing(tmp)
						println("$file appears empty")
					else
						println("adding stuff...")
						for fc in tmp
							println("adding $(IEP.getName(fc.func.name))")	
							try					
								println(length(cset[:,:func]))
								IEP.handle_FunctionContainer!(fc, cset)
								println(length(cset[:,:func]))
							catch e
								println("error: $e")
							end
						end
					end
					tmp = nothing
				end
				println("############## $((100*i)/len)% DONE ##############")
				i = i + 1
			end
		catch e
			println("error at file: $file")
			println(e)
		end
	end
	cset
end

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


function single_scrape_save(url)
	println("gettin module from $url ")
	name = string(split(replace(url, r"/archive/master.zip"=>""),"/")[end])
	mkpath("tmp/$name")
	download(url, "tmp/$name/file.zip")
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
	tot = length(names)
	i = 1
	for name in names
		try
			if contains(".zip", name)
				single_scrape_save(name)
			else
				single_scrape_save(dict, name)
			end
		catch e
			println("error on name: $name")
			println(e)
			push!(fails, name)
		end
		try
			println("########## $((100*i)/len)% DONE ##########")
		catch r
		end
		i = i + 1
	end
	fails
end

function save_scrapes_from_Modules(urls)
	fails = []
	tot = length(urls)
	i = 1
	for url in urls
		try
			single_scrape_save(url)
		catch e
			println("error on url: $url")
			println(e)
			push!(fails, url)
		end
		try
			println("########## $((100*i)/len)% DONE ##########")
		catch r
		end
		i = i + 1
	end
	fails
end

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

# ╔═╡ 36915840-7894-11eb-31c0-0921e00ce8ca
function files_to_cset(dir)
	cset = nothing
	for (root, dirs, files) in walkdir(dir)
		try
			len = length(files)
			i = 1
			for file in files
				if endswith(file, ".jld2")	
					println("handling $file")
					name = string(split(file,".jld2")[1])
					tmp = Array{IEP.FunctionContainer,1}(undef,0)
					tmp = vcat(tmp, load(joinpath(root, file))[name])
					println(unique([typeof(x) for x in tmp]))
					if isnothing(cset)
						cset = IEP.get_newSchema(tmp)
					elseif isnothing(tmp)
						println("$file appears empty")
					else
						println("adding stuff...")
						for fc in tmp
							println("adding $(IEP.getName(fc.func.name))")	
							try					
								IEP.handle_FunctionContainer!(fc, cset)
							catch e
								println("error: $e")
							end
						end
					end
					tmp = nothing
				end
				println("############## $((100*i)/len)% DONE ##############")
				i = i + 1
			end
		catch e
			println("error at file: $file")
			println(e)
		end
	end
	cset
end

# ╔═╡ Cell order:
# ╠═81278630-778c-11eb-27c8-03e3def7f22b
# ╠═a3bf774e-77a7-11eb-020c-677baae4eceb
# ╠═45bc8a80-77a7-11eb-051f-f72a421f3795
# ╠═07499d00-7825-11eb-3f75-17749dc56811
# ╠═c78e78e0-7872-11eb-15c6-0b15dda320df
# ╠═281664e0-785d-11eb-192c-a3cb9ae4aa2a
# ╠═629f70f0-7882-11eb-35b2-b7de2fdfde38
# ╠═aa8eb102-785a-11eb-0e7b-5f12b8514cb9
# ╠═b93d1ffe-785b-11eb-0b87-dfaa5aaf7ad4
# ╠═78524300-783c-11eb-3045-93c3d98ff10f
# ╠═4ac94b80-788d-11eb-00e1-13a38ee9fc99
# ╠═b7a21a90-7890-11eb-0c6a-b70ff1c9345c
# ╠═9b88ce30-7890-11eb-3dae-51ecd93bdb72
# ╠═e8c6ef22-788f-11eb-3611-17cb3e3e2bb8
# ╠═6bc2bbc0-7890-11eb-090f-072d6da42eac
# ╠═36915840-7894-11eb-31c0-0921e00ce8ca
