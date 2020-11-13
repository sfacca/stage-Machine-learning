### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ 2a484880-25e9-11eb-050c-a5ef8f04b3b5
using Genie

# ╔═╡ becc9520-24f8-11eb-1270-c18f2ad9e794
md"""Genie è un framework per la creazione di web app con struttura MVC

si inizia creando l'app con Genie.newapp("MyGenieApp")

le routes possono essere modificate direttamente nel file routes.jl

le view possono contenere blocchi di codice julia delimitati da <% %>

i controller possono essere aggiunti con Genie.newcontroller("")

i modelli sono gestiti con SearchLight (pacchetto da aggiungere all'app)"""

# ╔═╡ 2cd2c3f0-25e9-11eb-0755-0b2534d68ad3
serve_static_file()

# ╔═╡ Cell order:
# ╟─becc9520-24f8-11eb-1270-c18f2ad9e794
# ╠═2a484880-25e9-11eb-050c-a5ef8f04b3b5
# ╠═2cd2c3f0-25e9-11eb-0755-0b2534d68ad3
