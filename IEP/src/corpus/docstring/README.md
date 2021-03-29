# NLP su Docstring

Questa cartella contiene codice riguardo operazioni su docstring del corpus.

Gli scripts in /scripts ognuno esegue una qualche operazione sul dataset di nome funzione/docsatring generato in ../scripts/make_doc_funs.jl

Prima di eseguire uno script qualsiasi bisogna attivare l'env in questa cartella tramite

```julia shell
include("activate.jl")
```



### Bag of Words

Lo script scripts/doc_to_bag.jl  genera matrice delle bags e vocabolario secondo schema bag of words a partire da doc_funs.jld2

### Parts of speech tagging

Lo script postag_docstring.jl genera docs taggati tramite Perceptron Tagger (da modulo TextModels), salvati in variabile tagged_docs, a partire dalle docstring in doc_funs.jld2

### LSA

Sempre usando dati in doc_funs.jld2, lo script lo script latent_semantic_analysis.jl esegue esempio descritto a https://zgornel.github.io/StringAnalysis.jl/v0.2/examples/

### Topic Models

Lo script latent_dirichlet_allocation.jl usa modulo TopicModels per dividere le docstring in "topic".

Se mancano genera file vocab.lexicon e bags.documents secondo algoritmo bag_of_words.

Questo script può esser facilmente modificato per cambiare numero di topic o numero di iterazioni per il quale allenare il modello.

### Word Embeddings

Lo script word_embeddings.jl inizializza ambiente per l'uso di word embeddings.

Se TopicModels è presente nel workspace prima dell'esecuzione dello script, lo script come esempio traduce il lexicon in word embeddings.