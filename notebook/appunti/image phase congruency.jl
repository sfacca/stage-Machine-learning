### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 7871d3c0-1917-11eb-1f7c-ed8e7f2c7434
using ImagePhaseCongruency

# ╔═╡ 8f342820-1920-11eb-310c-c144e9b9be26
using Images

# ╔═╡ 907a3cb0-1920-11eb-3dd5-51ce32603be2
using TestImages

# ╔═╡ 4660b680-1930-11eb-0d7b-c1a420fa57c5
using MosaicViews

# ╔═╡ 8ffcd180-192f-11eb-1b4b-976c05a81092
using Colors

# ╔═╡ ed3d7d90-1920-11eb-382b-35a4170c6216
#using ImageView

# ╔═╡ 891426b0-191c-11eb-3efc-5dae084a5ae0
md"* https://peterkovesi.github.io/ImagePhaseCongruency.jl/dev/index.html"

# ╔═╡ e8d7cef2-191f-11eb-316c-d17c5c883ac8
md"### riconoscimento di features tramite phase congruency

modello energia locale psotula che le features di un immagine sono in punti dove i componenti di fourier sono in phase in maniera massima.  
  
1. phasecongmono() Phase congruency of an image using monogenic filters.  
2. phasecong3() Computes edge and corner phase congruency in an image via log-Gabor filters.  "

# ╔═╡ 7cbb0010-1920-11eb-3149-bffbae0e5f0e
img = Float64.(testimage("lena_gray_512"));

# ╔═╡ b27ce1c0-1932-11eb-0955-2b362827c5ea
Gray.(img)

# ╔═╡ e6920a62-192f-11eb-1a69-bfdc922e790e
(pc, or, ft, T) =
         phasecongmono(img; nscale=4, minwavelength=3, mult=2,
                        sigmaonf=0.55, k=3, cutoff=0.5, g=10,
                        deviationgain=1.5, noisemethod=-1);


# ╔═╡ adc59b40-1932-11eb-04d6-5deb90a9db4e
Gray.(pc)

# ╔═╡ edc24020-192f-11eb-1d83-9fb75dbab43e
nonmax = thin_edges_nonmaxsup(pc, or);

# ╔═╡ 2f40e260-1933-11eb-3ed1-f5500dfc1980
bw = hysthresh(nonmax, 0.1, 0.2);

# ╔═╡ b699e410-1932-11eb-2c24-41f850f02c36
Gray.(bw)

# ╔═╡ aa04d26e-1921-11eb-1c09-7dd44f895986
md"l uso della funzione phasecong3 permette di riconosciere anche i vertici."

# ╔═╡ c8e3f590-1921-11eb-2212-9d17a80fde68
img2 = testimage("lena_gray_512")

# ╔═╡ 502858a0-1933-11eb-0cb2-1bad14bd63a0
(M, m) = phasecong3(img2);

# ╔═╡ 789db500-1933-11eb-23f7-95ec407d1f91
Gray.(M)

# ╔═╡ 7e223690-1933-11eb-26d1-fd3ca3326180
Gray.(m)

# ╔═╡ 9139c180-1933-11eb-18bf-8730a02fe8b8
md"### simmetria fase

risponde bene a features simili a linee e ad oggetti circolari.  
il numero di scale filtro influenzerà la scala delle features marcate"

# ╔═╡ 3d59f9c0-1935-11eb-2c30-ef21bad8a658
img3 = Float64.(Gray.(testimage("blobs")));

# ╔═╡ cf12b450-1936-11eb-34d4-3f3b4c9b4724
Gray.(img3)

# ╔═╡ 43542080-1935-11eb-315c-f3453c935059
(phaseSym, symmetryEnergy, T1) = phasesymmono(img3; nscale=5, polarity=1);

# ╔═╡ fb72b860-1936-11eb-0540-9f7c9b08ad0a
Gray.(phaseSym)

# ╔═╡ 4a507500-1935-11eb-110b-9583ce913851
(phaseSym2, symmetryEnergy2, T2) = phasesymmono(img3; nscale=5, polarity=-1);

# ╔═╡ 08c81c80-1937-11eb-3cfc-f3f70f7d3f4d
Gray.(phaseSym2)

# ╔═╡ Cell order:
# ╠═7871d3c0-1917-11eb-1f7c-ed8e7f2c7434
# ╠═8f342820-1920-11eb-310c-c144e9b9be26
# ╠═907a3cb0-1920-11eb-3dd5-51ce32603be2
# ╠═ed3d7d90-1920-11eb-382b-35a4170c6216
# ╠═4660b680-1930-11eb-0d7b-c1a420fa57c5
# ╠═8ffcd180-192f-11eb-1b4b-976c05a81092
# ╟─891426b0-191c-11eb-3efc-5dae084a5ae0
# ╟─e8d7cef2-191f-11eb-316c-d17c5c883ac8
# ╠═7cbb0010-1920-11eb-3149-bffbae0e5f0e
# ╟─b27ce1c0-1932-11eb-0955-2b362827c5ea
# ╠═e6920a62-192f-11eb-1a69-bfdc922e790e
# ╟─adc59b40-1932-11eb-04d6-5deb90a9db4e
# ╠═edc24020-192f-11eb-1d83-9fb75dbab43e
# ╠═2f40e260-1933-11eb-3ed1-f5500dfc1980
# ╟─b699e410-1932-11eb-2c24-41f850f02c36
# ╟─aa04d26e-1921-11eb-1c09-7dd44f895986
# ╠═c8e3f590-1921-11eb-2212-9d17a80fde68
# ╠═502858a0-1933-11eb-0cb2-1bad14bd63a0
# ╠═789db500-1933-11eb-23f7-95ec407d1f91
# ╠═7e223690-1933-11eb-26d1-fd3ca3326180
# ╠═9139c180-1933-11eb-18bf-8730a02fe8b8
# ╠═3d59f9c0-1935-11eb-2c30-ef21bad8a658
# ╟─cf12b450-1936-11eb-34d4-3f3b4c9b4724
# ╠═43542080-1935-11eb-315c-f3453c935059
# ╟─fb72b860-1936-11eb-0540-9f7c9b08ad0a
# ╠═4a507500-1935-11eb-110b-9583ce913851
# ╠═08c81c80-1937-11eb-3cfc-f3f70f7d3f4d
