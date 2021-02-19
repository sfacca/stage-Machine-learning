### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 004a2e62-6af7-11eb-334a-674f11dea480
using CSTParser

# ╔═╡ cfef1270-6af7-11eb-2e30-cb7621f171c4
using Catlab.Meta

# ╔═╡ fe837820-6af6-11eb-059f-310ad22a59d6
include("unzip.jl")

# ╔═╡ 03f86950-6af7-11eb-150f-b510ea9df5bf
include("parse_folder.jl")

# ╔═╡ 27325e40-6afb-11eb-01ac-3f5c23383812
include("scrape.jl")

# ╔═╡ ebeb2f50-6af6-11eb-35f5-abe03061eaed
begin
	mkpath("tmp_cst")
	download("https://github.com/julia-vscode/CSTParser.jl/archive/master.zip", "tmp_cst/cstparser")
	unzip("tmp_cst/cstparser")
end

# ╔═╡ f8109ef0-6af6-11eb-21da-45befb9df2a6
raw = read_code("tmp_cst/CSTParser.jl-master/src");

# ╔═╡ f99aa4e0-6af7-11eb-074b-7b5dbec3ab2b
function get_usings(e::CSTParser.EXPR)
	vcat(find_heads(e, :using), find_heads(e, :import))
end

# ╔═╡ ea661c50-6afe-11eb-3ff7-c349e63f3cbd
[scrapeName for x in ]

# ╔═╡ a18db48e-6b01-11eb-20f9-b5946ca98325
function get_using_names(e::CSTParser.EXPR)
	[scrapeName(x.args[1]) for x in find_heads(e, :using)]
end

# ╔═╡ 71590400-6b10-11eb-0014-c768dc2891a9
typeof(raw)

# ╔═╡ 89c69100-6b11-11eb-03aa-ed922a21209d
typeof(raw[1])

# ╔═╡ dff0abfe-6b11-11eb-2e42-e9b93755a861
typeof(raw[1][1])

# ╔═╡ d36cda9e-6b0f-11eb-34b8-db44d2dbe044
function get_using_names(arr::Array{Any,1})#array of tuples
	sources = [x[2] for x in arr]
	usings = Array{Any,1}(undef, length(arr))
	for i in 1:length(arr)
		try
			usings[i] = get_using_names(arr[i][1])
		catch err
			println(err)
			usings[i] = err
		end
	end
	return sources, usings
end

# ╔═╡ b6073820-6b0f-11eb-3706-65178b1787d5
unique([x for x in get_using_names(raw)[2]])

# ╔═╡ c0947300-6af8-11eb-2d38-73f76f80789e
function get_usings(arr::Array{Any,1})#(arr::Array{Tuple{CSTParser.EXPR,String},1})
	sources = [x[2] for x in arr]
	usings = Array{Any,1}(undef, length(arr))
	for i in 1:length(arr)
		try
			usings[i] = get_usings(arr[i][1])
		catch err
			println(err)
			usings[i] = err
		end
	end
	return sources, usings
end

# ╔═╡ eaaa2700-6afa-11eb-296a-a5394657d52b
sources, usings = get_usings(raw)

# ╔═╡ 0d758960-6b04-11eb-0073-31c268211e97
sampl_us = unique(usings)[1]

# ╔═╡ 1cca8e10-6b04-11eb-13c6-ad28bf748934
sampl_us.args

# ╔═╡ ce399610-6afe-11eb-1a6b-b912875f8ff7
unique(usings)

# ╔═╡ 062fbee0-6afb-11eb-3857-295b9cf4fdb4
filter((x)->(x != []), usings)

# ╔═╡ 700d92e0-6afd-11eb-182b-3faa43b2955a
begin
	ass = []
	for i in 1:length(usings)
		if usings[i] != []
			push!(ass, i)
		end
	end
end
			
	

# ╔═╡ a7d20080-6afd-11eb-001a-757388b2790b
sources[ass]

# ╔═╡ aff71d90-6afd-11eb-106a-5b279fad767d
unique(sources)

# ╔═╡ c59126f0-6af8-11eb-00c3-71236ae6f979
typeof(raw)

# ╔═╡ dcd2ac7e-6af8-11eb-15c9-4d722075f7b9
unique([typeof(x) for x in raw])

# ╔═╡ d456e3f0-6af8-11eb-1706-b9ccfd77c2ef
typeof(raw[1])

# ╔═╡ 6b6d3e80-6af7-11eb-05b3-0f23635f3806
sampl = CSTParser.parse("begin
	using CSTParser
	using Catlab.Meta, Catlab.Rewrite
end")

# ╔═╡ 039656b0-6af8-11eb-3d22-cf122a6a23fe
sampl.args[1].head

# ╔═╡ Cell order:
# ╠═004a2e62-6af7-11eb-334a-674f11dea480
# ╠═fe837820-6af6-11eb-059f-310ad22a59d6
# ╠═03f86950-6af7-11eb-150f-b510ea9df5bf
# ╠═ebeb2f50-6af6-11eb-35f5-abe03061eaed
# ╠═f8109ef0-6af6-11eb-21da-45befb9df2a6
# ╠═27325e40-6afb-11eb-01ac-3f5c23383812
# ╠═f99aa4e0-6af7-11eb-074b-7b5dbec3ab2b
# ╠═ea661c50-6afe-11eb-3ff7-c349e63f3cbd
# ╠═a18db48e-6b01-11eb-20f9-b5946ca98325
# ╠═71590400-6b10-11eb-0014-c768dc2891a9
# ╠═89c69100-6b11-11eb-03aa-ed922a21209d
# ╠═dff0abfe-6b11-11eb-2e42-e9b93755a861
# ╠═d36cda9e-6b0f-11eb-34b8-db44d2dbe044
# ╠═b6073820-6b0f-11eb-3706-65178b1787d5
# ╠═0d758960-6b04-11eb-0073-31c268211e97
# ╠═1cca8e10-6b04-11eb-13c6-ad28bf748934
# ╠═ce399610-6afe-11eb-1a6b-b912875f8ff7
# ╠═c0947300-6af8-11eb-2d38-73f76f80789e
# ╠═eaaa2700-6afa-11eb-296a-a5394657d52b
# ╠═062fbee0-6afb-11eb-3857-295b9cf4fdb4
# ╠═700d92e0-6afd-11eb-182b-3faa43b2955a
# ╠═a7d20080-6afd-11eb-001a-757388b2790b
# ╠═aff71d90-6afd-11eb-106a-5b279fad767d
# ╠═c59126f0-6af8-11eb-00c3-71236ae6f979
# ╠═dcd2ac7e-6af8-11eb-15c9-4d722075f7b9
# ╠═d456e3f0-6af8-11eb-1706-b9ccfd77c2ef
# ╠═6b6d3e80-6af7-11eb-05b3-0f23635f3806
# ╠═039656b0-6af8-11eb-3d22-cf122a6a23fe
# ╠═cfef1270-6af7-11eb-2e30-cb7621f171c4
