# Corpus

Questa cartella contiene codice e script per generare corpus dati per IEP.

Tutti gli script van eseguiti solo dopo il setup dell workspace:

```julia shell
include("activate.jl")
```

---

### Registry

Per scaricare automaticamente moduli, uso un dizionario nome modulo -> url dove scaricarlo.

Questo dizionario è generato dallo script make_registry.jl

```julia shell
include("scripts/make_registry.jl")
```

---

### Scrapes

Le parti del corpus vengono generate a partire da file jld2 contenenti FunctionDefinition con informazioni sul codice.

Lo script make_scrapes.jl genera questi file in una cartella scrapes.

Legge i nomi dei moduli dal file pkg_corpus.txt

```julia shell
include("scripts/make_scrapes.jl")
```

---

### Dictionary

Il dizionario simbolo -> esempio viene generato a partire dagli scrapes in /scrapes dallo script

```julia shell
include("scripts/make_dictionary.jl")
```

---

### CSet

Il CSet usato è definito in IEP\src\CSet\newSchema\get_newSchema.jl, viene generato a partire dagli scrapes in /scrapes dallo script

```julia shell
include("scripts/make_cset.jl")
```

---

## Docstring

Per NLP sulle docstring usiamo un file doc_fun.jld2 dove salviamo dati importanti


### Fun/Doc

Per nlp sulle docstring ci bastano le docstring collegate alle funzioni. Questo dataset ridotto viene creato, a partire dagli scrapes in /scrapes dallo script

```julia shell
include("scripts/make_doc_funs.jl")
```



il resto delle operazioni su docstring sono nella cartella docstring, contenente README.md

