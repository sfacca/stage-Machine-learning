### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils
using TextAnalysis
using WordTokenizers

# ╔═╡ 45bc8a80-77a7-11eb-051f-f72a421f3795
using Pkg, CSTParser, FileIO, JLD2

# ╔═╡ 81278630-778c-11eb-27c8-03e3def7f22b
try
	IEP
catch
	println("including IEP...")
	include("../IEP.jl")
end

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
					tmp = Array{IEP.FuncDef,1}(undef,0)
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
	println("Module $name")
	mkpath("tmp/$name")
	println("downloading...")
	download(dict[name], "tmp/$name/file.zip")
	println("unzipping...")
	unzip("tmp/$name/file.zip","tmp/$name")
	println("parsing...")
	parse = IEP.read_code("tmp/$name")
	println("scraping...")
	scrape = IEP.scrape(parse)
	save("scrapes/$(name).jld2", Dict(name => scrape))
	println("cleanup...")
	rm("tmp/$name", recursive = true)
	scrape = nothing
	parse = nothing
end


function single_scrape_save(url)
	println("Module from $url ")
	name = string(split(replace(url, r"/archive/master.zip"=>""),"/")[end])
	mkpath("tmp/$name")
	println("downloading...")
	download(url, "tmp/$name/file.zip")
	println("unzipping...")
	unzip("tmp/$name/file.zip","tmp/$name")
	println("parsing...")
	parse = IEP.read_code("tmp/$name")
	scrape = IEP.scrape(parse)
	println("scraping...")
	save("scrapes/$(name).jld2", Dict(name => scrape))
	println("cleanup...")
	rm("tmp/$name", recursive = true)
	scrape = nothing
	parse = nothing
end

function __get_mod(dict, name)
	println("Module $name")
	mkpath("tmp/$name")
	println("downloading...")
	download(dict[name], "tmp/$name/file.zip")
	println("unzipping...")
	unzip("tmp/$name/file.zip","tmp/$name")
	println("parsing...")
	scrape = IEP.read_folder("tmp/$name")
	println("scraping...")
	#scrape = IEP.scrape(parse)
	save("scrapes/$(name).jld2", Dict(name => scrape))
	println("cleanup...")
	rm("tmp/$name", recursive = true)
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
			if contains(name, ".zip")
				single_scrape_save(name)
			else
				single_scrape_save(dict, name)
			end
		catch e
			println("error on name: $name")
			println(e)
			push!(fails, (name, e))
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
function _in_src(fda::Array{IEP.FuncDef,1})
	res = Array{IEP.FuncDef,1}(undef,0)
	for fd in fda
		if _in_src(fd.source)
			push!(res, fd)
		end
	end
	res
end

# ╔═╡ 9b88ce30-7890-11eb-3dae-51ecd93bdb72
function _in_src(fd::IEP.FuncDef)
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
				tmp = Array{IEP.FuncDef,1}(undef,0)
				tmp = vcat(tmp, load(joinpath(root, file))[name])
				println(unique([typeof(x) for x in tmp]))
				#for item in _in_src(tmp)
				for fc in tmp
					if _in_src(fc.source)
						dict = merge(dict, IEP.make_head_expr_dict(fc.func.block))
					end
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
					tmp = Array{IEP.FuncDef,1}(undef,0)
					tmp = vcat(tmp, load(joinpath(root, file))[name])
					#println(unique([typeof(x) for x in tmp]))
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

function make_scrape_from_zip(root, zipfile)
	name = __get_name(root)	
	mkpath("tmp")
	unzip(joinpath(root, zipfile),"tmp/$(name)")
	println("parse + scrape $(name)...")
	scrape = IEP.read_folder("tmp/$(name)")
	save("scrapes/$(name).jld2", Dict(name => scrape))
	println("cleanup...")
	rm("tmp/$(name)", recursive=true)
end

function make_dfb_from_jld2(root, file)
	save("dfbs/$file", Dict(splitext(file)[1] => IEP.file_to_doc_fun_block(root, file)))
end

function make_bag_from_jld2(root, file, stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize)
	save("bags/$file", Dict(splitext(file)[1] => IEP.file_to_bags(root, file, stemmer, tokenizer)))
end

function __get_name(root)
	split(root, "\\")[end]
end

function make_scrapes_from_zips(dir)
	i = 0
	count = 0
	fails = []

	for (root, dirs, files) in walkdir(dir)
		for file in files
			if !isfile("scrapes/$(__get_name(root)).jld2")
				count += 1
			end
		end
	end

	for (root, dirs, files) in walkdir(dir)
		for file in files
			if !isfile("scrapes/$(__get_name(root)).jld2") && endswith(file, ".zip")
				try
					make_scrape_from_zip(root, file)					
				catch e
					println(e)
					push!(fails, (joinpath(root, file), e ))
				end
				i += 1
				println("handled zip $(i) of $(count)")		
			end	
		end
	end
	println("failed $(length(fails)) files")
	fails
end

function make_dfbs_from_dir(dir)
	i = 0
	count = 0
	fails = []

	for (root, dirs, files) in walkdir(dir)
		for file in files
			if !isfile("dfbs/$(__get_name(root)).jld2")
				count += 1
			end
		end
	end

	for (root, dirs, files) in walkdir(dir)
		for file in files
			if !isfile("dfbs/$(__get_name(root)).jld2") && endswith(file, ".jld2")
				try
					make_dfb_from_jld2(root, file)					
				catch e
					println(e)
					push!(fails, (joinpath(root, file), e ))
				end
				i += 1
				println("handled file $(i) of $(count)")		
			end	
		end
	end
	println("failed $(length(fails)) files")
	fails
end

function make_bags_from_dir(dir)
	i = 0
	count = 0
	fails = []

	for (root, dirs, files) in walkdir(dir)
		for file in files
			if !isfile("bags/$(__get_name(root)).jld2")
				count += 1
			end
		end
	end
	stemmer=Stemmer("english")
	tokenizer=punctuation_space_tokenize
	for (root, dirs, files) in walkdir(dir)
		for file in files
			if !isfile("bags/$(__get_name(root)).jld2") && endswith(file, ".jld2")
				#try
					make_bag_from_jld2(root, file, stemmer, tokenizer)					
				#catch e
				#	println(e)
				#	push!(fails, (joinpath(root, file), e ))
				#end
				i += 1
				println("handled file $(i) of $(count)")		
			end	
		end
	end
	println("failed $(length(fails)) files")
	fails
end

function make_cset(dir,return_errors =false)

	num = 0
	for (root, dirs, files) in walkdir(dir)
		for file in files
			if endswith(file, ".jld2")
				num += 1
			end
		end
	end
	cset = nothing
	i = 0
	for (root, dirs, files) in walkdir(dir)
		for file in files
			if endswith(file, ".jld2")
				println("adding file $file")
				tmp = load(joinpath(root, file))[splitext(file)[1]]
				if isnothing(cset)
					cset = IEP.get_newSchema(tmp)
				else
					if return_errors
						cset, tmp_fails = IEP.handle_Scrape(tmp, cset; return_errors)
						fails = vcat(fails, tmp_fails)
					else
						cset = IEP.handle_Scrape(tmp, cset)
					end
				end
				i += 1
				println("added file $file , $i / $num done")
			end
		end
	end
	if return_errors
		cset, fails
	else 
		cset
	end
end

function add_to_cset(cset, dir::String,return_errors = false)
	num = 0
	for (root, dirs, files) in walkdir(dir)
		for file in files
			if endswith(file, ".jld2")
				num += 1
			end
		end
	end
	i = 0
	for (root, dirs, files) in walkdir(dir)
		for file in files
			if endswith(file, ".jld2")
				println("adding file $file")
				tmp = load(joinpath(root, file))[splitext(file)[1]]
				if return_errors
					cset, tmp_fails = IEP.handle_Scrape(tmp, cset; return_errors)
					fails = vcat(fails, tmp_fails)
				else
					cset = IEP.handle_Scrape(tmp, cset)
				end
				i += 1
				println("added file $file , $i / $num done")
			end
		end
	end
	if return_errors
		cset, fails
	else 
		cset
	end
end