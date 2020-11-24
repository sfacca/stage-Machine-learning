### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 1a97ae70-2e7d-11eb-2f9d-4d73f9b5a173
using BenchmarkTools

# ╔═╡ e7714e80-2b51-11eb-08b3-f58e5a92b353
include("functions/sim_fn.jl")

# ╔═╡ acc85e90-2b51-11eb-36e8-4947730831a6
#using Profile, Juno

# ╔═╡ e1a69c30-2b51-11eb-3c3c-3341b8870c87
#Profile.init(delay=0.5)

# ╔═╡ 268c3e90-2b52-11eb-0922-db4816dd921b
#@profiler sim_fn()

# ╔═╡ f784e0e0-2b54-11eb-1080-f5e8c280410e
#Juno.profiler()

# ╔═╡ 24d7bc40-2e7d-11eb-349e-d535650dad2e
@btime sim_fn()

# ╔═╡ 3e8a8890-2e80-11eb-17a3-ff34d45be585
md" @btime doesnt show on notebook, use @benchmark"

# ╔═╡ 52536220-2e80-11eb-3b79-a33ed8fada85
@benchmark sim_fn()

# ╔═╡ Cell order:
# ╠═acc85e90-2b51-11eb-36e8-4947730831a6
# ╠═e7714e80-2b51-11eb-08b3-f58e5a92b353
# ╠═e1a69c30-2b51-11eb-3c3c-3341b8870c87
# ╠═268c3e90-2b52-11eb-0922-db4816dd921b
# ╠═f784e0e0-2b54-11eb-1080-f5e8c280410e
# ╠═1a97ae70-2e7d-11eb-2f9d-4d73f9b5a173
# ╠═24d7bc40-2e7d-11eb-349e-d535650dad2e
# ╟─3e8a8890-2e80-11eb-17a3-ff34d45be585
# ╠═52536220-2e80-11eb-3b79-a33ed8fada85
