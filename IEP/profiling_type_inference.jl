### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 2f82d750-6a1a-11eb-30e1-5b56252cee1e
LOAD_PATH

# ╔═╡ e52d9d20-6a28-11eb-3cf6-a712ca13d24c
using CSTParser

# ╔═╡ 2f1431d0-6a2c-11eb-379d-73d04ba3ef9e
using Pkg

# ╔═╡ 37381660-6a2c-11eb-30b0-130e3fea8953
using MethodAnalysis

# ╔═╡ 7d83ff80-6a2c-11eb-28d7-d13eb6fe77e9
using AbstractTrees

# ╔═╡ 3263f910-6a2c-11eb-06e4-07595f29a181
Pkg.activate(".")

# ╔═╡ b6dcefd0-6a2c-11eb-1e0e-d9d38050dd74
#Pkg.add("AbstractTrees")

# ╔═╡ ebaa8870-6a28-11eb-1a7c-556bd913ba47
sample_parse = CSTParser.parse("function foo(x::Int, y::Int)
	x + y
end")

# ╔═╡ 42f5c6b0-6a30-11eb-035e-afec9061ef83
dep_parse = CSTParser.parse(read("sample/function_dependancy.jl", String), true)

# ╔═╡ bb5e8380-6a30-11eb-3d96-2f5821f072d9
methodinstance(foo1, (Int))

# ╔═╡ 72b76c50-6a30-11eb-1a67-55b60e412eaa
function find_functions(e::CSTParser.EXPR)
	if e.head == :function
		res = [e]
	else
		res = []
	end
	if !isnothing(e.args) && !isempty(e.args)
		for expr in e.args
			res = vcat(res, find_functions(expr))
		end
	end
	res
end

# ╔═╡ ad991f80-6a30-11eb-2731-7b7b7cf3c37f
funcs = find_functions(dep_parse)

# ╔═╡ cead2400-6a30-11eb-3941-ffc8f673fe1c
eval(Expr(funcs[1]))

# ╔═╡ d39f0280-6a30-11eb-1d64-eff27ef736e5
eval(Expr(funcs[2]))

# ╔═╡ 3bab3d10-6a2e-11eb-2762-99805459a4e4
"asdf" + "fewa"

# ╔═╡ 076d505e-6a29-11eb-1085-99174cea2147
eval(Expr(sample_parse))(1,2)

# ╔═╡ 4c8e1b70-6a33-11eb-2779-ab28f800b0c4
precompile(foo2, (Int))

# ╔═╡ 1c7e07ae-6a33-11eb-22c0-a58c5c97c757
typeof(typeof(foo))

# ╔═╡ 31fe2e30-6a33-11eb-044a-9756009e9fbc
foo(12)

# ╔═╡ 54dd3d70-6a2d-11eb-1803-cf4c42734f58
mi = methodinstance(foo, (Int, Int))

# ╔═╡ 8ffd9cc0-6a2c-11eb-2be5-5fbf9f8ec950
methodinstance(eval(Expr(sample_parse)), (Int, Int))

# ╔═╡ e384bb00-6a1b-11eb-101f-c1ddc3e9116a
precompile(eval(Expr(sample_parse)), (Int, Int))

# ╔═╡ 5d5538a0-6a31-11eb-2f31-452c51605781
precompile(eval(Expr(funcs[2])), (Int, Int))

# ╔═╡ 6aada9fe-6a31-11eb-1c8f-c58a4e836852
precompile(eval(Expr(funcs[1])), (Int, Int))

# ╔═╡ 3e3207a0-6a31-11eb-1117-ed199d05098a
double(x::Real) = 2x

# ╔═╡ 3fb52530-6a31-11eb-2cad-7d1e6361d271
calldouble(container) = double(container[1])

# ╔═╡ 3fb54c3e-6a31-11eb-3eee-4f3d73e08619
calldouble2(container) = calldouble(container)

# ╔═╡ 411180e0-6a31-11eb-1c74-216664752b5d
mo = methodinstance(double, (Float64,))

# ╔═╡ 26594850-6a77-11eb-2326-3f9f79a75ee7
for x in funcs
	if precompile(eval(Expr(x)), (Int, Int))
		println(x, "true")
	else
		println(x, "false")
	end
end

# ╔═╡ Cell order:
# ╠═2f82d750-6a1a-11eb-30e1-5b56252cee1e
# ╠═e52d9d20-6a28-11eb-3cf6-a712ca13d24c
# ╠═2f1431d0-6a2c-11eb-379d-73d04ba3ef9e
# ╠═3263f910-6a2c-11eb-06e4-07595f29a181
# ╠═b6dcefd0-6a2c-11eb-1e0e-d9d38050dd74
# ╠═37381660-6a2c-11eb-30b0-130e3fea8953
# ╠═7d83ff80-6a2c-11eb-28d7-d13eb6fe77e9
# ╠═ebaa8870-6a28-11eb-1a7c-556bd913ba47
# ╠═42f5c6b0-6a30-11eb-035e-afec9061ef83
# ╠═ad991f80-6a30-11eb-2731-7b7b7cf3c37f
# ╠═cead2400-6a30-11eb-3941-ffc8f673fe1c
# ╠═d39f0280-6a30-11eb-1d64-eff27ef736e5
# ╠═bb5e8380-6a30-11eb-3d96-2f5821f072d9
# ╠═72b76c50-6a30-11eb-1a67-55b60e412eaa
# ╠═3bab3d10-6a2e-11eb-2762-99805459a4e4
# ╠═076d505e-6a29-11eb-1085-99174cea2147
# ╠═4c8e1b70-6a33-11eb-2779-ab28f800b0c4
# ╠═1c7e07ae-6a33-11eb-22c0-a58c5c97c757
# ╠═31fe2e30-6a33-11eb-044a-9756009e9fbc
# ╠═54dd3d70-6a2d-11eb-1803-cf4c42734f58
# ╠═8ffd9cc0-6a2c-11eb-2be5-5fbf9f8ec950
# ╠═e384bb00-6a1b-11eb-101f-c1ddc3e9116a
# ╠═5d5538a0-6a31-11eb-2f31-452c51605781
# ╠═6aada9fe-6a31-11eb-1c8f-c58a4e836852
# ╠═3e3207a0-6a31-11eb-1117-ed199d05098a
# ╠═3fb52530-6a31-11eb-2cad-7d1e6361d271
# ╠═3fb54c3e-6a31-11eb-3eee-4f3d73e08619
# ╠═411180e0-6a31-11eb-1c74-216664752b5d
# ╠═26594850-6a77-11eb-2326-3f9f79a75ee7
