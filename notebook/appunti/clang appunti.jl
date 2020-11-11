### A Pluto.jl notebook ###
# v0.12.9

using Markdown
using InteractiveUtils

# ╔═╡ 828f45e2-19fd-11eb-33f6-57f0a02f1d3b
using Clang

# ╔═╡ 776cca82-1a01-11eb-2475-a3269f3c61d2
using Clang.LibClang.Clang_jll

# ╔═╡ 66180b7e-2444-11eb-1efb-4d5cec77fa08
using Clang.wrap_c

# ╔═╡ 0336fd70-1a0b-11eb-2b6f-cdcc9b8552a1
md"* https://notebook.community/mdcfrancis/Clang.jl/examples/parsing_c_with_clangjl/notebook
* https://github.com/JuliaInterop/Clang.jl"

# ╔═╡ 92698020-19fd-11eb-2eb1-3f578220f627
md"clang è compilatore C costruito sopra llvm

libclang è piccola api c per una piccola parte di clang

si può accedere a clang completo tramite Cxx.jl"

# ╔═╡ ae5d7020-2443-11eb-36e4-13cb37ddb2cd
md"## generatore di wrapper C

https://clangjl.readthedocs.io/en/latest/wrap_c.html

clang contiene un generatore per creare wrapper Julia di librerie C partendo da file headers (.h) 

supporta le seguenti dichiarazioni:
* function: translated to Julia ccall, with full type translation
* typedef: translated to Julia typealias to underlying intrinsic type
* enum: translated to const value symbol
* struct: partial struct support may be enabled by setting WrapContext.options.wrap_structs = true"

# ╔═╡ 8e30d720-1a0b-11eb-3943-e9bbcc20a252
md" header presi da risultato di https://github.com/sfacca/stage-Machine-learning/blob/master/prisma/hdf5/installazione%20api%20hdf%20eos5.markdown"

# ╔═╡ f5729cb0-2443-11eb-1f07-ff8afacbcca1
headers = ["out/hdf/hdf5.h"]
#wrap_c.wrap_c_headers(context, headers)

# ╔═╡ f52e2430-2444-11eb-024f-afb4fa8fd29e
ctx = init(;
	headers=headers)

# ╔═╡ ac0bb7f0-2443-11eb-20a4-bfe8a0e9954e
run(ctx)

# ╔═╡ d1b0e0f0-1a09-11eb-35e8-ffa8930b3d1b
md"* https://support.hdfgroup.org/HDF5/doc/H5.user/Datatypes.html"

# ╔═╡ Cell order:
# ╠═0336fd70-1a0b-11eb-2b6f-cdcc9b8552a1
# ╠═828f45e2-19fd-11eb-33f6-57f0a02f1d3b
# ╠═776cca82-1a01-11eb-2475-a3269f3c61d2
# ╟─92698020-19fd-11eb-2eb1-3f578220f627
# ╟─ae5d7020-2443-11eb-36e4-13cb37ddb2cd
# ╠═66180b7e-2444-11eb-1efb-4d5cec77fa08
# ╟─8e30d720-1a0b-11eb-3943-e9bbcc20a252
# ╠═f5729cb0-2443-11eb-1f07-ff8afacbcca1
# ╠═f52e2430-2444-11eb-024f-afb4fa8fd29e
# ╠═ac0bb7f0-2443-11eb-20a4-bfe8a0e9954e
# ╟─d1b0e0f0-1a09-11eb-35e8-ffa8930b3d1b
