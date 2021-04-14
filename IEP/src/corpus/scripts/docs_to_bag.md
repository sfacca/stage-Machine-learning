## Bag of Words

L'esecuzione delllo script docs_to_bag.jl genera nel workspace variabili bags e vocab a partire dalle string docstring in doc_funs_jld2.

### bags

Seguendo algoritmo bag of words, bags è una matrice sparsa dove ogni colonna è un vettore documento.

Ogni elemento di un vettore documento indica l'abbondanza della parola allo stesso indice nel vocab.

Funzione get_bags ritorna la moltiplicazione dei vettori, ad esempio:

```jldoctest
julia> get_bag(bags[:,1], vocab)
"Vertic", "posit", "posit", "of", "of", "neuron", "neuron", "in", "layer", "i", "j", "with", "a", "total", "N"
```

### vocab

Contiene ogni parola unica nei documenti.