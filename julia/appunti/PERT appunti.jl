### A Pluto.jl notebook ###
# v0.12.8

using Markdown
using InteractiveUtils

# ╔═╡ 56dcb2b0-242b-11eb-0f9d-dfe0dd16daba
using ProjectManagement

# ╔═╡ c3687330-242e-11eb-2cba-27b13ab84c80
using Statistics

# ╔═╡ d1de6280-242e-11eb-37a1-21b0bb70c244
using Plots

# ╔═╡ 66dfaaa0-242b-11eb-04db-99d7b19c9fc4
md"lo scopo del pacchetto ProjectManagement è il facilitare il project management tradizionale

fornisce 3 servizi:
1. disegno grafi PERT
2. identificazione cammini critici e computazione costi
3. campionatura durata di monte carlo(distribuzione di probabilità di durata e statistiche derivate)

####  workflow

si inizia definendo oggetto Project"

# ╔═╡ e8943f50-242d-11eb-3210-edc3a05433d1
proj = Project(
    (#definizione nodi
        start=0,
        a=PertBeta(2,3,4),
        b=PertBeta(1,2,6),
        c=PertBeta(0,1,2),
        d=PertBeta(0,1,2),
        e=PertBeta(0,1,2),
        f=PertBeta(3.0, 6.5, 13.0),
        g=PertBeta(3.5, 7.5, 14.0),
        h=PertBeta(0, 1, 2),
        j=PertBeta(0, 1, 2),
        finish=0,
    ),
    [#definizione archi
        :start .=> [:a, :b, :c, :d];
        :a => :f;
        :b .=> [:f, :g];
        [:c, :d] .=> :e;
        :e .=> [:f, :g, :h];
        [:f, :g, :h] .=> :j;
        :j => :finish;
    ],
)


# ╔═╡ 0d8b4a62-242e-11eb-0437-2dbd91d23b31
md"possiamo visualizzare la catena"

# ╔═╡ 19e78172-242e-11eb-3d5e-8b069f4c9ba0
visualize_chart(proj; fontsize=2.5)

# ╔═╡ 1bc47ed0-242e-11eb-335c-15f4c5f7adaf
md"possiamo vedere cammino critico(con costo)"

# ╔═╡ 58990150-242e-11eb-1ee1-11a94006ba2a
critical_path(proj)

# ╔═╡ 5df3dad0-242e-11eb-24a0-1362b5b14d65
md"possiamo computare costi di tutti i cammini"

# ╔═╡ 6f1e62d0-242e-11eb-01f4-25189bb631e2
path_durations(proj)[1:min(3, end)]

# ╔═╡ 73a28b60-242e-11eb-0960-210a02d0728f
md"#### campionatura durata
possiamo vedere possibili durate del progetto definito:"

# ╔═╡ a0b78790-242e-11eb-000c-fd552df47bad
duration_samples = rand(proj, 100_000);

# ╔═╡ c9c5c890-242e-11eb-2696-6399b8c6de6f
mean(duration_samples);

# ╔═╡ c9c5ef9e-242e-11eb-10f8-8f161452f20b
minimum(duration_samples);

# ╔═╡ c9c63dc0-242e-11eb-3376-fb233595284b
quantile(duration_samples, 0.25);

# ╔═╡ c9cb6dde-242e-11eb-3a7d-652612e6ecdf
median(duration_samples);

# ╔═╡ c9cca660-242e-11eb-37d3-45659c49f8ba
quantile(duration_samples, 0.75);

# ╔═╡ c9d0c510-242e-11eb-1bc2-83dcebaa00af
maximum(duration_samples)

# ╔═╡ d6877830-242e-11eb-0e62-393ac93ab196
density(proj; legend=false)

# ╔═╡ Cell order:
# ╠═56dcb2b0-242b-11eb-0f9d-dfe0dd16daba
# ╟─66dfaaa0-242b-11eb-04db-99d7b19c9fc4
# ╠═e8943f50-242d-11eb-3210-edc3a05433d1
# ╟─0d8b4a62-242e-11eb-0437-2dbd91d23b31
# ╠═19e78172-242e-11eb-3d5e-8b069f4c9ba0
# ╟─1bc47ed0-242e-11eb-335c-15f4c5f7adaf
# ╠═58990150-242e-11eb-1ee1-11a94006ba2a
# ╟─5df3dad0-242e-11eb-24a0-1362b5b14d65
# ╠═6f1e62d0-242e-11eb-01f4-25189bb631e2
# ╠═73a28b60-242e-11eb-0960-210a02d0728f
# ╠═c3687330-242e-11eb-2cba-27b13ab84c80
# ╠═a0b78790-242e-11eb-000c-fd552df47bad
# ╠═c9c5c890-242e-11eb-2696-6399b8c6de6f
# ╠═c9c5ef9e-242e-11eb-10f8-8f161452f20b
# ╠═c9c63dc0-242e-11eb-3376-fb233595284b
# ╠═c9cb6dde-242e-11eb-3a7d-652612e6ecdf
# ╠═c9cca660-242e-11eb-37d3-45659c49f8ba
# ╠═c9d0c510-242e-11eb-1bc2-83dcebaa00af
# ╠═d1de6280-242e-11eb-37a1-21b0bb70c244
# ╠═d6877830-242e-11eb-0e62-393ac93ab196
