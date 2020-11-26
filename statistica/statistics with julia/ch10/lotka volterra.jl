### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 4a4dfd8e-2fea-11eb-24be-af9e4dbf9efe
using Plots, LaTeXStrings; pyplot()

# ╔═╡ 6eae9f90-2feb-11eb-0c9d-add6c8724c91
md"sistema deterministico as tempo discreto"

# ╔═╡ 9a5f1f30-2fea-11eb-0f34-8ddf08df1434
a, c, d = 2, 1, 5

# ╔═╡ 9a88c740-2fea-11eb-3f51-d52cf1a65087
next(x,y) = [a*x*(1-x) - x*y, -c*y + d*x*y]

# ╔═╡ 9a891560-2fea-11eb-24a8-17846b03468a
equibPoint = [(1+c)/d ,(d*(a-1)-a*(1+c))/d]

# ╔═╡ 9a8d0d00-2fea-11eb-25ab-c7c619eb6165
initX = [0.8,0.05]

# ╔═╡ 9a8d5b20-2fea-11eb-1286-c1c571eadc31
tEnd = 100

# ╔═╡ 9a906860-2fea-11eb-1bb6-7d9be4c3d481
traj = [[] for _ in 1:tEnd]

# ╔═╡ 9a928b40-2fea-11eb-1e5e-c5ce490e0b9a
traj[1] = initX

# ╔═╡ 9a948710-2fea-11eb-0a11-4158e0132b24
for t in 2:tEnd
	traj[t] = next(traj[t-1]...)
end

# ╔═╡ 9a952350-2fea-11eb-29d8-339510833d7d
scatter([traj[1][1]], [traj[1][2]],
	c=:black, ms=10,
	label="Initial state")

# ╔═╡ 9a98a5c0-2fea-11eb-1b13-8797bb99801e
plot!(first.(traj),last.(traj),
	c=:blue, ls=:dash, m=(:dot, 5, Plots.stroke(0)),
	label="Model trajectory")

# ╔═╡ 9a9b64e0-2fea-11eb-0387-eb1dfdfbb290
scatter!([equibPoint[1]], [equibPoint[2]],
	c=:red, shape=:cross, ms=10, label="Equlibrium point",
	xlabel=L"X_1", ylabel=L"X_2")

# ╔═╡ Cell order:
# ╟─6eae9f90-2feb-11eb-0c9d-add6c8724c91
# ╠═4a4dfd8e-2fea-11eb-24be-af9e4dbf9efe
# ╠═9a5f1f30-2fea-11eb-0f34-8ddf08df1434
# ╠═9a88c740-2fea-11eb-3f51-d52cf1a65087
# ╠═9a891560-2fea-11eb-24a8-17846b03468a
# ╠═9a8d0d00-2fea-11eb-25ab-c7c619eb6165
# ╠═9a8d5b20-2fea-11eb-1286-c1c571eadc31
# ╠═9a906860-2fea-11eb-1bb6-7d9be4c3d481
# ╠═9a928b40-2fea-11eb-1e5e-c5ce490e0b9a
# ╠═9a948710-2fea-11eb-0a11-4158e0132b24
# ╠═9a952350-2fea-11eb-29d8-339510833d7d
# ╠═9a98a5c0-2fea-11eb-1b13-8797bb99801e
# ╠═9a9b64e0-2fea-11eb-0387-eb1dfdfbb290
