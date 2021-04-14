## Da nulla a topic models



## creazione corpus

1. crea scrapes dei moduli julia che  ci interessano:

   nella cartella corpus, esegui julia

   ```julia
   include("activate.jl")
   include("scripts/make_scrapes.jl")
   ```

   

2. crea doc_fun dataset contenente solo nomi funzioni e docstring

   ```julia
   include("scripts/make_scrapes.jl")
   ```

## bag of words

1. esegui julia nella cartella docstring

2. attiva env e carica dataset fatto nella sezione prima
  ```julia
  include("activate.jl")
  include("tokenize.jl")
  include("scripts/load_docs.jl")
  ```
  il secondo script lascia nel workspace variabili strings e names.
  la variabile strings contiene le docstrings che divideremo per topic, mentre names contiene i nomi delle funzioni relative

4. includi codice relativo a bag of words e esegui

  ```julia
  include("bag_of_words.jl")
  bags, vocab = bag_of_words(strings)
  ```
  questo codice genera bags e vocab

### lexicon/documents

5. creiamo lexicon e documents
  ```julia
  include("make_documents.jl")
  include("make_lexicon.jl")
  write_documents(bags)
  write_lexicon(vocab)
  ```

   lexicon e bags dei documenti verranno salvati rispettivamente in vocab.lexicon e   bags.documents, si può cambiare nome file:

```julia
write_documents(bags, "altro_nome")
```

### topics model

6. usiamo le funzioni di TopicModels per leggere i dati e creiamo il corpus

```julia
documents = readDocs(open("bags.documents"))
lexicon = readLexicon(open("vocab.lexicon"))
crps = TopicModels.Corpus(documents, lexicon)
```

7.  generiamo ora il modello, decidiamo un numero di topic in cui dividere le docstring e diamo pesi iniziali in vettori.

   topicnum è il nostro numero di topic.

   ```julia
   topicnum = 10
   mdl = TopicModels.Model(
       fill(0.1, topicnum), 
       fill(0.1, length(lexicon)), 
       crps
   )
   ```

   creiamo poi lo stato iniziale:

```julia
st = TopicModels.State(mdl, crps)
```

8. alleniamo il modello, iterando un numero iterations di volte:

   ```julia
   iterations = 30
   TopicModels.trainModel(mdl, st, iterations)
   ```

9. abbiamo ora un modello che ha diviso il corpus di docstring rispetto ai contenuti di parole, possiamo vedere le parole più comuni rispetto ai vari topic cosi:

   ```
   topWords = TopicModels.topTopicWords(mdl, st, numwords)
   ```

   