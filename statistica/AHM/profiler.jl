### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ acc85e90-2b51-11eb-36e8-4947730831a6
using Profile, Juno

# ╔═╡ e7714e80-2b51-11eb-08b3-f58e5a92b353
include("functions/sim_fn.jl")

# ╔═╡ e1a69c30-2b51-11eb-3c3c-3341b8870c87
Profile.init(delay=0.5)

# ╔═╡ 268c3e90-2b52-11eb-0922-db4816dd921b
@profiler sim_fn()

# ╔═╡ f784e0e0-2b54-11eb-1080-f5e8c280410e
Juno.profiler()

# ╔═╡ Cell order:
# ╠═acc85e90-2b51-11eb-36e8-4947730831a6
# ╠═e7714e80-2b51-11eb-08b3-f58e5a92b353
# ╠═e1a69c30-2b51-11eb-3c3c-3341b8870c87
# ╠═268c3e90-2b52-11eb-0922-db4816dd921b
# ╠═f784e0e0-2b54-11eb-1080-f5e8c280410e
