### A Pluto.jl notebook ###
# v0.12.9

using Markdown
using InteractiveUtils

# ╔═╡ 73453e50-236c-11eb-23e9-2dcc677ef837
using Distributions, StatsFuns, MultivariateStats, PDMats, Optim, Roots, LinearAlgebra

# ╔═╡ 8a8d6140-2435-11eb-281d-cd08bca78f83
include("auxiliary functions.jl")

# ╔═╡ 94666550-2434-11eb-29a8-9f6bc8f7499b
function getOriginal()
	mkpath("out/skewdist")
	download("https://github.com/STOR-i/SkewDist.jl/archive/master.zip","out/skewdist/code.zip")
	include("auxiliary functions.jl")
	unzip("out/skewdist/code.zip","out/skewdist/")
end

# ╔═╡ 954faea0-2299-11eb-12ac-693d240c4b87
md"SkewDist non è pacchetto registrato

non ha project.toml, dobbiamo scaricarlo e importarlo manualmente

prima dobbiamo installare i pacchetti necessari:

1. Distributions
2. StatsFuns, 
3. MultivariateStats, 
4. PDMats, 
5. Optim, 
6. Roots
7. LinearAlgebra"

# ╔═╡ 7681af30-236d-11eb-3cdf-db06a95846b7
md"SkewDist è un pacchetto che non viene aggiornato dal 2017, usa keywords di julia non i utilizzatye come immutable

bisogna quindi fare qualche cambiamento al codice"

# ╔═╡ b2c5d120-2434-11eb-166e-0978ec03a063
function doUpdates()
	cp("./SkewDist.jl","out/skewdist/SkewDist.jl-master/src/SkewDist.jl", force=true)
	cp("./mvskewnormal.jl","out/skewdist/SkewDist.jl-master/src/mvskewnormal.jl", force=true)
	cp("./mvskewtdist.jl","out/skewdist/SkewDist.jl-master/src/mvskewtdist.jl", force=true)	
	cp("./skewnormal.jl","out/skewdist/SkewDist.jl-master/src/skewnormal.jl", force=true)
	cp("./skewtdist.jl","out/skewdist/SkewDist.jl-master/src/skewtdist.jl", force=true)
end

# ╔═╡ ed23ae50-2434-11eb-2340-af1ce5ecbd70
#pluto non esegue celle dalla prima all'ultima
#bisogna forzarlo a eseguire include DOPO aver scaricato e aggiornato il codice
function setupSkewDist()
	getOriginal()
	doUpdates()
	include("out/skewdist/SkewDist.jl-master/src/SkewDist.jl")
end	

# ╔═╡ ef98fb80-236d-11eb-1b52-9bf18413feb2
md"possiamo ora importare il codice"

# ╔═╡ a4545930-2435-11eb-16a3-97e188e0ba21
setupSkewDist()

# ╔═╡ Cell order:
# ╟─954faea0-2299-11eb-12ac-693d240c4b87
# ╠═8a8d6140-2435-11eb-281d-cd08bca78f83
# ╠═73453e50-236c-11eb-23e9-2dcc677ef837
# ╠═94666550-2434-11eb-29a8-9f6bc8f7499b
# ╟─7681af30-236d-11eb-3cdf-db06a95846b7
# ╠═b2c5d120-2434-11eb-166e-0978ec03a063
# ╟─ef98fb80-236d-11eb-1b52-9bf18413feb2
# ╠═ed23ae50-2434-11eb-2340-af1ce5ecbd70
# ╠═a4545930-2435-11eb-16a3-97e188e0ba21
