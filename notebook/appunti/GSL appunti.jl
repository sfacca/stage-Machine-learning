### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ 99a57300-227f-11eb-1e1e-35d2d77fa9b2
using GSL

# ╔═╡ 9a7636e0-2287-11eb-1ff7-07662fc8066d
md"GSL è un wrapper per GNU Scientific Library di C
* https://www.gnu.org/software/gsl/doc/html/index.html  

note:

1. le funzioni han il nome originale senza il prefisso gsl_, ad esempio gsl_vector_alloc diventa vector_alloc nel wrapper  
2. strutture/tipi mantengono il nome orifinario, con il prefisso gsl_ eg: gsl_vector
3. costantiv fisiche sono accessibili da GSL.Const e rinominate senza il prefisso GSL_CONST_ ad esempio GSL/_CONST/_MKSA/_ANGSTROM diventa MKSA_ANGSTROM

vediamo qualche usecase semplice:

### funzione speciale con struttura di risultato
"

# ╔═╡ 044e9e90-2288-11eb-0288-2b07b74e5fe6
# Direct call
sf_legendre_P3(0.5)

# ╔═╡ 7f69aa20-2288-11eb-3991-91cb651bd17d
# With result struct that stores value and error:
sf_legendre_P3_e(0.5)

# ╔═╡ 7c28ff40-22a2-11eb-20d0-b3e521c675d5
md"##### Low-level call with result struct as argument:"

# ╔═╡ 7f6a6d70-2288-11eb-2239-c7e4ef8d34e3
begin
	result = gsl_sf_result(0,0) # struttura->tiene prefix gsl_
	GSL.C.sf_legendre_P3_e(0.5, result)
end

# ╔═╡ 567533e0-22a2-11eb-0ae1-b5c2568cb45b
md"
Output: GSL_SUCCESS

result = $(gsl_sf_result(-0.4375, 3.3306690738754696e-16))
"

# ╔═╡ 5476ae20-2289-11eb-19c0-3927b7878048
function Base.convert(T::Type{Float64}, x::gsl_sf_result)
	x.val
end

# ╔═╡ 4c384740-228a-11eb-03b9-73e4386ea5fa
function Base.Float64(x::gsl_sf_result)
	x.val
end

# ╔═╡ f678f170-2288-11eb-3ecb-6d341ba23ec1
md"### funzione speciale con risultato array"

# ╔═╡ 10d1aca0-228a-11eb-19f1-cf898bfdb1a9
x = 0.5

# ╔═╡ 64a6db20-228a-11eb-1070-c3e3b6081e99
lmax = 4

# ╔═╡ 64a77760-228a-11eb-0fb6-0bd6edc346aa
result2 = sf_legendre_array(GSL_SF_LEGENDRE_SPHARM, lmax, x)

# ╔═╡ 64a813a0-228a-11eb-38e2-5fe0f0f3c34e
# Equivalent using low-level interface:
	n = sf_legendre_array_n(lmax)

# ╔═╡ 64ac0b40-228a-11eb-278a-b57a88b0a9cf
result3 = Array{Base.Float64}(undef, n)

# ╔═╡ 64acf5a2-228a-11eb-1e12-cd9fa57b16c4
GSL.C.sf_legendre_array(GSL_SF_LEGENDRE_SPHARM, lmax, x, result3)

# ╔═╡ 2a617b10-22a2-11eb-1bc2-855b632f6b6a
md"
#### root finding"

# ╔═╡ 340b3c50-22a2-11eb-15c2-cf829624d4bc
f = x -> x^5+1

# ╔═╡ 486a8982-22a2-11eb-06b4-df4245e63863
df = x -> 5*x^4

# ╔═╡ 486b73e0-22a2-11eb-2a29-3715a0556ccc
fdf = @gsl_function_fdf(f, df)

# ╔═╡ 486dbdd0-22a2-11eb-2c33-45b9f975a59b
solver = root_fdfsolver_alloc(gsl_root_fdfsolver_newton)

# ╔═╡ 48711930-22a2-11eb-104c-3d971dfb70a2
root_fdfsolver_set(solver, fdf, -2)

# ╔═╡ 4872038e-22a2-11eb-3fc1-5b8c08383191
while abs(f(root_fdfsolver_root(solver))) > 1e-10
    root_fdfsolver_iterate(solver)
end

# ╔═╡ 3bab9900-22a2-11eb-2529-a7e867a48553
md"x = $(root_fdfsolver_root(solver))"

# ╔═╡ 4d8a2ec0-22a2-11eb-175f-730ae8e763f9


# ╔═╡ dc67c7c0-22a1-11eb-2689-e77a2acac204


# ╔═╡ 9aac9e40-2289-11eb-2e70-b99a36b4fa96


# ╔═╡ b1b51270-2289-11eb-3d18-c9ae10b86796


# ╔═╡ 30ca7d20-228a-11eb-0ed6-0f7ffc6a14ee


# ╔═╡ 4339e130-228a-11eb-166a-3fab314f2826


# ╔═╡ 849d1290-2295-11eb-29c7-cb8edd414c47


# ╔═╡ Cell order:
# ╠═99a57300-227f-11eb-1e1e-35d2d77fa9b2
# ╟─9a7636e0-2287-11eb-1ff7-07662fc8066d
# ╠═044e9e90-2288-11eb-0288-2b07b74e5fe6
# ╠═7f69aa20-2288-11eb-3991-91cb651bd17d
# ╟─7c28ff40-22a2-11eb-20d0-b3e521c675d5
# ╠═7f6a6d70-2288-11eb-2239-c7e4ef8d34e3
# ╟─567533e0-22a2-11eb-0ae1-b5c2568cb45b
# ╠═5476ae20-2289-11eb-19c0-3927b7878048
# ╠═4c384740-228a-11eb-03b9-73e4386ea5fa
# ╟─f678f170-2288-11eb-3ecb-6d341ba23ec1
# ╠═10d1aca0-228a-11eb-19f1-cf898bfdb1a9
# ╠═64a6db20-228a-11eb-1070-c3e3b6081e99
# ╠═64a77760-228a-11eb-0fb6-0bd6edc346aa
# ╠═64a813a0-228a-11eb-38e2-5fe0f0f3c34e
# ╠═64ac0b40-228a-11eb-278a-b57a88b0a9cf
# ╠═64acf5a2-228a-11eb-1e12-cd9fa57b16c4
# ╟─2a617b10-22a2-11eb-1bc2-855b632f6b6a
# ╠═340b3c50-22a2-11eb-15c2-cf829624d4bc
# ╠═486a8982-22a2-11eb-06b4-df4245e63863
# ╠═486b73e0-22a2-11eb-2a29-3715a0556ccc
# ╠═486dbdd0-22a2-11eb-2c33-45b9f975a59b
# ╠═48711930-22a2-11eb-104c-3d971dfb70a2
# ╠═4872038e-22a2-11eb-3fc1-5b8c08383191
# ╟─3bab9900-22a2-11eb-2529-a7e867a48553
# ╠═4d8a2ec0-22a2-11eb-175f-730ae8e763f9
# ╟─dc67c7c0-22a1-11eb-2689-e77a2acac204
# ╟─9aac9e40-2289-11eb-2e70-b99a36b4fa96
# ╟─b1b51270-2289-11eb-3d18-c9ae10b86796
# ╟─30ca7d20-228a-11eb-0ed6-0f7ffc6a14ee
# ╟─4339e130-228a-11eb-166a-3fab314f2826
# ╟─849d1290-2295-11eb-29c7-cb8edd414c47
