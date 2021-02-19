### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 30f84500-51cb-11eb-01a9-b1e18f1780fb
include("./parse.jl")

# ╔═╡ 0a96d380-51d6-11eb-317a-c5c3ff646b64
md"* on wiring diagrams: [https://arxiv.org/pdf/1512.01602.pdf](https://arxiv.org/pdf/1512.01602.pdf)"

# ╔═╡ f14a6a20-51d2-11eb-15d2-7b32b228dd8b


# ╔═╡ 78491e30-51cf-11eb-186c-1dc4d0a44d9d
# get code
target = "./parse.jl"

# ╔═╡ d6af26b0-51dc-11eb-0d70-6b8b9414c89d
function clean_code(code::String)
	# switches "s with uncommon strings else regex breaks
	#code = replace(code, r"""(\"{3})""" => s"\"")
	#code = replace(code, r"""(\")""" => s"OaOaO")	
	#removes strings
	#code = replace(code, r"""(OaOaO)(.*\n*)*(OaOaO)/U"""=>s"")
	#removes comments
	code = replace(code, r"#=(.*|\n*)*=#/gU"=>s"")
	#replace(code, r"#.*" => s"")
end
		

# ╔═╡ bfa04280-51df-11eb-3faa-2763086a8590
function m_pars(path)
	write(string(path,"_fixed.jl"), (clean_code(read(path, String))) )
	res = Parsers.parsefile(string(path,"_fixed.jl"))
	rm(string(path,"_fixed.jl"))
	res
end

# ╔═╡ 28467780-51fb-11eb-0d3c-eda68da4799c
function _test(path)
	write(string(path,"_fixed.jl"), (clean_code(read(path, String))) )
	read(string(path,"_fixed.jl"))
end

# ╔═╡ 3fac4230-51e0-11eb-0173-3928564111bb
_test("./test_file.txt")

# ╔═╡ ef397892-51df-11eb-0bae-d57f01f97105
parsefile

# ╔═╡ a94db0d0-51df-11eb-38da-574a009ea506
first_pars = m_pars("./parse.jl")

# ╔═╡ 6d946ce0-51e0-11eb-0420-c994980bd9e7
first_pars

# ╔═╡ 1e083a10-51dd-11eb-2fb2-933048de2e47
cod = """ asd #comment
println("ads dsa") #comm2
ddd
##############
# asd
##############
"""

# ╔═╡ bb115670-51dd-11eb-0031-25ac09736ee4
cd2 = "asd
#comment
"

# ╔═╡ d1af9720-51dd-11eb-3741-85e345f235d2
clean_code

# ╔═╡ 319da790-51dd-11eb-3432-4b741f4423e8
clean_code(cod)

# ╔═╡ c37c2f10-51dd-11eb-3c0a-09afd85e1194
clean_code(cd2)

# ╔═╡ 371de362-51dd-11eb-3a6b-e1f6d2f0216a
cod

# ╔═╡ bc7ad9e0-51cf-11eb-276c-f712cc98978f
function remove_issue(a)    
    if a == '_'
        'T'
    else
        if a == '$'
            'X'
        else
            a
        end
    end
end

# ╔═╡ ada601b0-51cf-11eb-30c2-fbabde2a37aa
function fix_file(path)
    write(string(path,"_fixed.jl"),map(remove_issue,read(path, String)))
    string(path,"_fixed.jl")
end

# ╔═╡ a940d2d0-51cf-11eb-334a-2f5673a04087
function parse_file(path::AbstractString) 
    temp = fix_file(path)
    res = SemanticModels.ExprModels.Parsers.parsefile(temp)
    rm(temp)
    res
end

# ╔═╡ d8c8f1e0-51cf-11eb-0ef5-e5d88514491d
arrstr = Array{Char,1}("asd #comment
fgh")

# ╔═╡ e01d2a60-51cf-11eb-2928-ef27b7bc2fda
function remove_hash_comments!(str, i)
	while(str[i] != '\n')
		println(typeof(str[i]))
		#str[i] = ""
		i = i + 1
	end
	i
end

# ╔═╡ 4e2f4420-51d0-11eb-080c-7da8494cc885
function find_rem_hash(str)
	i = 1
	while i<=length(str)
		if str[i] == '#'
			last = remove_hash_comments!(str, i)
			str[i:last] .= ' '
		end
		i = i + 1
	end
	str
end
		

# ╔═╡ 6565fdd0-51dc-11eb-3ef7-dbc030cf587b
md"[regex matching](https://regex101.com/r/wzWGn2/1)"

# ╔═╡ 20421390-51d4-11eb-3dc5-35fd7cb45b13
ndims

# ╔═╡ bd7e6300-51d6-11eb-063f-239aa68770a3
regexp = r"#.*"

# ╔═╡ d068ea80-51d6-11eb-0ce0-7d6ca2858972
str = "asd # comment
dsa
# 
"

# ╔═╡ c8fca4e0-51d0-11eb-07aa-0554b4f89c01
find_rem_hash(str)

# ╔═╡ 6f4335b0-51dd-11eb-05c4-eb763a59517b
function replace!(string, args...)
	string = replace(string, args...)
end

# ╔═╡ 2b995dc0-51d4-11eb-38ed-c7d844010c7b
occursin(regexp, str)

# ╔═╡ 357cbab0-51d6-11eb-0407-b13b5cba28b7
str2 = replace(str, regexp=>s"")

# ╔═╡ ccc931b0-51da-11eb-1b31-630db3f46fe8
str

# ╔═╡ a34962d0-51dd-11eb-24bf-f74b3d0dbda2
str2

# ╔═╡ Cell order:
# ╠═0a96d380-51d6-11eb-317a-c5c3ff646b64
# ╠═30f84500-51cb-11eb-01a9-b1e18f1780fb
# ╠═f14a6a20-51d2-11eb-15d2-7b32b228dd8b
# ╠═78491e30-51cf-11eb-186c-1dc4d0a44d9d
# ╠═ada601b0-51cf-11eb-30c2-fbabde2a37aa
# ╠═a940d2d0-51cf-11eb-334a-2f5673a04087
# ╠═d6af26b0-51dc-11eb-0d70-6b8b9414c89d
# ╠═bfa04280-51df-11eb-3faa-2763086a8590
# ╠═28467780-51fb-11eb-0d3c-eda68da4799c
# ╠═3fac4230-51e0-11eb-0173-3928564111bb
# ╠═ef397892-51df-11eb-0bae-d57f01f97105
# ╠═a94db0d0-51df-11eb-38da-574a009ea506
# ╠═6d946ce0-51e0-11eb-0420-c994980bd9e7
# ╠═1e083a10-51dd-11eb-2fb2-933048de2e47
# ╠═bb115670-51dd-11eb-0031-25ac09736ee4
# ╠═d1af9720-51dd-11eb-3741-85e345f235d2
# ╠═319da790-51dd-11eb-3432-4b741f4423e8
# ╠═c37c2f10-51dd-11eb-3c0a-09afd85e1194
# ╠═371de362-51dd-11eb-3a6b-e1f6d2f0216a
# ╠═bc7ad9e0-51cf-11eb-276c-f712cc98978f
# ╠═d8c8f1e0-51cf-11eb-0ef5-e5d88514491d
# ╠═e01d2a60-51cf-11eb-2928-ef27b7bc2fda
# ╠═4e2f4420-51d0-11eb-080c-7da8494cc885
# ╠═c8fca4e0-51d0-11eb-07aa-0554b4f89c01
# ╟─6565fdd0-51dc-11eb-3ef7-dbc030cf587b
# ╠═20421390-51d4-11eb-3dc5-35fd7cb45b13
# ╠═bd7e6300-51d6-11eb-063f-239aa68770a3
# ╠═d068ea80-51d6-11eb-0ce0-7d6ca2858972
# ╠═6f4335b0-51dd-11eb-05c4-eb763a59517b
# ╠═2b995dc0-51d4-11eb-38ed-c7d844010c7b
# ╠═357cbab0-51d6-11eb-0407-b13b5cba28b7
# ╠═ccc931b0-51da-11eb-1b31-630db3f46fe8
# ╠═a34962d0-51dd-11eb-24bf-f74b3d0dbda2
