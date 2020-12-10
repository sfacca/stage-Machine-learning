### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ f1e2b160-388a-11eb-02fc-1fef235d53ba
using Pkg, BenchmarkTools

# ╔═╡ 323425a0-388b-11eb-318e-9f25a57a8d06
include("../../src/PrismaConvert.jl");

# ╔═╡ bfb383a0-3889-11eb-3520-5dea827d47c0
md"mem alloc of maketif function"

# ╔═╡ 32344cae-388b-11eb-1711-a5b45e6007d5
Pkg.activate("../../")

# ╔═╡ 738e6fa0-3891-11eb-1326-e3818e21f8c3
f = PrismaConvert.open("../data/PRS_L2D_STD_20190911102308_20190911102313_0001.he5")

# ╔═╡ 3236e4c0-388b-11eb-372a-b11d4eccac23
function foo()
	try
		println("========================================BENCH")
		bench = @benchmark PrismaConvert.maketif(
		f.dict["file $((f.counter) - 1)"],
		"out/out3"
	)
		PrismaConvert.close(f)
		#rm("out",recursive=true)
		println("=============================================")
		bench
	catch e
		PrismaConvert.close(f)
		e
	end
end

# ╔═╡ ece81d50-38ab-11eb-1dfa-cb1df5f76b4d
foo()

# ╔═╡ 18037b20-38a6-11eb-233c-89a842b2cf61
bench

# ╔═╡ 6f2ba530-38a6-11eb-052f-894b4795e304
rm("out",recursive=true)

# ╔═╡ Cell order:
# ╟─bfb383a0-3889-11eb-3520-5dea827d47c0
# ╠═f1e2b160-388a-11eb-02fc-1fef235d53ba
# ╠═323425a0-388b-11eb-318e-9f25a57a8d06
# ╠═32344cae-388b-11eb-1711-a5b45e6007d5
# ╠═738e6fa0-3891-11eb-1326-e3818e21f8c3
# ╠═3236e4c0-388b-11eb-372a-b11d4eccac23
# ╠═ece81d50-38ab-11eb-1dfa-cb1df5f76b4d
# ╠═18037b20-38a6-11eb-233c-89a842b2cf61
# ╠═6f2ba530-38a6-11eb-052f-894b4795e304
