### definizione struct lista
### una lista è una struttura ordinata composta da coppie value/next 
### dove next è puntatore all' elemento prossimo nell ordine e 
### value è il dato che effettivamente vogliamo salvare

module lists

export lnode, List, lpush!, lappend!, lget, printList

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

function lpush!(list::List, value::Any)
    newnode = lnode(value, list.first) # crea nodo nuovo
    #list.last.next = newnode
    list.first = newnode # lo aggiounge in testa alla lista
end

function lappend!(list::List, value::Any)
    newnode = lnode(value, nothing)
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

function printList(list::List)
    mynode = list.first
    while mynode.next!=nothing
        println(mynode.value)
        mynode = mynode.next
    end
    println(mynode.value)#print ultimo elemento
end

end