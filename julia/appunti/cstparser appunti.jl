### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ e7d57490-1dc9-11eb-090e-01dca19a3a33
using CSTParser

# ╔═╡ 0b92a012-1dca-11eb-087f-3d268025df1a
md"definiamo una funzione di prova"

# ╔═╡ 00156c70-1dcc-11eb-35b7-a7ac8182cfc2
str = "function foo(x)
	y = 5
	arr = [1,2,3,4,5]
	if x > 5
		y = 12
	end	
	for i in arr
		i = i + x + y
	end	
	return y
end"

# ╔═╡ 39939800-1dcc-11eb-02c6-e10bd9069e98
res = CSTParser.parse(str)

# ╔═╡ a14a3120-1dcc-11eb-2573-93e0f25c71f2
typeof(res)

# ╔═╡ 632cba40-1dd4-11eb-02e6-9b63759d2d40
dump(res)

# ╔═╡ d7001070-1dd4-11eb-0976-79c21e54bdb1
res

# ╔═╡ c499deb0-1dd5-11eb-342f-bda868aaf17c
res[2]

# ╔═╡ bbfa64b0-1dd9-11eb-27ee-cb4ff22a2d8f
res[3]

# ╔═╡ c83d204e-1dd9-11eb-2e68-354d8414af62
res[1]

# ╔═╡ 6d38d80e-1dda-11eb-2f8c-5902c4971a55
res[4]

# ╔═╡ ab393060-1dda-11eb-1c25-a519f614c615
res[3][1]

# ╔═╡ Cell order:
# ╠═e7d57490-1dc9-11eb-090e-01dca19a3a33
# ╟─0b92a012-1dca-11eb-087f-3d268025df1a
# ╠═00156c70-1dcc-11eb-35b7-a7ac8182cfc2
# ╠═39939800-1dcc-11eb-02c6-e10bd9069e98
# ╠═a14a3120-1dcc-11eb-2573-93e0f25c71f2
# ╠═632cba40-1dd4-11eb-02e6-9b63759d2d40
# ╠═d7001070-1dd4-11eb-0976-79c21e54bdb1
# ╠═c499deb0-1dd5-11eb-342f-bda868aaf17c
# ╠═bbfa64b0-1dd9-11eb-27ee-cb4ff22a2d8f
# ╠═c83d204e-1dd9-11eb-2e68-354d8414af62
# ╠═6d38d80e-1dda-11eb-2f8c-5902c4971a55
# ╠═ab393060-1dda-11eb-1c25-a519f614c615
