### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ a59260c0-55b4-11eb-21cd-398de7c389ab
using Pkg

# ╔═╡ 84876de0-55bd-11eb-1511-8babb91f22cc
using Catlab

# ╔═╡ 338b0510-55c1-11eb-18b6-71bbd60ed578
using Catlab.CategoricalAlgebra

# ╔═╡ 338b2c20-55c1-11eb-3137-d17214790757
using Catlab.Theories

# ╔═╡ 338b7a42-55c1-11eb-0ea7-9724e38387a3
using LinearAlgebra

# ╔═╡ aad5a7b2-55c1-11eb-16c6-31d05163ad88
using Catlab.WiringDiagrams, Catlab.Graphics

# ╔═╡ f9fdf680-55ee-11eb-2dae-675c0d2a72ec
using LabelledArrays

# ╔═╡ f0d46820-55f6-11eb-3768-492beefc6889
using OrdinaryDiffEq

# ╔═╡ f0d48f30-55f6-11eb-338b-4152a0a60a49
using Plots

# ╔═╡ f0e9c4e0-55f6-11eb-3759-1d82781d630d
using Catlab.Programs.RelationalPrograms

# ╔═╡ aabb7be0-55b4-11eb-1cd4-87a30b75c18d
Pkg.activate(".")

# ╔═╡ b0599ff2-55b4-11eb-3946-0bd71921b404
@present TheoryGraph(FreeSchema) begin
	V::Ob
	E::Ob
	
	src::Hom(E,V)
	tgt::Hom(E,V)
end

# ╔═╡ 0e99e3e0-55b5-11eb-3056-9b526a123243
const Graph = CSetType(TheoryGraph, index = [:src, :tgt])

# ╔═╡ 437ac320-55c1-11eb-3191-d73ea721877a
begin
	g = Graph()
	add_parts!(g, :V, 3)
	add_parts!(g, :E, 4, src=[1,2,2,3], tgt=[2,3,3,3])
	
	gv = to_graphviz(g, node_labels=true, edge_labels=true)
end

# ╔═╡ 5eca8450-55c9-11eb-2f16-83ffd8ce89d5
md"[install graphviz](https://www2.graphviz.org/Packages/stable/windows/10/cmake/Release/)"

# ╔═╡ 89fb301e-55c9-11eb-16bd-d3260c79a3c3
@present TheoryLabeledGraph <: TheoryGraph begin
	X::Data
	label::Attr(V, X)
end


# ╔═╡ 4fa0e650-55d2-11eb-15fe-2d1051127dc3
const LabeledGraph = ACSetType(TheoryLabeledGraph, index = [:src, :tgt, :label])

# ╔═╡ 80053490-55d2-11eb-0fb7-73fb44897778
begin
	lg = LabeledGraph{String}()
	add_parts!(lg, :V, 3, label=["a","b","c"])
	add_parts!(lg, :E, 4, src=[1,2,2,3], tgt=[2,3,3,3])
	
	lg
end

# ╔═╡ d50accc0-55d2-11eb-2070-6fdfcc924143
md"machines"

# ╔═╡ db610a50-55df-11eb-2b86-1da744fe792a
@present TheoryMachines(FreeSchema) begin
	Box::Ob #code?
	InWire::Ob #input
	OutWire::Ob #output
	Variable::Ob
	
	parameterizes::Hom(InWire, Box)
	outputs::Hom(OutWire, Variable)
	box::Hom(Variable, Box)
	wire::Hom(InWire, OutWire)
	
	Dynamics::Data
	dynamics::Attr(Box, Dynamics)
end	

# ╔═╡ 61d81b00-55e0-11eb-100b-a7075c32e8d4
const AbstractMachine = AbstractACSetType(TheoryMachines)

# ╔═╡ bb2d3730-55e0-11eb-2828-335a1bad46a6
begin
	const Machine = ACSetType(
		TheoryMachines,
		index=[:parameterizes, :outputs, :box, :wire, :dynamics]
	)
	Machine() = Machine{Function}()
end

# ╔═╡ 7216c6f0-55e1-11eb-0c37-7b378c9e72cd
α, β, γ, δ = 0.3, 0.015, 0.015, 0.7

# ╔═╡ 94788122-55e1-11eb-3692-bfabdf79633e
dotr(r, h) = [α*r[1] - β*r[1]*h[1]]

# ╔═╡ be3ea070-55e1-11eb-3a7a-2d2935dadac8
dotf(f, e) = [γ*f[1]*e[1] - β*f[1]]

# ╔═╡ dbb86730-55e1-11eb-0856-8b4c091871e6
begin 
	lv=Machine()
	add_parts!(lv, :Box, 2, dynamics = [dotr, dotf])
	add_parts!(lv, :Variable, 2, box = [1, 2])
	add_parts!(lv, :OutWire, 2, outputs = [1, 2])
	add_parts!(lv, :InWire, 2, parameterizes = [1, 2], wire = [2, 1])
	
	lv
end

# ╔═╡ be3c92b0-55e3-11eb-09d2-0bd46ea7fbd7


# ╔═╡ 04c50510-55e3-11eb-1063-41eab0ec9767
dump(lv)

# ╔═╡ 19d579d0-55e3-11eb-294a-a9254e9036dd
to_graphviz(g)

# ╔═╡ 4db8dcb0-55e3-11eb-3a6c-a1074e749c0a
to_graphviz(g, node_labels=true, edge_labels=true)

# ╔═╡ a9f33e80-55e3-11eb-040b-bf5f45eba28f
println("##################")

# ╔═╡ b381af90-55e3-11eb-3389-83ba3c3915f4
dump(g)

# ╔═╡ 849b38a0-55ec-11eb-1435-935a0af1f00b
function vectorfield(m::AbstractMachine)
	
	function v(u, p, t)
		dotu = zeros(u)#???? da capire perché non funziona? [GS]
		for box in parts(m, :Box)
			params = view(
				u, subpart(
					m, subpart(
						m, 
						incident(m, box, :parameterizes),
						:wire												
						),
					:outputs
					)
			)
			vars = incident(m, box, :box)
			dynamics = subpart(m, box, :dynamics)
			view(dotu, vars) .= dynamics( view(u, vars), params)
		end
		dotu
	end
	
	v
end

# ╔═╡ cebf3230-55f4-11eb-00dd-cfb183ebe07a
begin
	u0 = [10.0, 100.0]
	tspan = (0.0, 100.0)
	prob = ODEProblem(vectorfield(lv), u0, tspan)
	sol =  solve(prob)
	plot(sol, 
		title= "modello predatore preda lotka volterra", 
		#label=["pred pop", "prey pop"]
		legend = false
	)
end
	

# ╔═╡ 1c4b6ef0-55fb-11eb-3fb4-91781317c65f
zero([1, 2])

# ╔═╡ 240c9a10-55fb-11eb-26b5-875ef07dea33
zeros

# ╔═╡ 117ca090-55f9-11eb-0a8f-030f186147e9
md"# machines from graphs"

# ╔═╡ 9a8e0b30-55f9-11eb-1cd6-e584ebd5fc95
alpha, beta, gamma, delta, beta2, gamma2, delta2 = 0.3, 0.015, 0.015, 0.7, 0.017, 0.017, 0.35

# ╔═╡ 22ea9a30-55f9-11eb-1294-d5ff61d77cb9
begin
	
	dotfish(f, x) = [alpha*f[1] - beta*x[1]*f[1]]
	dotFISH(F, x) = [gamma*x[1]*F[1] - delta*F[1] - beta2*x[2]*F[1] ]
	dotsharks(s, x) =  [-delta2*s[1] + gamma2*s[1]*x[1]]
	
	lv3_graph = LabeledGraph{Function}()
	add_parts!(lv3_graph, :V, 3, label = [dotfish, dotFISH, dotsharks])
	add_parts!(lv3_graph, :E, 4, src = [1,2,2,3], tgt = [2,1,3,2])
	
	lv3 = Machine()

	migrate!(lv3, lv3_graph,
		Dict(
			:InWire => :E,
			:OutWire => :E,
			:Box => :V,
			:Variable => :V
		),
		Dict(
			:parameterizes => :src,
			:outputs => :tgt,
			:wire => id(E),
			:box => id(V),
			:dynamics => :label
		)
	)
end

# ╔═╡ Cell order:
# ╠═a59260c0-55b4-11eb-21cd-398de7c389ab
# ╠═aabb7be0-55b4-11eb-1cd4-87a30b75c18d
# ╠═84876de0-55bd-11eb-1511-8babb91f22cc
# ╠═338b0510-55c1-11eb-18b6-71bbd60ed578
# ╠═338b2c20-55c1-11eb-3137-d17214790757
# ╠═338b7a42-55c1-11eb-0ea7-9724e38387a3
# ╠═aad5a7b2-55c1-11eb-16c6-31d05163ad88
# ╠═b0599ff2-55b4-11eb-3946-0bd71921b404
# ╠═0e99e3e0-55b5-11eb-3056-9b526a123243
# ╠═437ac320-55c1-11eb-3191-d73ea721877a
# ╟─5eca8450-55c9-11eb-2f16-83ffd8ce89d5
# ╠═89fb301e-55c9-11eb-16bd-d3260c79a3c3
# ╠═4fa0e650-55d2-11eb-15fe-2d1051127dc3
# ╠═80053490-55d2-11eb-0fb7-73fb44897778
# ╟─d50accc0-55d2-11eb-2070-6fdfcc924143
# ╠═db610a50-55df-11eb-2b86-1da744fe792a
# ╠═61d81b00-55e0-11eb-100b-a7075c32e8d4
# ╠═bb2d3730-55e0-11eb-2828-335a1bad46a6
# ╠═7216c6f0-55e1-11eb-0c37-7b378c9e72cd
# ╠═94788122-55e1-11eb-3692-bfabdf79633e
# ╠═be3ea070-55e1-11eb-3a7a-2d2935dadac8
# ╠═dbb86730-55e1-11eb-0856-8b4c091871e6
# ╠═be3c92b0-55e3-11eb-09d2-0bd46ea7fbd7
# ╠═04c50510-55e3-11eb-1063-41eab0ec9767
# ╠═19d579d0-55e3-11eb-294a-a9254e9036dd
# ╠═4db8dcb0-55e3-11eb-3a6c-a1074e749c0a
# ╠═a9f33e80-55e3-11eb-040b-bf5f45eba28f
# ╠═b381af90-55e3-11eb-3389-83ba3c3915f4
# ╠═849b38a0-55ec-11eb-1435-935a0af1f00b
# ╠═f9fdf680-55ee-11eb-2dae-675c0d2a72ec
# ╠═f0d46820-55f6-11eb-3768-492beefc6889
# ╠═f0d48f30-55f6-11eb-338b-4152a0a60a49
# ╠═f0e9c4e0-55f6-11eb-3759-1d82781d630d
# ╠═cebf3230-55f4-11eb-00dd-cfb183ebe07a
# ╠═1c4b6ef0-55fb-11eb-3fb4-91781317c65f
# ╠═240c9a10-55fb-11eb-26b5-875ef07dea33
# ╟─117ca090-55f9-11eb-0a8f-030f186147e9
# ╠═9a8e0b30-55f9-11eb-1cd6-e584ebd5fc95
# ╠═22ea9a30-55f9-11eb-1294-d5ff61d77cb9
