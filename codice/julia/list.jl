### definizione struct lista
### una lista è una struttura ordinata composta da coppie value/next 
### dove next è puntatore all' elemento prossimo nell ordine e 
### value è il dato che effettivamente vogliamo salvare




export 
    lpush!, lget, lappend!,

end
mutable struct lnode
    value::Any
    next::Union{lnode,Nothing}
end
# per lista dopiam collegata basta aggiungere un campo parent::lnode 

mutable struct List
    first::lnode
    last::lnode
end
# a seconda dell uso può esser utile aggiungere campi come length e puntatore a ultimo elemento
#

#=in genere liste vengono definite con tipo parametrico eg
mutable struct lnode{T}
    value::T
    next::lnode{T}
end

mutable sturct List{T}
    first::lnode{T}
    last::lnode{T}
end

così poi, che ti serva lista di stringe o lista di interi, puoi avere lista con tipo ben definito usando la stessa struct
mynodointero = lnode{Int64}(15,nothing)
mylistadiinteri = List{Int64}(mynodointero,mynodointero)

mynodostringa = etc
=#


function lpush!(list::List, value::Any)
    newnode = lnode(value, list.first) # crea nodo nuovo
    list.last.next = newnode # convenzione: ultimo elemento punta a primo elemento
    list.first = newnode # lo aggiounge in testa alla lista
end

function lappend!(list::List, value::Any)
    newnode = lnode(value, list.first)# convenzione: ultimo elemento punta a primo elemento)
    list.last.next= newnode# aggiorna puntatore next dell ultimo elemento, effettivamente aggiungendo nuovo elemento alla lista
    list.last = newnode #segnala a lista che il nostro nuovo nono è ultimo elemento
end

function lget(list::List, index::Int64)
        #mancano check su index, list tipo index =0 o list = null etc
    res = list.first
    i=0
    
    while i<index&&res.next!=list.first
        res = res.next
        global i = i + 1
    end
    if i!=index
        error("indice invalido")
    end
    res
end

function lget(list::List, value::Any)
    temp = list.first # parte dal primo
    continua = true
    found = false
    while continua==true #stati di fine ciclo: abbiamo trovato il valore, abbiamo finito la lista
        if temp.value==value
                global continua = false
                global found = true #  unico modo per avere esito positivo: 
        elseif temp.next == list.first
                global continua = false
        else
                global temp = temp.next
        end
    end
    #=if !trovato
            error("valore non trovato")
        end=#
    temp
end    
# NB: se la lista è lista di int lget(lista,numero) usa lget sull indice invece il lget su valore


# non so come o se è possibile mettere un null al posto di qualcos altro di tipo definito in julia, quindi per convenzione
# ultimo elemento lista punta a primo elemento lista (lista circolare)


function tryme()
    mynode::lnode=lnode("secondo!",nothing)
    myl::List = List(mynode, mynode)
    @show myl
    # aggiungiamo un nodo con valore terzo! alla fine della lista
    lappend!(myl, "terzo!")
    @show myl
    #aggiungiamo nodo primo! all inizio della lista
    lpush!(myl, "primo!")
    @show myl
end
tryme()

# i puntatori in julia non funzionano così
# julia non ha puntatori!
# dovevo definirla come oggetto lista!




