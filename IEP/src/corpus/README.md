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

Il dizionario è ottenuto scaricando la repo "https://github.com/JuliaRegistries/General/archive/master.zip" contenente informazioni usate dal Pkg manager di Julia.

```julia
mkpath("tmp")
download("https://github.com/JuliaRegistries/General/archive/master.zip","tmp/master.zip")
unzip("tmp/master.zip")
mds = unique(get_ModuleDefs("tmp/General-master"))
```
Dopo aver estratto i file in una cartella temporanea, get_ModuleDefs (definito in make_registry.jl) esplora il folder tree cercando toml dai quali ottenere indirizzo alla repo del pacchetto e altre informazioni tramite funzione Toml_to_ModuleDef definita nello stesso file
```julia
for (root, dirs, files) in walkdir(dir)	
    for file in files
        if endswith(file, ".toml")
            push!(res, Toml_to_ModuleDef(joinpath(root, file)))
        end
    end
end
```
Toml_to_ModuleDef legge il toml trovato, lo divide per linea, e cerca le definizioni di nome, url alla repo e versione(id) del modulo
```julia
if occursin(r"repo =", part)
    url = replace(
        string(
            split(part, "\"")[2]
            ,
            "12 34"),
        r".git12 34"=>"/archive/master.zip"
    )
elseif occursin(r"uuid = ", part)
    version = split(part, "\"")[2]
elseif occursin(r"name = ", part)
    name = split(part, "\"")[2]
end
```
NB: l'url nel toml è alla pagina della repo, a noi serve il link diretto allo .zip contenente il source code.

Per solidità, il risultato è passato in struct ben definita
```julia
struct ModuleDef
	version::String
	url::String
	name::String
end
```
Ottenuti i dati su tutti i moduli registrati, viene creato il dizionario nome modulo -> url al zip per scaricarlo
```julia
for md in arr
    if md.name == "" || md.url == ""
    else
        push!(dict, md.name => md.url)
    end
end
return dict
```
Il dizionario così ottenuto è poi salvato in jld2 per essere usato per scaricare più facilmente source code senza dover ricercare url ogni volta.  
```julia
save( "../registry/modules_dict.jld2", Dict("modules_dict"=>modules_dict))
```
Da notare la struttura jld2: il file è un dizionario, la voce "modules_dict" punta al dizionario vero e proprio, salvato nel file stesso.
Per ottenere i dati salvati veri e propri dovremmo quindi indicizzare il dizionario salvato secondo un nome.
Per convenzione i dati che salvo su file jld2 sono indicizzati secondo il nome del file stesso:
```julia
dati = load("$nome.jld2")["$nome"]
```
---

### Scrapes

Le parti del corpus vengono generate a partire da file jld2 contenenti FunctionDefinition con informazioni sul codice.

Lo script make_scrapes.jl genera questi file in una cartella scrapes.

```julia shell
include("scripts/make_scrapes.jl")
```

Per scaricare i moduli serve il file registry descritto nella sezione precedente, vogliamo quindi prima controllare che sia presente e crearlo (includendo script make_registry) altrimenti.
```julia shell
if !isfile("registry/modules_dict.jld2")
    include("make_registry.jl")
end
```

Una volta controllato che ci sia il registry (o una volta creato), possiamo caricarlo tramite funzione load del pacchetto FileIO
```julia shell
modules_dict = load("registry/modules_dict.jld2")["modules_dict"]
```

La seconda cosa che ci serve sono i nomi dei pacchetti dai quali prendere dati.
Tali nomi li prendiamo dal file pkg_corpus.txt.
Ogni linea del file contiene il nome completo di un modulo o il link diretto a un zip contenente codice.
Dividiamo quindi il contenuto rispetto a \n  ed eliminiamo \r
```julia shell
names = unique([replace(string(x), r"\r"=>"") for x in split(read("pkg_corpus.txt",String),"\n")])
```
Con i nomi dei moduli e il registro per ricavare link al source code, possiamo finalmente scaricare il codice e ricavarne le informazioni che ci interessano
```julia shell
save_scrapes_from_Modules(modules_dict, names)
```
Questa funzione scorre names e per ogni elemento ricava il link al codice o scarica direttamente se riconosce link
```julia shell
for name in names
    try
        if contains(".zip", name)
            single_scrape_save(name)
        else
            single_scrape_save(dict, name)
        end
    catch e
        println("error on name: $name")
        println(e)
        push!(fails, (name, e))
    end    
end
```
La funzione crea inoltre array di tutti gli elementi della lista moduli che han dato errori in single_scrape_save, questo array è il risultato della funzione.

single_scrape_save è la funzione che effettivamente ottiene e salva i dati, esiste in due versioni, a seconda che l'elemento estratto dall'array names sia un url o solo un nome modulo.
Nel primo caso, deve risalire al nome del modulo dall'url passata
```julia shell
    name = string(split(replace(url, r"/archive/master.zip"=>""),"/")[end])
```
Nel secondo caso, ottiene l'url da scaricare dal dizionario/registro (preso da modules_dict.jld2)
```julia shell
    download(dict[name], "tmp/$name/file.zip")
```
Il resto del procedimento è simile per entrambe le versioni
1. crea cartella temporanea
2. scarica source code archiviato da url passata* o ottenuta dal dizionario**
3. estrae dati da archivio nella cartella temporanea
4. parsa codice trovato usando funzione IEP.read_code
   IEP.read_code esplora la cartella cercando file .jl, .ipnyb, e .md 
   ```julia shell
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file, ".jl")
                # -> 1
            elseif endswith(file, ".ipynb")
                # -> 2
            elseif endswith(file, ".md")
                # -> 3
            end
        end
    end
   ```
   1. File .jl vengono parsati direttamente usando il parser di CSTParser
      ```julia shell
        s = CSTParser.parse(read(joinpath(root, file), String), true)
        if !isnothing(s)
        all_funcs = vcat(
                all_funcs, get_expr(s, joinpath(root, file), verbose));
        end
      ```
      get_expr semplicemente prende rimuove espressioni contenitore :block e ritorna le espressioni interne
      la funzione ritorna coppie (CSTParser.EXPR, source), dove source è path al file contenente l'espressione
   2. i file .ipnyb sono notebook contenente parti codice e parti testo, dobbiamo quindi estrarre le parti codice
      questi file cono strutturati come JSON, usiamo quindi il parser per JSON per poi individuare i blocchi per tipo
      fatto ciò possiamo eseguire le stesse operazioni di prima su ogni blocco codice
      ```julia shell
        pj = [
            string(y["source"]...) for y in filter(
                (x)->(x["cell_type"] == "code") ,
                JSON.parse(join(readlines(joinpath(root, file))))["cells"]
                )
            ]
        for code_cell in pj
            s = CSTParser.parse(code_cell, true)
            if !isnothing(s)
                all_funcs = vcat(
                        all_funcs, get_expr(s, joinpath(root, file), verbose));
            end
        end
      ```
   3. i file markdown possono contenere parti raccolte in /``` che contengono codice
      le cerchiamo e le parsiamo come prima
      ```julia shell
        lines = readlines(joinpath(root, file))
        code = false
        tmp = ""
        for line in lines
            if code
                if line == "```"
                    code = false
                    
                    s = CSTParser.parse(tmp, true)
                    if !isnothing(s)
                        all_funcs = vcat(
                                all_funcs, get_expr(s, joinpath(root, file), verbose));
                    end
                    tmp = ""
                else
                    tmp = string(tmp, "\n", line)
                end
            else
                if line == "```Julia"
                    code = true
                end
            end
        end
      ```
   alla fine read_code ritorna un array di coppie (espressione, source) 
5. ottenuti i parse dei file, estraiamo finalmente i dati che vogliamo tramite funzione IEP.scrape che, semplicemente esegue il seguente codice su ogni 
   coppia espressione/source
   ```julia shell
   if _checkArgs(e)
		res = Array{FunctionContainer,1}(undef,0)
		docs = nothing
		for i in 1:length(e.args)
			if e.args[i].head == :globalrefdoc
				i = getDocs(e,i)
				docs = isnothing(e.args[i].val) ? "error finding triplestring" : e.args[i].val
			end			
			tmp = scrapeFuncDef(e.args[i])
			if !isnothing(tmp)
				res = vcat(res, FunctionContainer(tmp,docs,source))
				docs = nothing
			elseif _checkArgs(e.args[i])
				res = vcat(res, scrape_functions(e.args[i]; source = source))
			end
		end
		return res
	else
		return Array{FunctionContainer,1}(undef,0)
	end
   ```
   il codice cerca nelle sottoespressioni definizioni di funzione e le passa a scrapeFuncDef, che le traduce in FunctionDefinition, struct usata per riassumere dati che prendiamo dalle definizioni di funzione   
   ```julia shell
    struct NameDef
        name::CSTParser.EXPR
        padding::Nothing
    end

    struct InputDef
        name::NameDef
        type::NameDef
    end

    struct FuncDef
        name::Union{NameDef, Int32}
        inputs::Array{InputDef,1}
        block::CSTParser.EXPR
        output::Union{Nothing,NameDef}        
    end

    struct FunctionContainer
        func::FuncDef
        docs::Union{String,Nothing}
        source::Union{String,Nothing}
    end
   ```
   la prima parte del codice riguarda l'individuazione di definizioni di funzione, i modi in cui si possono dichiarare funzioni in julia sono
   1. nome = (input) -> (codice)
   2. nome(input) = (codice)
   3. function nome(input) 
      (codice)
   4. function nome(input)::(output type)
      (codice)
   5. se non trova nessuna di questi pattern, ritorna nothing
   lo stesso codice verrà comunque eseguito sulle sottoespressioni
   ```julia shell
   if isAssignmentOP(e)
		if isArrowOP(e.args[2])
			# 1
		elseif e.args[1].head == :call
			# 2
		end
	elseif e.head == :function
		if e.args[1].head == :call
			# 3
		elseif isTypedefOP(e.args[1])
			# 4
		end	
	else
        # 5
		return nothing
	end
   ```
   1. nel primo caso usiamo funzioni ausiliarie per prendere i dati dall'espressione
   ```julia shell
    return FuncDef(
        NameDef(e.args[1]),
        scrapeInputs(e.args[2].args[1]),
        e
    )
   ```
      NameDef semplicemente crea struttura identificante nome dall'espressione mentre scrapeInputs, funzione per determinare numero, nome e tipi(se specificati) degli input, è un pò più complessa:
      ```julia shell
		for i in 1:length(arr)
			if isTypedefOP(e.args[i])
				# 1
			else
				# 2
			end
		end
      ```
      la funzione itera sull'array di argomenti dell'espressione (dove sono definiti gli input) e identifica input definiti con o senza tipo definito (identificato da operatore :: )
      se una definizione di tipo viene trovata, il codice deve anche differenziare tra definizione normale di tipo* e definizione contenente curly brackets {}**
      ```julia shell
        if length(e.args[i].args)<2
        # **
            arr[i] = InputDef(
                scrapeName(e.args[i].args[1]),
                scrapeName(e.args[i].args[1])
            )
        else
        # *
            arr[i] = InputDef(
            scrapeName(e.args[i].args[1]),
            scrapeName(e.args[i].args[2])
        )
        end
      ```
        se invece il tipo di input non è definito, come tipo viene passato espressione simbolo :Any, preso da un espressione generata al momento
      ```julia shell
        arr[i] = InputDef(
            scrapeName(e.args[i]), 
            scrapeName(CSTParser.parse("x::Any").args[2])
        )
      ```
      questo procedimento viene ripetutto su ogni elemento, ottenendo quindi un array di InputDef.
      Creiamo quindi definizione di funzione con questo array, il nome preso dal primo argomento, e l'espressione totale come blocco codice.
    2. nel caso la funzione sia definita come nome(input) = (blocco di codice), gli input vanno presi dal leftvalue dell'operatore = (quindi nel primo argomento dell'espressione passata) eliminando però il primo elemento che è invece il nome della funzione.
       il blocco di codice invece è nella rightvalue dell'operazione, che parsata è nel secondo argomento dell'espressione.
       Il procedimento è per il resto identico.
   ```julia shell		
    tmp = scrapeInputs(e.args[1])
    inputs = length(tmp) > 1 ? tmp[2:end] : Array{InputDef,1}(undef, 0)
    return FuncDef(
        scrapeName(e.args[1].args[1]),
        inputs,
        e				
    )
   ```
    3. Nel caso di funzioni definite con keyword function, nel caso il primo argomento sia una call, gli argomenti della call definiranno il nome della funzione seguita dalla definizione degli input, mentre il codice sarà nel secondo argomento dell'espressione :function 
   ```julia shell
    if e.args[1].head == :call		
        tmp = scrapeInputs(e.args[1])
        inputs = length(tmp) > 1 ? tmp[2:end] : Array{InputDef,1}(undef, 0)
        return FuncDef(
            scrapeName(e.args[1].args[1]),
            inputs,
            e				
        )
    end
   ```
   4. Se la funzione, definita con keyword fuction, dichiara anche il tipo di ritorno, il primo argomento dell'espressione :function definirà operazione ::
      La call, che definisce nome e input come sopra, sarà nel leftvalue di questa operazione (quindi args[1]) mentre il tipo di ritorno sarà nel secondo argomento.
   ```julia shell
    if _checkArgs(e.args[1])&&_checkArgs(e.args[1].args[1])&&e.args[1].args[1].head == :call	
        tmp = scrapeInputs(e.args[1].args[1])
        inputs = length(tmp) > 1 ? tmp[2:end] : Array{InputDef,1}(undef, 0)
        return FuncDef(
            scrapeName(e.args[1].args[1].args[1]),
            inputs,
            e,
            scrapeName(e.args[1].args[2])
        )
    end
   ```
6. Una volta ottenuti i dati importanti, li salviamo in locale in un file jld2 con lo stesso nome del modulo (preso direttamente come input o estratto  dall'url).
   ```julia shell
    name = string(split(replace(url, r"/archive/master.zip"=>""),"/")[end])
   ```
   Questo file jld2, come in passato, è un dizionario la cui unica chiave è il nome del modulo ed il valore relativo è l'array di FunctionContainer estratte nel passo precedente.
7. Come ultima cosa, vengono pulite le variabilit usate e viene rimossa la cartella temporanea che conteneva source code archiviato ed estratto.
 
```julia shell
mkpath("tmp/$name") #1
# *
download(url, "tmp/$name/file.zip") #2
# **
download(dict[name], "tmp/$name/file.zip") #2
unzip("tmp/$name/file.zip","tmp/$name") #3
parse = IEP.read_code("tmp/$name") #4
scrape = IEP.scrape(parse) #5
save("scrapes/$(name).jld2", Dict(name => scrape)) #6
rm("tmp/$name", recursive = true) #7
scrape = nothing #7
parse = nothing #7
```

Una volta che save_scrapes_from_Modules esegue questo procedimento per ogni nome/url modulo nel file pkg_corpus.txt, avremo una cartella scrapes contenente i file .jld2 dai quali possiamo estrarre array di FunctionContainer, che sono i dati che ci servono.

Per ottenere i dati delle funzioni estratte per un determinato modulo, bisogna aprire il .jld2 di quel nome ed indicizzare al nome stesso il dizionario all'interno:
```julia shell
name = "CSV" # nome del modulo
file = load(joinpath("scrapes", string(name, ".jld2")))# file/dizionario
fcs = file[name] # array di functioncontainer estratti dal codice del modulo
```


---

### Dictionary

Come dizionario vogliamo una struttura con, come chiave, ogni tipo di espressione (indicate dai campi .head) e con un espressione di esempio per ognuno di questi tipi. 
Questo dizionario simbolo -> esempio viene generato a partire dagli scrapes in /scrapes dallo script

```julia shell
include("scripts/make_dictionary.jl")
```
Come prerequisito, per poi salvare in locale il dizionario ottenuto, lo script richiede i pacchetti FileIO e JLD2
```julia shell
using FileIO, JLD2
```
Inoltre lo script utilizza la funzione get_dict dal file corpus.jl.
Questo file contiene anche altre funzioni e potrebbe essere già stato caricato, per velocità includiamo solo se provare a usare la funzione lancia errore:
```julia shell
try
    get_dict
catch
    include("../corpus.jl")
end
```
Una volta assicurato che la funzione ci sia, la lanciamo sulla directory scrapes, che contiene i dati sul codice che vogliamo analizzare.
Per altre informazioni su questi dati vedi la sezione precedente sugli scrapes.
```julia shell
dict = get_dict("scrapes")
```
La funzione esplora esplora il folder tree della cartella indicata in questo modo:
1. inizializza un dizionario vuoto
2. esplora il folder tree finchè non trova un file .jld2
3. estrae i FunctionContainer dal file, accorgendosi di ottenere un array di tipo definito*
4. vogliamo creare dizionario solo dai file del source code, non da esempi e notebook, filtriamo quindi i FunctionContainer, mantenendo solo quelli con source in una cartella src, usando la funzione ausiliaria _in_src
5. creiamo un sottodizionario dai FunctionContainer ricavati, e lo uniamo al dizionario.
   La funzione che effettivamente crea un dizionario è make_head_expr_dict, dal nostro modulo IEP.
   Questa funzione esegue il seguente algoritmo:
   1. mantiene dizionario da poi ritornare
   2. spiana l'espressione portando tutte le sottoespressioni (e sottoespressioni di sottoespressioni) in un array ad una dimensione
      da notare è che sottoespressioni possono essere in args^1, in val^2 e in head^3, flattenExpr prende espressioni/sottoespressioni da questi tre campi:
      ```julia shell
        res = [e]
        if typeof(e.head) == CSTParser.EXPR #1
            res = vcat(res, flattenExpr(e.head))
        end
        
        if typeof(e.val) == CSTParser.EXPR #2
            res = vcat(res, flattenExpr(e.val))
        end
            
        if _checkArgs(e) #3
            for x in e.args
                res = vcat(res, flattenExpr(x))
            end
        end
        res
      ```
   3. scorre l'array e, per ogni espressione, se l'head è un simbolo, aggiunge/sovrascrive nel dizionario, per la chiave dell'head, il valore dell'expr
   4. alla fine ritorna il dizionario costruito
   ```julia shell
        dic = Dict() #1
        flat = unique(flattenExpr(arr))	#2
        for j in 1:length(flat) #3
            if typeof(flat[j].head) == Symbol #3
                dic[flat[j].head] = flat[j] #3
            end
        end
        dic	
    ```
Eseguendo questi passi per ogni file, otteniamo un dizionario per tutto il corpus.
```julia shell
	dict = Dict() #1
	for (root, dirs, files) in walkdir(dir) #2
		for file in files #2
			if endswith(file, ".jld2") #2
				name = string(split(file,".jld2")[1]) #3
				tmp = Array{IEP.FunctionContainer,1}(undef,0) #3 *
				tmp = vcat(tmp, load(joinpath(root, file))[name]) #3
				for fc in tmp #4
					if _in_src(fc.source) #4
						dict = merge(dict, IEP.make_head_expr_dict(fc.func.block)) #5
					end
				end
				tmp = nothing
			end
		end
	end
```
Alla fine, lo script salva il dizionario ottenuto

```julia shell
    prinltn("building dictionary...")
    dict = get_dict("scrapes")
    println("saving dictionary...")
    save("../dictionary.jld2", Dict("dictionary"=>dict))
    dict = nothing
```

---

### CSet

Il CSet usato è definito in IEP\src\CSet\newSchema\get_newSchema.jl, viene generato a partire dagli scrapes in /scrapes dallo script

```julia shell
include("scripts/make_cset.jl")
```

```julia shell
```

```julia shell
```

```julia shell
```

```julia shell
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

