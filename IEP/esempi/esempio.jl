### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ bc87e3b0-6d22-11eb-375b-617c1c375160
using Pkg

# ╔═╡ 5ce1f540-6d22-11eb-24eb-6939b8a0be0f
include("function_CSet.jl")

# ╔═╡ 83ec4ff0-6d22-11eb-383f-a37b90595ddf
#1 parse del sourcecode
parsed = read_code(string(Pkg.dir("Tokenize"),"/src"));

# ╔═╡ d1f7dd8e-6d22-11eb-3bb0-ab08f6ad17d1
#2 estrazione funzioni
scraped = scrape(parsed);

# ╔═╡ 7742c6c0-6d23-11eb-1b36-0766b0b5b862
# prendiamo una funzione per vedere cosa abbiam ottenuto
sample = scraped[1]

# ╔═╡ e13c7212-6d23-11eb-1c6f-419d698d2970
sample.docs# docstring o nthing

# ╔═╡ e74cdff0-6d23-11eb-3167-5739d2b97a3f
sample.source# path a file source code

# ╔═╡ f5a7a620-6d23-11eb-28e0-5b16995cddd6
func = sample.func #info su implementazione

# ╔═╡ 03e4d230-6d24-11eb-1320-df2ac162ad20
func.name #nome funzioone

# ╔═╡ 0de7aff0-6d24-11eb-2a16-597df6964af1
func.inputs  # nomi/tipi input

# ╔═╡ 1b77fa30-6d24-11eb-32b7-97fce6e90e31
func.block # parse intero della funzione

# ╔═╡ 2a6da0d2-6d24-11eb-361d-4b8cb777a314
#possiamo trovare le call
find_heads(func.block, :call)

# ╔═╡ 3c70d590-6d24-11eb-0dc8-796459a9d003
func.output # output

# ╔═╡ ae9abc50-6d36-11eb-003e-9fbfb1cc5d7c


# ╔═╡ Cell order:
# ╠═5ce1f540-6d22-11eb-24eb-6939b8a0be0f
# ╠═bc87e3b0-6d22-11eb-375b-617c1c375160
# ╠═83ec4ff0-6d22-11eb-383f-a37b90595ddf
# ╠═d1f7dd8e-6d22-11eb-3bb0-ab08f6ad17d1
# ╠═7742c6c0-6d23-11eb-1b36-0766b0b5b862
# ╠═e13c7212-6d23-11eb-1c6f-419d698d2970
# ╠═e74cdff0-6d23-11eb-3167-5739d2b97a3f
# ╠═f5a7a620-6d23-11eb-28e0-5b16995cddd6
# ╠═03e4d230-6d24-11eb-1320-df2ac162ad20
# ╠═0de7aff0-6d24-11eb-2a16-597df6964af1
# ╠═1b77fa30-6d24-11eb-32b7-97fce6e90e31
# ╠═2a6da0d2-6d24-11eb-361d-4b8cb777a314
# ╠═3c70d590-6d24-11eb-0dc8-796459a9d003
# ╠═ae9abc50-6d36-11eb-003e-9fbfb1cc5d7c
