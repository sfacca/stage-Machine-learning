### A Pluto.jl notebook ###
# v0.12.12

using Markdown
using InteractiveUtils

# ╔═╡ 3921b0b0-3333-11eb-24d6-cbd16c97ae1d
using CSV, Distributions, HypothesisTests, DataFrames

# ╔═╡ 7f0d9f82-3333-11eb-3b69-cbc65b9ef353
mkpath("downloads")

# ╔═╡ 9e0b9540-3333-11eb-3221-01efa9599dab
download("https://github.com/h-Klok/StatsWithJuliaBook/raw/master/data/machine1.csv","downloads/machine1.csv")

# ╔═╡ 5dc878e0-3333-11eb-3c11-e9aef68e7beb
data = CSV.read("downloads/machine1.csv", header=false, DataFrame)[:,1]

# ╔═╡ 5dc89ff0-3333-11eb-3697-3bd6629bfa57
xBar, n = mean(data), length(data)

# ╔═╡ 5dc8ee10-3333-11eb-17a0-3d1604167975
sig = 1.2

# ╔═╡ 5dcc9790-3333-11eb-0408-57ec66f22db9
alpha = 0.1

# ╔═╡ 5dceba70-3333-11eb-1579-313f6013485f
z = quantile(Normal(),1-alpha/2)

# ╔═╡ 430e2040-3333-11eb-186f-811d4111073f
md"
Calculating formula: $(xBar - z*sig/sqrt(n), xBar + z*sig/sqrt(n))
"

# ╔═╡ 49bffe3e-3333-11eb-32eb-b90da8118271
md"
Using confint() function: $(confint(OneSampleZTest(xBar,sig,n),alpha))
"

# ╔═╡ Cell order:
# ╠═3921b0b0-3333-11eb-24d6-cbd16c97ae1d
# ╠═7f0d9f82-3333-11eb-3b69-cbc65b9ef353
# ╠═9e0b9540-3333-11eb-3221-01efa9599dab
# ╠═5dc878e0-3333-11eb-3c11-e9aef68e7beb
# ╠═5dc89ff0-3333-11eb-3697-3bd6629bfa57
# ╠═5dc8ee10-3333-11eb-17a0-3d1604167975
# ╠═5dcc9790-3333-11eb-0408-57ec66f22db9
# ╠═5dceba70-3333-11eb-1579-313f6013485f
# ╠═430e2040-3333-11eb-186f-811d4111073f
# ╠═49bffe3e-3333-11eb-32eb-b90da8118271
