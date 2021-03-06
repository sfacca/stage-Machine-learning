"""
stems/tokenizes target keyword, then searches for docs that contain the keyword
"""
function find_function(str::String, docs; pretokenized = false)
    str = stem_tokenize_doc(StringDocument(str))


    if !pretokenized
        println("docs are not tokenized")
        if typeof(docs)== Array{String,1}
            println("stem tokenizing docs")
            docs = stem_tokenize_doc([StringDocument(x) for x in docs])
        elseif typeof(docs) == Array{StringDocument{String},1}
            println("stem tokenizing docs")
            docs = stem_tokenize_doc(docs)
        end
    end

    println("asd")
    findall((x)->(str[1] in x), docs)
end

#requires tokenizer.jl