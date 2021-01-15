### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 70adc620-5757-11eb-2c1b-8548cd17d589
using Pkg

# ╔═╡ c95a9ef0-5758-11eb-279b-e109471580d0
using SymbolicCodegen

# ╔═╡ b0944390-5757-11eb-01cc-979f7a74336a
using Soss

# ╔═╡ b0cf9ee0-5757-11eb-1493-7f0e64e8255d
Pkg.activate(".")

# ╔═╡ 99474f80-575b-11eb-39d6-c3b621110fd5


# ╔═╡ 9d760510-575b-11eb-250b-1f603255eb1b
#Pkg.add(url="https://github.com/cscherrer/MeasureTheory.jl")

# ╔═╡ c49aeca0-575b-11eb-1760-419c54ecfcab
Pkg.add("NestedTuples")

# ╔═╡ a33c2380-575b-11eb-0ebc-b3e00138ffe0


# ╔═╡ 364481d2-5758-11eb-349f-b7b5db36bd4f
begin
	m = @model σ begin
			   μ ~ StudentT(3.0)
			   x ~ Normal(μ, σ) |> iid(1000)
			   return x
		   end;
	x = rand(m(σ=2.0));
end

# ╔═╡ 0e631620-575a-11eb-26a6-6f919eb56906
#x = rand(m(σ=2.0));

# ╔═╡ 064a1c1e-575c-11eb-259b-3b19953ed288
;x

# ╔═╡ fc6b2c00-5759-11eb-351c-131662a139ec
post = m(σ=2.0) | (;x)

# ╔═╡ 0225b1b0-575a-11eb-3127-f1d291dc8722
@model σ begin
        μ ~ StudentT(3.0)
        x ~ Normal(μ, σ) |> iid(1000)
        return x
    end

# ╔═╡ 381a5342-5758-11eb-1102-6107c6bcc471
SymbolicCodegen.cse

# ╔═╡ Cell order:
# ╠═70adc620-5757-11eb-2c1b-8548cd17d589
# ╠═b0cf9ee0-5757-11eb-1493-7f0e64e8255d
# ╠═c95a9ef0-5758-11eb-279b-e109471580d0
# ╠═99474f80-575b-11eb-39d6-c3b621110fd5
# ╠═9d760510-575b-11eb-250b-1f603255eb1b
# ╠═c49aeca0-575b-11eb-1760-419c54ecfcab
# ╠═a33c2380-575b-11eb-0ebc-b3e00138ffe0
# ╠═b0944390-5757-11eb-01cc-979f7a74336a
# ╠═364481d2-5758-11eb-349f-b7b5db36bd4f
# ╠═0e631620-575a-11eb-26a6-6f919eb56906
# ╠═064a1c1e-575c-11eb-259b-3b19953ed288
# ╠═fc6b2c00-5759-11eb-351c-131662a139ec
# ╠═0225b1b0-575a-11eb-3127-f1d291dc8722
# ╠═381a5342-5758-11eb-1102-6107c6bcc471
