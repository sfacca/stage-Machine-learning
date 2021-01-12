### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ ef3921b0-5414-11eb-2c7e-991d16f591fc
using PyCall

# ╔═╡ 0882dbb0-5407-11eb-1569-27b6baa881eb
using CSV, DataFrames

# ╔═╡ fa19cb80-54f4-11eb-3d67-8de6b34b07e6
using Tokenize

# ╔═╡ fb8fd540-54ea-11eb-38e5-fb268eb6be7f
using Rmath

# ╔═╡ b621d370-5402-11eb-127b-d1a513535eab
md"* [https://github.com/jpfairbanks/SemanticModels.jl/blob/master/doc/src/notebooks/autoencoding_julia.ipynb](https://github.com/jpfairbanks/SemanticModels.jl/blob/master/doc/src/notebooks/autoencoding_julia.ipynb)
"

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

# ╔═╡ d25912c0-54ec-11eb-018a-c91134368790
length_limit = 500 #maximum length of code string

# ╔═╡ 37ac38f0-5407-11eb-330f-79a19fda1e61
begin
	funcstrings = split(read("all_funcs.csv", String), ".jl\n")[1:end-1]# splits over file origins
	aux = [rsplit(x, "\t", limit = 2) for x in funcstrings]# splits code from source
	#try extracting documentation from code 
	# (only extracts triple " docs from right before func definition)
	# (only works if every sample has such documentation)
	try
		global code = [split(x[1], "\"\"", limit=3)[3] for x in aux]	
		global docu = [split(x[1], "\"\"", limit=3)[2] for x in aux]	
	catch e
		@warn e
		global code = [x[1] for x in aux]
		global docu = repeat(["no documentation"], length(aux))
	end
	#makes source/code DB
	#removes entries where length of code string is >length_limit
	func = filter(
		x->(length(x[2])<=length_limit), 
		DataFrame(documentation = docu, code=code, source=[x[2] for x in aux])
	)
	 #func[top_folder=[func[!,2]]]
end

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

# ╔═╡ bee82af0-54f1-11eb-2e66-7fcdcfc8d9dc
md"We define two utility functions to aid in our encoding: chars\_to\_indices() which translates Julia source code into integers representing each character, and ae_models which build our autoencoder architecture. This second function returns two models - the full autoencoder, as well as the encoder sub-component. We use this second model to encode our Julia source code sequences after training is complete."

# ╔═╡ f2267430-54f1-11eb-3e01-433b81c14931
function chars_to_indices(data, tok=nothing, max_len=nothing)
	if isnothing(max_len)
		maximum([length(x) for x in data])
	end
	
	if isnothing(tok)
		tok = Tokenize.tokenize
	end

# ╔═╡ 0dbc0a40-54f5-11eb-3d24-6d9498e073a4
collect(Tokenize.tokenize("function f(x) end"))

# ╔═╡ 172762f0-54f5-11eb-23d8-f582cd759c6c
func[!,:code]

# ╔═╡ fd1ad67e-54f4-11eb-2929-5fe619965ef3
[collect(tokenize(x)) for x in func[!,:code]]

# ╔═╡ c0ff9942-54f1-11eb-170b-91e58b4f9cef
#= py source 

def chars_to_indices(data, tok=None, max_len=None):
    if max_len is None:
        max_len = max(data.apply(lambda x: len(x)))

    if tok is None:
        tok = Tokenizer(num_words=None, 
                        filters="", 
                        lower=False, 
                        split='', 
                        char_level=True)

    data = data.values
    tok.fit_on_texts(data)
    sequences = tok.texts_to_sequences(data)
    sequences = pad_sequences(sequences, 
                              maxlen=max_len, 
                              padding='post')
    sequences = np.array(sequences, dtype='int16')

    return sequences, tok

def ae_models(maxlen, latent_dim, N, use_gpu=False):
    inputs = Input((maxlen,), name='Encoder_Inputs')
    encoded = Embedding(N, 
                        latent_dim, 
                        name='Char_Embedding', 
                        mask_zero=False)(inputs)
    encoded = BatchNormalization(name='BatchNorm_Encoder')(encoded)

    if use_gpu:
        _, state_h = CuDNNGRU(latent_dim, return_state=True)(encoded)
    else:
        _, state_h = GRU(latent_dim, return_state=True)(encoded)

    enc = Model(inputs=inputs, outputs=state_h, name='Encoder_Model')
    enc_out = enc(inputs)

    dec_inputs = Input(shape=(None,), name='Decoder_Inputs')
    decoded = Embedding(N, 
                        latent_dim, 
                        name='Decoder_Embedding', 
                        mask_zero=False)(dec_inputs)
    decoded = BatchNormalization(name='BatchNorm_Decoder_1')(decoded)

    if use_gpu:
        dec_out, _ = CuDNNGRU(latent_dim, 
                              return_state=True, 
                              return_sequences=True)(decoded, initial_state=enc_out)
    else:
        dec_out, _ = GRU(latent_dim, 
                         return_state=True, 
                         return_sequences=True)(decoded, initial_state=enc_out)

    dec_out = BatchNormalization(name='BatchNorm_Decoder_2')(dec_out)
    dec_out = Dense(N, activation='softmax', name='Final_Out')(dec_out)

    sequence_autoencoder = Model(inputs=[inputs, dec_inputs], outputs=dec_out)

    return sequence_autoencoder, enc

=#

# ╔═╡ Cell order:
# ╟─b621d370-5402-11eb-127b-d1a513535eab
# ╠═ef3921b0-5414-11eb-2c7e-991d16f591fc
# ╠═e26fb372-5420-11eb-31e0-d55519f4e9c7
# ╠═e63d5d40-5420-11eb-1792-2b120f7f80e2
# ╠═75ef9da0-541b-11eb-0809-a1b669aa2c2c
# ╠═0882dbb0-5407-11eb-1569-27b6baa881eb
# ╠═dd2c26f0-542a-11eb-1cff-0fb0b280c505
# ╠═d25912c0-54ec-11eb-018a-c91134368790
# ╠═37ac38f0-5407-11eb-330f-79a19fda1e61
# ╠═a89be240-542a-11eb-0d42-dd7fa5a179f6
# ╟─bee82af0-54f1-11eb-2e66-7fcdcfc8d9dc
# ╠═f2267430-54f1-11eb-3e01-433b81c14931
# ╠═fa19cb80-54f4-11eb-3d67-8de6b34b07e6
# ╠═0dbc0a40-54f5-11eb-3d24-6d9498e073a4
# ╠═172762f0-54f5-11eb-23d8-f582cd759c6c
# ╠═fd1ad67e-54f4-11eb-2929-5fe619965ef3
# ╠═c0ff9942-54f1-11eb-170b-91e58b4f9cef
# ╠═fb8fd540-54ea-11eb-38e5-fb268eb6be7f
