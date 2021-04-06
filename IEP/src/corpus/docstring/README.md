# NLP su Docstring

Questa cartella contiene codice riguardo operazioni su docstring del corpus.

Gli scripts in /scripts ognuno esegue una qualche operazione sul dataset di nome funzione/docsatring generato in ../scripts/make_doc_funs.jl

Prima di eseguire uno script qualsiasi bisogna attivare l'env in questa cartella tramite

```julia shell
include("activate.jl")
```
### Load doc fun

I workflow in questa sezione usano i dati di docstring/nome funzione generati e salvati da ../scripts/make_doc_funs.jl.
Sono salvati in ./dic_funs.jld2 e devono essere caricati.

Il procedimento per caricare questi dati è visible nello script scripts/load_docs.jl:
```julia shell
#1
using JLD2, FileIO
using TextAnalysis
include("../doc_fun.jl")

#2
doc_funs = FileIO.load("doc_funs.jld2")["doc_funs"]
doc_funs = filter((x)->(x.doc != "error finding triplestring"),doc_funs)


#3
strings = [StringDocument(x.doc) for x in doc_funs]
names = [StringDocument(x.fun) for x in doc_funs]
doc_funs = nothing
```
Possiamo dividere il procedimento in 3 parti: preparazione workspace, lettura dati, conversione in tipi utilizzabili
1. Come prima cosa carica i moduli e la definizione dei doc_fun.
   I moduli sono JLD2 e FileIO per la lettura dei dati e TextAnalysis per il trattamento in modi poi usabili da altro codice.
2. L'estrazione dei dati avviene con struttura ugualer a quella vista in precedenza nelle spiegazioni per codice nella cartella corpus:
   Un file JLD2 contiene un dizionario, usiamo come unica chiave il nome del file ("doc_funs" per questo caso) che ritorna i dati effettivi che ci interessano (in questo caso un array di doc_fun).
   Rimuoviamo inoltre le doc_fun con docstring erronee.
3. Per operazioni di NLP useremo per lo più funzioni dei pacchetti TextAnalysis e TopicModels, entrambi questi pacchetti lavoprano su dati Document, definiti in TextyAnalysis, convertiamo quindi docs e nomi in questi tipi.
   
Dopo l'esecuzione di questo script avremo una variabile strings, contenente un array delle docstring sottof roma di StringDocument, e una names, che sarà l'array dei nomi funzione relativi, sempre sotto forma di StringDocument.
Per come sono generati, l'iesimo elemento dell'array names sarà il nome della funzione relativa alla docstring allo stesso indice nell'array strings.

### Bag of Words

Lo script scripts/doc_to_bag.jl  genera matrice delle bags e vocabolario secondo schema bag of words a partire da doc_funs.jld2

Per il modello bag of words vogliamo ottenere due elementi:
1. Un array "vocabolario" di parole, contenente tutte le parole nel corpus
2. Un array contenente tanti array di Int quanti sono i documenti nel corpus, ognuno di questi documenti vettore (ogni bag) avrà lunghezza pari alla lunghezza del vocabolario e rappresenterà il quantitativo di ciascuna parola all interno del documento.

Ad esempio:
* Documenti originali:  "It was the best of times"
                        "it was the worst of times"
                        "it was the age of wisdom"
                        "it was the age of foolishness"
* Vocabolario:  [“it”,“was”, “the”, “best”, “of”, “times”, “worst”, “age”, “wisdom”, “foolishness”]
* bags :        [1, 1, 1, 1, 1, 1, 0, 0, 0, 0]
                [1, 1, 1, 0, 1, 1, 1, 0, 0, 0]
                [1, 1, 1, 0, 1, 0, 0, 1, 1, 0]
                [1, 1, 1, 0, 1, 0, 0, 1, 0, 1]

Come passaggio intermedio vogliamo anche ridurre ogni parola alla sua radice (eliminando declinazioni e altro).
```julia shell
    println("including code...")
    include("../tokenize.jl")
    include("../bag_of_words.jl")

    include("load_docs.jl")
    
    bags, vocab = bag_of_words(strings)
```
Lo script, dopo aver caricato i codice e dati usando lo script load_docs.jl descritto sopra, semplicemente usa la funzione bag_of_words definita in "bag_of_words.jl", vediamo come funziona questa funzione.
```julia shell
function bag_of_words(docs::Array{StringDocument{String},1}; stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize)
```
Alla funzione serve solo l'array di documenti (per noi docstrings), sotto forma di StringDocument.
Si possono anche dichiarare stemmer (per togliere terminazioni dalle parole) e tokenizer (per spezzare dostring in elementi) particolari.

La prima parte consiste nella pretrattamento delle string:
```julia shell
docs = stem_tokenize_doc(docs; stemmer = stemmer, tokenizer = tokenizer) 
```
Questa call equivale a eseguire il seguente codice su ogni documento sd:
```julia shell
    stem!(stemmer, sd)
    tokenizer(text(sd))
```
stem! è lo stemmer di TextAnalysis, visibile [qui](https://github.com/JuliaText/TextAnalysis.jl/blob/master/src/stemmer.jl) e modifica il testo, usando lo stemmer passato, rimuoivendo le terminazioni alle parole.
Come secondo passaggio usiamo il tokenizer passato sul string document per ritornare i token del documento come array di string.

Dopo il pre-trattamento creiamo il vocabolario:
```julia shell
    vocab = Array{String,1}(undef,0) #1
    for doc in docs #2
        for item in doc #2
            push!(vocab, item) #2
        end
    end
    vocab = unique(vocab) #3
```
Il procedimento è semplice:
1. inizializza il vocabolario, come array di string, vuoto
2. scorre ogni array documento, prende ogni token, e lo aggiunge al vocabolario
3. rimuove tutti gli elementi doppi nel vocabolario
Alla fine avremo un array contenente una copia di token unico in docs.

Dopo aver creato il vocabolario, lo usiamo per generare i vettori documento
```julia shell
    #1
    rows = length(vocab)#number of words in vocab
    cols = length(docs)#number of docs
    vecs = spzeros(Int32, rows,cols)
    
    #2
    for i in 1:length(docs)# works on i-th document vector column
        for j in 1:length(docs[i])#works on the jth word of the doc

            #2.1
            x = findfirst((x)->(x == docs[i][j]), vocab)

            #2.2
            if isnothing(x)
                throw("could not find stem : $(docs[i][j]) in vocab")
            end

            #2.3
            vecs[x, i]+=1
        end
    end 
```
Il procedimento è il seguente:
1. Vogliamo che il risultato sia una matrice le cui colonne siano ognuna un document vector. Per chiarezza quindi dichiariamo variabili rows e cols per il numero di righe e colonne della colonna. Usando questi poi dichiariamo una matrice sparsa (per risparmiare spazio) di Int32 inizializzati a 0.
2. Dopodiché scorriamo i dati nel docs in maniera tale che i indichi il documento (array di token) che stiamo gestendo e j il token stesso all'interno di quest'array, per ogni token quindi:
   1. Troviamo l'indice x della parola uguale nel vocabolario
   2. Non dovrebbe assolutamente succedere che la parola non venga trovata, quindi se ciò accade lanciamo un errore
   3. Aumenta il conto del x-esimo elemento del document vector i, ciò significa aumentare l'ammontare di quella parola nel bag di quella docstring

Come ultima cosa, la funzione ritorna la matrice e il vocabolario.
```julia shell
    vecs, vocab
```

### Parts of speech tagging

Lo script postag_docstrings.jl genera docs taggati tramite Perceptron Tagger (da modulo TextModels), salvati in variabile tagged_docs, a partire dalle docstring in doc_funs.jld2

Lo script usa funzioni da tre moduli, tutti da [JuliaText](https://github.com/JuliaText)
1. [TextAnalysis](https://github.com/JuliaText/TextAnalysis.jl), per la gestione base dei dati (Documents)
2. [TextModels](https://github.com/JuliaText/TextModels.jl), da cui prenderemo il pos(parts of speech) tagger
3. [WordTokenizers](https://github.com/JuliaText/WordTokenizers.jl), per la tokenizzazione
```julia shell
using TextAnalysis, TextModels, WordTokenizers
```

Le funzioni sono definite in tag_pos.jl, inoltre carichiamo automaticamente i dati dai doc_fun con lo script descritto in precedenza:
```julia shell
include("load_docs.jl")
include("../tag_pos.jl")
```

Dopo aver caricato codice e moduli, prepariamo uno stemmer e un tagger.
Lo stemmer è quello di TextAnalysis mentre il tagger è un [PerceptronTagger, definito in TextModels](https://github.com/JuliaText/TextModels.jl/blob/master/src/averagePerceptronTagger.jl), [originariamente creato da Matthew Honnibal](https://github.com/hankcs/AveragedPerceptronPython/blob/master/PerceptronTagger.py)
```julia shell
stemmer = Stemmer("english")
tagger = TextModels.PerceptronTagger(true)
```

Preparato il tutto eseguiamo il codice:
```julia shell
tagged_docs = postag_docstring(strings, stemmer, tagger)
```

Il codice della funzione postag_docstring è il seguente:
```julia shell
    res = Array{Any,1}(undef, length(data))
    for i in 1:length(data)
        res[i] = postag_docstring(data[i], stemmer, tagger)
    end
    res    
```
    Il codice inizia creando un array di lunghezza pari all'array in entrata (nel nostro caso l'array di StringDocument strings), poi scorre l'array in input e, per ogni elemento, ne crea la versione taggata con un altra funzione omonima e inserisce questo risultato nello stesso indice nell'array di risultato.
    A ognuna di queste chiamate passiamo gli stessi tagger/stemmer creati in precedenza, dovremmo altrimenti ricrearli per ogni operazione, cosa che costerebbe parecchio tempo.
    Sono previsti input di dati sia come array di string che di stringdocument, nel secondo caso dai documenti vengono presi i testi, che sono string.
```julia shell
    postag_docstring(docstring.text, stemmer, tagger)
```
    Il procedimento per ogni docstring da taggare è quindi:
```julia shell
    #1
    res = split_sentences(docstring)
    res = [StringDocument(string(x)) for x in res]

    #2
    for str in res
        stem!(stemmer, str)
    end

    #3
    PoSTag(res, tagger)
```
    Diviso in 3 parti, consiste nel
    1. Dividere le docstring in frasi, usando split_sentences da WordTokenizers, e riportare i dati in StringDocument
       NB: split sentences ritorna array di SubString, dobbiamo quindi convertire ciò in String con string()
    2. Eseguire lo stemming (rimozione delle terminazioni delle parole)
    3. Taggare le frasi con il tagger passato (Average Perceptron Tagger): 
       PoSTag, in pratica, per ogni StringDocument(frase) str, esegue il seguente codice:
       ```julia shell  
        predict(#a
            tagger, #b
            _cln(str.text) #c
            )
       ```
       a. predict è funzione di TextAnalysis
       b. il tagger è il Perceptron Tagger creato in precedenza
       c. passiamo il testo attraverso una funzione che rimuove frasi contenente caratteri non ASCII
    Il risultato ottenuto è un array.
    Ogni elemento di quest array è un array, rappresentante una docstring, i cui elementi sono a loro volta array, rappresentanti frasi della docstring, che contengono tuple (parola, tag)

### LSA

Sempre usando dati in doc_funs.jld2, lo script lo script latent_semantic_analysis.jl esegue esempio descritto a https://zgornel.github.io/StringAnalysis.jl/v0.2/examples/

```julia shell

```
```julia shell

```
```julia shell

```
```julia shell

```

### Topic Models

Lo script latent_dirichlet_allocation.jl usa modulo TopicModels per dividere le docstring in "topic".

Se mancano genera file vocab.lexicon e bags.documents secondo algoritmo bag_of_words.

Questo script può esser facilmente modificato per cambiare numero di topic o numero di iterazioni per il quale allenare il modello.

### Word Embeddings

Lo script word_embeddings.jl inizializza ambiente per l'uso di word embeddings.

Se TopicModels è presente nel workspace prima dell'esecuzione dello script, lo script come esempio traduce il lexicon in word embeddings.

