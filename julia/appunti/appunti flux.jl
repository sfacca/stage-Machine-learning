### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 96a422b0-1d15-11eb-2567-914db1867ba5
using Flux

# ╔═╡ 7e582240-1d26-11eb-1cdb-0337fc0efa0c
using Plots

# ╔═╡ 7154ef0e-1d21-11eb-0d9e-835d70ce9b15
using CSV

# ╔═╡ 77b26b80-1d21-11eb-0157-370294738a03
using DataFrames

# ╔═╡ 0fdfaf20-1d32-11eb-334e-9bbda6a4ddc7
using Flux.Tracker

# ╔═╡ d818e140-1d15-11eb-0735-b98e0cd265f2
md"api e fw per definire pipeline/toolchain per ml in maniera facile

esempio su problema di classificazione

ha già un sigmoid σ definita:
	σ = 1 / (1 + exp(-x))

possiamo creare neurone con 2 input  e 1 output cos':

" 

# ╔═╡ 9989d950-1d1c-11eb-2866-57ca80a4fe0b
model= Dense(2, 1, σ)

# ╔═╡ 381af540-1d1d-11eb-0bfe-ef4714abdf6d
md"il modello ha campi dove salvare pesi e bias:"

# ╔═╡ 47386f32-1d1d-11eb-1211-b92fed4dc830
model.W

# ╔═╡ 4b920550-1d1d-11eb-0b41-1d4c33bd66ed
model.b

# ╔═╡ 75e66ffe-1d1f-11eb-1cc2-352f52828533
x = rand(2)

# ╔═╡ 5b960eb0-1d1d-11eb-3421-43932a8e81fc
md"model.W e model.b son trattate come matrici con una riga singola

"

# ╔═╡ a755b07e-1d1d-11eb-1a07-373a1f01c78c
σ.(model.W*x + model.b)

# ╔═╡ cd2f5360-1d1d-11eb-1b46-e1ca8446aa19
md"abbiamo errore quadrtatico medio"

# ╔═╡ 6a4fc0f0-1d21-11eb-1090-0b33874e43f5
md"#### workflow esempio"

# ╔═╡ a47f3b20-1d21-11eb-3415-c535463270b8
mkpath("/out")

# ╔═╡ a94db320-1d21-11eb-39a8-39af271ffe3a
download("https://github.com/JuliaComputing/JSC-Training/raw/master/Courses/Deep%20learning%20with%20Flux/data/apples.dat","out/apples.dat")

# ╔═╡ b4c7c790-1d21-11eb-369b-8d6d5e4a452f
download("https://github.com/JuliaComputing/JSC-Training/raw/master/Courses/Deep%20learning%20with%20Flux/data/bananas.dat","out/bananas.dat")

# ╔═╡ c4bf4dd0-1d21-11eb-3206-59230bff6353
apples = DataFrame(CSV.File("out/apples.dat"))

# ╔═╡ d31b3000-1d22-11eb-010a-c7d2527f6bb8
rename!(apples, ["h","w","red","green","blue"]);

# ╔═╡ 4c2e5312-1d22-11eb-0429-ada6ac7853ae
bananas = DataFrame(CSV.File("out/bananas.dat"))

# ╔═╡ d610f060-1d22-11eb-384c-031bb6e48e02
rename!(bananas, ["h","w","red","green","blue"]);

# ╔═╡ 5cdad170-1d22-11eb-209b-b183a7831362
md"dati sono riassunti info su svariate immagini di banane e mele

estraiamo features che vogliamo usare: valori medi di rosso e blu"


# ╔═╡ 74d0b2e0-1d22-11eb-03ca-91ff1d7cbdee
x_apples = [ [row.red, row.green] for row in eachrow(apples)]

# ╔═╡ b58c0c80-1d22-11eb-1670-6747e7e3392f
x_bananas = [ [row.red, row.green] for row in eachrow(bananas)]

# ╔═╡ f5704002-1d22-11eb-09b5-8f0c13594afc
xs = [x_apples; x_bananas]

# ╔═╡ 34348490-1d23-11eb-3e44-19522e6230be
md"definiamo la nostra variabile binomiale 0->mela, 1->banana"

# ╔═╡ 01cf8450-1d23-11eb-1fe2-4f395afd4bae
ys = [fill(0, size(x_apples)); fill(1, size(x_bananas))];

# ╔═╡ 4379aac0-1d23-11eb-1472-e901bedfac6a
model(xs[end])

# ╔═╡ 5f8d9ff0-1d23-11eb-01eb-8115714ca331
loss = Flux.mse(model(xs[1]), ys[1])

# ╔═╡ 653b25f0-1d26-11eb-1a64-8d2eb21d11d9
md"prendiamo gtradienti"

# ╔═╡ 41169b30-1d28-11eb-2c21-5f0de156d88a
md"NB: backpropagation non più preente in flux, Flux.Tracker rimsosso da 0.9"

# ╔═╡ 56dd2410-1d29-11eb-2dff-8ddb20fcd3a3
params(model)

# ╔═╡ 6fc3ce20-1d29-11eb-3db5-8968ab8c49e9
L(x,y)= Flux.mse(model(x), y)

# ╔═╡ 33aa101e-1d29-11eb-3c0a-69a2ad8dfadd
Flux.train!(L, params(model), zip(xs, ys),  Descent())

# ╔═╡ ff8c9500-1d29-11eb-1d23-255b895f21a9
md"### visualizzazione risultato"

# ╔═╡ da201660-1d2a-11eb-31ef-3599475f6faf
function visualize()
	contour(0:.1:1, 0:.1:1, (x, y) -> model([x,y])[], fill=true);
	scatter!(first.(x_apples), last.(x_apples), label="apples");
	scatter!(first.(x_bananas), last.(x_bananas), label="bananas");
	xlabel!("mean red value");
	ylabel!("mean green value")
end

# ╔═╡ f3cecb60-1d2a-11eb-30fc-1fb61000a1c4
visualize()

# ╔═╡ f6ee5ae0-1d2a-11eb-0233-5f03fb7d1b5a
md"trainiamo tot volte"

# ╔═╡ 110399e0-1d2b-11eb-3877-d7bec5153016
for step in 1:100
	Flux.train!(L, params(model), zip(xs, ys),  Descent())
end	

# ╔═╡ 22fb0ed0-1d2b-11eb-3091-9f47a80eb216
visualize()

# ╔═╡ 342eb730-1d2e-11eb-3f02-dde9b4f10470
md"si possono vedere esempi di modelli a:  
* https://github.com/FluxML/model-zoo/"

# ╔═╡ Cell order:
# ╠═96a422b0-1d15-11eb-2567-914db1867ba5
# ╠═7e582240-1d26-11eb-1cdb-0337fc0efa0c
# ╟─d818e140-1d15-11eb-0735-b98e0cd265f2
# ╠═9989d950-1d1c-11eb-2866-57ca80a4fe0b
# ╠═381af540-1d1d-11eb-0bfe-ef4714abdf6d
# ╠═47386f32-1d1d-11eb-1211-b92fed4dc830
# ╠═4b920550-1d1d-11eb-0b41-1d4c33bd66ed
# ╠═75e66ffe-1d1f-11eb-1cc2-352f52828533
# ╟─5b960eb0-1d1d-11eb-3421-43932a8e81fc
# ╠═a755b07e-1d1d-11eb-1a07-373a1f01c78c
# ╟─cd2f5360-1d1d-11eb-1b46-e1ca8446aa19
# ╟─6a4fc0f0-1d21-11eb-1090-0b33874e43f5
# ╠═7154ef0e-1d21-11eb-0d9e-835d70ce9b15
# ╠═77b26b80-1d21-11eb-0157-370294738a03
# ╠═a47f3b20-1d21-11eb-3415-c535463270b8
# ╠═a94db320-1d21-11eb-39a8-39af271ffe3a
# ╠═b4c7c790-1d21-11eb-369b-8d6d5e4a452f
# ╠═c4bf4dd0-1d21-11eb-3206-59230bff6353
# ╠═d31b3000-1d22-11eb-010a-c7d2527f6bb8
# ╠═4c2e5312-1d22-11eb-0429-ada6ac7853ae
# ╠═d610f060-1d22-11eb-384c-031bb6e48e02
# ╟─5cdad170-1d22-11eb-209b-b183a7831362
# ╠═74d0b2e0-1d22-11eb-03ca-91ff1d7cbdee
# ╠═b58c0c80-1d22-11eb-1670-6747e7e3392f
# ╠═f5704002-1d22-11eb-09b5-8f0c13594afc
# ╟─34348490-1d23-11eb-3e44-19522e6230be
# ╠═01cf8450-1d23-11eb-1fe2-4f395afd4bae
# ╠═4379aac0-1d23-11eb-1472-e901bedfac6a
# ╠═5f8d9ff0-1d23-11eb-01eb-8115714ca331
# ╟─653b25f0-1d26-11eb-1a64-8d2eb21d11d9
# ╟─41169b30-1d28-11eb-2c21-5f0de156d88a
# ╠═0fdfaf20-1d32-11eb-334e-9bbda6a4ddc7
# ╠═56dd2410-1d29-11eb-2dff-8ddb20fcd3a3
# ╠═6fc3ce20-1d29-11eb-3db5-8968ab8c49e9
# ╠═33aa101e-1d29-11eb-3c0a-69a2ad8dfadd
# ╠═ff8c9500-1d29-11eb-1d23-255b895f21a9
# ╠═da201660-1d2a-11eb-31ef-3599475f6faf
# ╠═f3cecb60-1d2a-11eb-30fc-1fb61000a1c4
# ╠═f6ee5ae0-1d2a-11eb-0233-5f03fb7d1b5a
# ╠═110399e0-1d2b-11eb-3877-d7bec5153016
# ╠═22fb0ed0-1d2b-11eb-3091-9f47a80eb216
# ╟─342eb730-1d2e-11eb-3f02-dde9b4f10470
