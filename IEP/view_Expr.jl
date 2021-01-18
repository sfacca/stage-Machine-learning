### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ a4c1bdb2-58fe-11eb-19f7-f58e7b7ddc53
include("hTree.jl")

# ╔═╡ 57bca390-58fe-11eb-31b1-49111a985552
md"takes parsed code, returns hierarchy tree of Exprs"

# ╔═╡ 1841c3c0-58ff-11eb-1a1e-858abee6798a
md"exports lnode, getrightmost, addchild!, treeList, printTree"

# ╔═╡ a6edd892-5916-11eb-292f-17ecb35b5fc2
function view_Expr(e::Expr)
	res = [e]
	if !isnothing(e.args)
		for x in e.args
			if typeof(x) == Expr
				res = vcat(res, view_Expr(x))
			end
		end
	end
	res
end

# ╔═╡ a4c196a0-58fe-11eb-3542-9b23428a13cf
function Expr_tree(e::Expr)
	# 1 creates tree of first expr
	my_tree = hTree.tree{Expr}(e)
	
	# 2 iterates over args
	if !isnothing(e.args)
		for x in e.args
			#println(typeof(x))
			if typeof(x) == Expr
				# 3 adds expressions
				view_Expr(x, my_tree.first)				
			end
		end
	end
	my_tree
end 

# ╔═╡ 8a5544b0-5903-11eb-264e-83407850815e
function Expr_tree(e::Expr, parent::hTree.lnode{Expr})
	# 1 add self to parent
	me = addchild!(parent, e)
	
	# 2 iterates over args	
	if !isnothing(e.args)
		for x in e.args
			#println(typeof(x))
			if typeof(x) == Expr
				# 3 adds expressions
				view_Expr(x, me)				
			end
		end
	end
	me
end	

# ╔═╡ Cell order:
# ╟─57bca390-58fe-11eb-31b1-49111a985552
# ╠═a4c1bdb2-58fe-11eb-19f7-f58e7b7ddc53
# ╟─1841c3c0-58ff-11eb-1a1e-858abee6798a
# ╠═a4c196a0-58fe-11eb-3542-9b23428a13cf
# ╠═8a5544b0-5903-11eb-264e-83407850815e
# ╠═a6edd892-5916-11eb-292f-17ecb35b5fc2
