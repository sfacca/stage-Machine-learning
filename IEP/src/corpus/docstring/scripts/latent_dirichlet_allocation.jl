#=
TopicModels is not registered
] add "https://github.com/slycoder/TopicModels.jl"
=#

using TopicModels

# model assumes a corpus composed of a collection of bags of words
# 
println("including code...")

include("../make_documents.jl")
include("../make_lexicon.jl")
include("../tokenize.jl")
include("load_docs.jl")
include("../bag_of_words.jl")

println("checking documents and lexicon")
if !isfile("../bags.documents")
    println("documents is missing")

    println("making bags and vocab")
    bags, vocab = bag_of_words(strings)
    println("writing bags.documents")
    write_documents(bags)
    if !isfile("../vocab.lexicon")
        println("lexicon is missing")
        println("writing  vocab.lexicon")
        write_lexicon(vocab)
    end
    bags, vocab = nothing, nothing
elseif !isfile("../vocab.lexicon")
    println("lexicon is missing")
    
    println("making bags and vocab")
    bags, vocab = bag_of_words(strings)

    println("writing  vocab.lexicon")
    write_lexicon(vocab)
    bags = nothing
    vocab = nothing
end

println("loading docs...")
documents = readDocs(open("bags.documents"))
println("loading lexicon...")
lexicon = readLexicon(open("bags.lexicon"))

