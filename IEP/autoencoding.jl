### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ ef3921b0-5414-11eb-2c7e-991d16f591fc
using PyCall

# ╔═╡ 0882dbb0-5407-11eb-1569-27b6baa881eb
using CSV, DataFrames

# ╔═╡ b621d370-5402-11eb-127b-d1a513535eab
md"* https://github.com/jpfairbanks/SemanticModels.jl/blob/master/doc/src/notebooks/autoencoding_julia.ipynb"

# ╔═╡ e26fb372-5420-11eb-31e0-d55519f4e9c7
#using Conda

# ╔═╡ e63d5d40-5420-11eb-1792-2b120f7f80e2
#Conda.add("tensorflow")

# ╔═╡ 75ef9da0-541b-11eb-0809-a1b669aa2c2c
begin# use of keras through pycall
	tf = pyimport("tensorflow")
	keras = pyimport("tensorflow.keras")
	
	model = keras.Sequential([
			keras.layers.Dense(10, activation="relu"),
			keras.layers.Dense(1, activation="sigmoid")
			])
	model.compile(optimizer="adam", loss="mse")
	
	X_train = tf.random.normal([1000, 3])
	Y_train = tf.random.uniform([1000, 1])
	model.fit(X_train, Y_train, epochs=2)
	
	X_new = tf.random.normal([2, 3])
	model.predict(X_new)
end

# ╔═╡ dd2c26f0-542a-11eb-1cff-0fb0b280c505
latent_dim = 64

# ╔═╡ 37ac38f0-5407-11eb-330f-79a19fda1e61
begin
	funcstrings = split(read("all_funcs.csv", String), ".jl\n")[1:end-1]
	func = DataFrame()
end

# ╔═╡ 607ff73e-542e-11eb-1b6a-6bbf0ba320ea
[split(x, "\t"; limit=2) for x in funcstrings][2]#???

# ╔═╡ b9a61ec0-542f-11eb-1ce0-757095a353c0
size(funcstrings)

# ╔═╡ 56575720-5430-11eb-198c-89ddcb6dc8c4
typeof(repeat('"',3))

# ╔═╡ aaf15c40-5430-11eb-09ee-4b60666f6a43
#write("temp.txt", funcstrings[1])

# ╔═╡ 0a59c1f0-5430-11eb-3382-9541a30e7b84
write("temp.txt", split(funcstrings[1],"\"\"", limit = 3)[3])

# ╔═╡ de7e7e40-542f-11eb-37ba-c3e11ac2af59
println(funcstrings)

# ╔═╡ 6b47d2b0-542e-11eb-2749-3fb3697ed60a
funcstrings[1]

# ╔═╡ f13c90d0-542a-11eb-1332-3f140810d8ad
funcs[1:end-1]

# ╔═╡ 617a8e70-542f-11eb-1108-1fb0485f9773
mystr = "asd, dsa, tre, 123"

# ╔═╡ 69e518f0-542f-11eb-26a3-11abb7cea9fb
split(mystr, ", "; limit=2)

# ╔═╡ a89be240-542a-11eb-0d42-dd7fa5a179f6
#= python source
latent_dim = 64

with open("all_funcs.csv", "r") as f: 
    funcs = f.read()

funcs = funcs.split(".jl\n")
funcs = funcs[:-1] # remove trailing empty item
funcs = pd.DataFrame([x.rsplit("\t",1) for x in funcs])
funcs.columns = ['code','source']
funcs = funcs[funcs.code.apply(lambda x: len(x)<=500)]
funcs.reset_index(drop=True, inplace=True)

funcs.source = funcs.source.apply(lambda x: x[x.index("julia/")+6:])
funcs["top_folder"] = funcs.source.apply(lambda x: x[:x.index("/")])
funcs['top2'] = funcs.source.apply(lambda x: '_'.join(x.split("/")[:2]))
=#

# ╔═╡ Cell order:
# ╟─b621d370-5402-11eb-127b-d1a513535eab
# ╠═ef3921b0-5414-11eb-2c7e-991d16f591fc
# ╠═e26fb372-5420-11eb-31e0-d55519f4e9c7
# ╠═e63d5d40-5420-11eb-1792-2b120f7f80e2
# ╠═75ef9da0-541b-11eb-0809-a1b669aa2c2c
# ╠═0882dbb0-5407-11eb-1569-27b6baa881eb
# ╠═dd2c26f0-542a-11eb-1cff-0fb0b280c505
# ╠═37ac38f0-5407-11eb-330f-79a19fda1e61
# ╠═607ff73e-542e-11eb-1b6a-6bbf0ba320ea
# ╠═b9a61ec0-542f-11eb-1ce0-757095a353c0
# ╠═56575720-5430-11eb-198c-89ddcb6dc8c4
# ╠═aaf15c40-5430-11eb-09ee-4b60666f6a43
# ╠═0a59c1f0-5430-11eb-3382-9541a30e7b84
# ╠═de7e7e40-542f-11eb-37ba-c3e11ac2af59
# ╠═6b47d2b0-542e-11eb-2749-3fb3697ed60a
# ╠═f13c90d0-542a-11eb-1332-3f140810d8ad
# ╠═617a8e70-542f-11eb-1108-1fb0485f9773
# ╠═69e518f0-542f-11eb-26a3-11abb7cea9fb
# ╠═a89be240-542a-11eb-0d42-dd7fa5a179f6
