### A Pluto.jl notebook ###
# v0.12.12

using Markdown
using InteractiveUtils

# ╔═╡ d09bcb90-3330-11eb-2ac1-8f6dd471a7cf
using DataFrames, GLM, Statistics, LinearAlgebra, CSV

# ╔═╡ a1c94b70-3331-11eb-1360-179455590653
mkpath("downloads")

# ╔═╡ a1c99990-3331-11eb-267c-2becd60cf5f7
download("https://github.com/h-Klok/StatsWithJuliaBook/raw/master/data/L1L2data.csv","downloads/L1L2data.csv")

# ╔═╡ a1c9c0a0-3331-11eb-135b-63656ae84866
data = CSV.read("downloads/L1L2data.csv", DataFrame)

# ╔═╡ a1cec9b0-3331-11eb-2935-33ea49d8fd7b
xVals, yVals = data[:,1], data[:,2]

# ╔═╡ a1d0ec92-3331-11eb-01e7-25413578c04f
n = length(xVals)

# ╔═╡ a1d13ab0-3331-11eb-1f16-f352023ed22e
A = [ones(n) xVals]

# ╔═╡ a1d4bd20-3331-11eb-0200-c1487d46b25c
begin
	# Approach A
	xBar, yBar = mean(xVals),mean(yVals)
	sXX, sXY = ones(n)'*(xVals.-xBar).^2 , dot(xVals.-xBar,yVals.-yBar)
	b1A = sXY/sXX
	b0A = yBar - b1A*xBar
end

# ╔═╡ a1d77c40-3331-11eb-34d5-4de44c317b5b
begin
	# Approach B
	b1B = cor(xVals,yVals)*(std(yVals)/std(xVals))
	b0B = yBar - b1B*xBar
end

# ╔═╡ a1d7ca60-3331-11eb-0b7a-2f22b84acaa4
begin
		# Approach C
	b0C, b1C = A'A \ A'yVals
end

# ╔═╡ a1db9af0-3331-11eb-091f-b97fd708bcf2
begin
		# Approach D
	Adag = inv(A'*A)*A'
	b0D, b1D = Adag*yVals
end

# ╔═╡ a1de5a10-3331-11eb-1924-634d5960b008
begin
	# Approach E
	b0E, b1E = pinv(A)*yVals
end

# ╔═╡ a1e07cf2-3331-11eb-1334-2ffb24974c47
begin
	# Approach F
	b0F, b1F = A\yVals
end

# ╔═╡ a1e31500-3331-11eb-2375-15b3748dda9b
begin
	# Approach G
	Fg = qr(A)
	Q, R = Fg.Q, Fg.R
	b0G, b1G = (inv(R)*Q')*yVals
end

# ╔═╡ a1e58600-3331-11eb-33c7-4535d925ea5f
begin
	# Approach H
	Fh = svd(A)
	V, Sp, Us = Fh.V, Diagonal(1 ./ Fh.S), Fh.U'
	b0H, b1H = (V*Sp*Us)*yVals
end

# ╔═╡ a1e84520-3331-11eb-09c6-a532df4fa9ab
begin
	# Approach I
	eta, meps = 0.002, 10^-6.
	b, bPrev = [0,0], [1,1]
	while norm(bPrev-b) >= meps
		global bPrev = b
		global b = b - eta*2*A'*(A*b - yVals)
	end
	b0I, b1I = b[1], b[2]
end

# ╔═╡ a1eadd30-3331-11eb-1fa4-5f1b7b6b50df
begin
	# Approach J
	modelJ = lm(@formula(Y ~ X), data)
	b0J, b1J = coef(modelJ)
end

# ╔═╡ a1edea70-3331-11eb-2993-7f694dba6337
begin
	# Approach K
	modelK = glm(@formula(Y ~ X), data, Normal())
	b0K, b1K = coef(modelK)
end

# ╔═╡ ed50ed50-3331-11eb-0941-07bb42a7dcd8
md"
1: $(round.([b0A,b0B,b0C,b0D,b0E,b0F,b0G,b0H,b0I,b0J,b0K],digits=3))  


2: $(round.([b1A,b1B,b1C,b1D,b1E,b1F,b1G,b1H,b1I,b1J,b1K],digits=3))  

"

# ╔═╡ Cell order:
# ╠═d09bcb90-3330-11eb-2ac1-8f6dd471a7cf
# ╠═a1c94b70-3331-11eb-1360-179455590653
# ╠═a1c99990-3331-11eb-267c-2becd60cf5f7
# ╠═a1c9c0a0-3331-11eb-135b-63656ae84866
# ╠═a1cec9b0-3331-11eb-2935-33ea49d8fd7b
# ╠═a1d0ec92-3331-11eb-01e7-25413578c04f
# ╠═a1d13ab0-3331-11eb-1f16-f352023ed22e
# ╠═a1d4bd20-3331-11eb-0200-c1487d46b25c
# ╠═a1d77c40-3331-11eb-34d5-4de44c317b5b
# ╠═a1d7ca60-3331-11eb-0b7a-2f22b84acaa4
# ╠═a1db9af0-3331-11eb-091f-b97fd708bcf2
# ╠═a1de5a10-3331-11eb-1924-634d5960b008
# ╠═a1e07cf2-3331-11eb-1334-2ffb24974c47
# ╠═a1e31500-3331-11eb-2375-15b3748dda9b
# ╠═a1e58600-3331-11eb-33c7-4535d925ea5f
# ╠═a1e84520-3331-11eb-09c6-a532df4fa9ab
# ╠═a1eadd30-3331-11eb-1fa4-5f1b7b6b50df
# ╠═a1edea70-3331-11eb-2993-7f694dba6337
# ╟─ed50ed50-3331-11eb-0941-07bb42a7dcd8
