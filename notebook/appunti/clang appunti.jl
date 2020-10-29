### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 828f45e2-19fd-11eb-33f6-57f0a02f1d3b
using Clang

# ╔═╡ 776cca82-1a01-11eb-2475-a3269f3c61d2
using Clang.LibClang.Clang_jll

# ╔═╡ e8f68960-1a02-11eb-1308-772f279c20b9
include("./out/libHDF5_api.jl")

# ╔═╡ 0336fd70-1a0b-11eb-2b6f-cdcc9b8552a1
md"* https://notebook.community/mdcfrancis/Clang.jl/examples/parsing_c_with_clangjl/notebook
* https://github.com/JuliaInterop/Clang.jl"

# ╔═╡ 92698020-19fd-11eb-2eb1-3f578220f627
md"clang è compilatore C costruito sopra llvm

libclang è piccola api c per una piccola parte di clang

si può accedere a clang completo tramite Cxx.jl"

# ╔═╡ e99b66d2-1a00-11eb-22f9-092c5da3e997
const LIBCLANG_INCLUDE = joinpath(dirname(Clang_jll.libclang_path), "..", "include", "clang-c") |> normpath

# ╔═╡ 9f360862-1a01-11eb-1cba-bfc31ecaee82
const LIBCLANG_HEADERS = [joinpath(LIBCLANG_INCLUDE, header) for header in readdir(LIBCLANG_INCLUDE) if endswith(header, ".h")]

# ╔═╡ a77fc470-1a01-11eb-003c-2390395c662a
wc = init(; headers = LIBCLANG_HEADERS,
            output_file = joinpath(@__DIR__, "out/libclang_api.jl"),
            common_file = joinpath(@__DIR__, "out/libclang_common.jl"),
            clang_includes = vcat(LIBCLANG_INCLUDE, CLANG_INCLUDE),
            clang_args = ["-I", joinpath(LIBCLANG_INCLUDE, "..")],
            header_wrapped = (root, current)->root == current,
            header_library = x->"libclang",
            clang_diagnostics = true,
            )


# ╔═╡ ad5e73ee-1a01-11eb-3e5f-63abaf00cd69
run(wc)

# ╔═╡ 8e30d720-1a0b-11eb-3943-e9bbcc20a252
md" header presi da risultato di https://github.com/sfacca/stage-Machine-learning/blob/master/prisma/hdf5/installazione%20api%20hdf%20eos5.markdown"

# ╔═╡ c14e5d80-1a01-11eb-35c9-a7b845a6238f
LIBHDF_INCLUDE = string(@__DIR__, "\\out\\hdf")

# ╔═╡ 1e8e968e-1a02-11eb-29aa-071d52acb592
LIBHDF_HEADERS = [joinpath(LIBHDF_INCLUDE, header) for header in readdir(LIBHDF_INCLUDE) if endswith(header, ".h")]

# ╔═╡ 63099040-1a02-11eb-17c1-5900d46a1035
wcHDF = init(; headers = LIBHDF_HEADERS,
            output_file = joinpath(@__DIR__, "out/libHDF5_api.jl"),
            common_file = joinpath(@__DIR__, "out/libHDF5_common.jl"),
            clang_includes = vcat(LIBHDF_INCLUDE, CLANG_INCLUDE),
            clang_args = ["-I", joinpath(LIBHDF_INCLUDE, "..")],
            header_wrapped = (root, current)->root == current,
            header_library = x->"libHDF5",
            clang_diagnostics = true,
            )

# ╔═╡ 2ffacc62-1a0b-11eb-2178-87c0fa64d604
wcHDF.options

# ╔═╡ ce7f2d32-1a02-11eb-2718-9359a5d3590d
run(wcHDF)

# ╔═╡ d1b0e0f0-1a09-11eb-35e8-ffa8930b3d1b
md"* https://support.hdfgroup.org/HDF5/doc/H5.user/Datatypes.html"

# ╔═╡ Cell order:
# ╠═0336fd70-1a0b-11eb-2b6f-cdcc9b8552a1
# ╠═828f45e2-19fd-11eb-33f6-57f0a02f1d3b
# ╠═776cca82-1a01-11eb-2475-a3269f3c61d2
# ╟─92698020-19fd-11eb-2eb1-3f578220f627
# ╠═e99b66d2-1a00-11eb-22f9-092c5da3e997
# ╠═9f360862-1a01-11eb-1cba-bfc31ecaee82
# ╠═a77fc470-1a01-11eb-003c-2390395c662a
# ╠═ad5e73ee-1a01-11eb-3e5f-63abaf00cd69
# ╟─8e30d720-1a0b-11eb-3943-e9bbcc20a252
# ╠═c14e5d80-1a01-11eb-35c9-a7b845a6238f
# ╠═1e8e968e-1a02-11eb-29aa-071d52acb592
# ╠═63099040-1a02-11eb-17c1-5900d46a1035
# ╠═2ffacc62-1a0b-11eb-2178-87c0fa64d604
# ╠═ce7f2d32-1a02-11eb-2718-9359a5d3590d
# ╠═e8f68960-1a02-11eb-1308-772f279c20b9
# ╟─d1b0e0f0-1a09-11eb-35e8-ffa8930b3d1b
