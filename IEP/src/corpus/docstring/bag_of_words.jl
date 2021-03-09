#1 stem strings

#2 make dictionary of unique tokens (word stems) (an array of unique stems)

#3 turn strings in arrays where arr[i] = n -> the strings contains the i-th stem n times
using WordTokenizers, SparseArrays

include("tokenize.jl")

"""
returns vocab array and sparse matrix of document vectors
every column is the vector of a document
"""
function bag_of_words(docs::Array{StringDocument{String},1}; stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize)
    #1 stem + tokenize
    docs = stem_tokenize_doc(docs; stemmer = stemmer, tokenizer = tokenizer) 

    println("docs element types:")    
    println(unique([typeof(x) for x in docs]))

    vocab = []
    for doc in docs
        for item in doc
            push!(vocab, item)
        end
    end
    vocab = unique(vocab)
    println("vocab element types:")
    println(unique([typeof(x) for x in vocab]))
    #every column is a vector
    rows = length(vocab)#number of words in vocab
    cols = length(docs)#number of docs
    vecs = spzeros(rows,cols)
    for i in 1:length(docs)# works on i-th document vector column
        for j in 1:length(docs[i])#works on the jth word of the doc
            x = findfirst((x)->(x == docs[i][j]), vocab)
            if isnothing(x)
                throw("could not find stem : $(docs[i][j]) in vocab")
            end
            vecs[x, i]+=1
        end
    end  
    
    vecs, vocab
end

"""
takes a string or array of strings, returns an array of every unique stem
"""
function unique_stems(str::String, lang="english")
    unique(stem(Stemmer(lang), split(str)))
end
function unique_stems(str::String, s::Stemmer)
    unique(stem(s, split(str)))
end
function unique_stems(arr::Array{String,1}, o=nothing)
    if isnothing(o)
        o = Stemmer("english")
    end
    res = Array{String,1}(undef,0)
    for str in arr
        res = vcat(res, unique_stems(str, o))
    end
    res
end

"""

"""
function get_doc_vec(doc::String, voc::Array{String,1}, o=nothing)
    if isnothing(o)
        o = Stemmer("english")
    end

    stems = unique_stems(doc,o)

    res = Int.(zeros(length(voc)))

    for stem in stems
        res[findfirst((x)->(x==stem),voc)]+=1
    end
    res
end


"""
maps a document vector(array of ints) onto a vocaboulary(array of stems) of same standardize
"""
function get_bag(vec::Array{Int,1}, voc::Array{String,1})
    if length(vec)!=length(voc)
        throw("size mismatch between doc vector and vocaboulary")
        return nothing
    end

    res = []
    for i in 1:length(vec)
        if vec[i] > 0
            for j in 1:vec[i]
                push!(res, voc[i])
            end
        end
    end
    res
end


# below functions work with tokenized arrays of strings instead of docstrings

function get_vocab(docs::Array{Union{SubString{String},String},1}, o=nothing)
    if isnothing(o)
        o = Stemmer("english")
    end

    unique(stem(o, docs))
end

function get_vocab(docs::Array{Union{SubString{String},String},1}, o=nothing)
    if isnothing(o)
        o = Stemmer("english")
    end

    res = []
    for doc in docs
        res = vcat(res, get_vocab(doc, o))
    end
    res
end

"""
get words ordered by commonality
"""
function sort_by_abundance(vecs, vocab)# vocab should be array of substring{string}
    counts = get_abundance(vecs, vocab)
    perm = sortperm(counts)
    vocab[perm]
end

function get_abundance(vecs, vocab)
    counts = Array{Float32,1}(undef, length(vocab))

    for i in 1:length(vocab)
        counts[i] = sum(vecs[i,:])
    end
    counts
end