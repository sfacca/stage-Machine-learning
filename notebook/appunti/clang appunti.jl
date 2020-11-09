### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ 828f45e2-19fd-11eb-33f6-57f0a02f1d3b
using Clang

# ╔═╡ 776cca82-1a01-11eb-2475-a3269f3c61d2
using Clang.LibClang.Clang_jll

# ╔═╡ 0336fd70-1a0b-11eb-2b6f-cdcc9b8552a1
md"* https://notebook.community/mdcfrancis/Clang.jl/examples/parsing_c_with_clangjl/notebook
* https://github.com/JuliaInterop/Clang.jl"

# ╔═╡ 92698020-19fd-11eb-2eb1-3f578220f627
md"clang è compilatore C costruito sopra llvm

libclang è piccola api c per una piccola parte di clang

si può accedere a clang completo tramite Cxx.jl"

# ╔═╡ 8e30d720-1a0b-11eb-3943-e9bbcc20a252
md" header presi da risultato di https://github.com/sfacca/stage-Machine-learning/blob/master/prisma/hdf5/installazione%20api%20hdf%20eos5.markdown"

# ╔═╡ 9a3edbf0-2052-11eb-1bff-57c0bd90eaed
trans_unit = parse_header("out/aften/common.h")

# ╔═╡ aa932830-2052-11eb-377c-7f0532dc2376
root_cursor = getcursor(trans_unit)

# ╔═╡ aa941292-2052-11eb-0511-4f6edfbdd1fc
struct_cursor = search(root_cursor, "ExStruct")

# ╔═╡ 567b2450-2052-11eb-0cbf-d5469c99f0ee
for c in struct_cursor  # print children
           println("Cursor: ", c, "\n  Kind: ", kind(c), "\n  Name: ", name(c), "\n  Type: ")
end

# ╔═╡ a1ba1d10-2055-11eb-182c-3fd978e5709a
print_buffer

# ╔═╡ e6b4517e-2058-11eb-2c32-e773cd3f4e37
println("######################")

# ╔═╡ d1b0e0f0-1a09-11eb-35e8-ffa8930b3d1b
md"* https://support.hdfgroup.org/HDF5/doc/H5.user/Datatypes.html"

# ╔═╡ Cell order:
# ╠═0336fd70-1a0b-11eb-2b6f-cdcc9b8552a1
# ╠═828f45e2-19fd-11eb-33f6-57f0a02f1d3b
# ╠═776cca82-1a01-11eb-2475-a3269f3c61d2
# ╟─92698020-19fd-11eb-2eb1-3f578220f627
# ╟─8e30d720-1a0b-11eb-3943-e9bbcc20a252
# ╠═9a3edbf0-2052-11eb-1bff-57c0bd90eaed
# ╠═aa932830-2052-11eb-377c-7f0532dc2376
# ╠═aa941292-2052-11eb-0511-4f6edfbdd1fc
# ╠═567b2450-2052-11eb-0cbf-d5469c99f0ee
# ╠═a1ba1d10-2055-11eb-182c-3fd978e5709a
# ╠═e6b4517e-2058-11eb-2c32-e773cd3f4e37
# ╟─d1b0e0f0-1a09-11eb-35e8-ffa8930b3d1b
