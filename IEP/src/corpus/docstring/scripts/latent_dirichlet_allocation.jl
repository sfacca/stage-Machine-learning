#=
TopicModels is not registered
] add "https://github.com/slycoder/TopicModels.jl"
=#

using TopicModels

println("including code...")
include("../make_documents.jl")
include("../make_lexicon.jl")
include("../tokenize.jl")
include("load_docs.jl")
include("../bag_of_words.jl")

println("checking documents and lexicon")
if !isfile("./bags.documents")
    println("documents is missing")

    println("making bags and vocab")
    bags, vocab = bag_of_words(strings)
    println("writing bags.documents")
    write_documents(bags)
    if !isfile("./vocab.lexicon")
        println("lexicon is missing")
        println("writing  vocab.lexicon")
        write_lexicon(vocab)
    end
    bags, vocab = nothing, nothing
elseif !isfile("./vocab.lexicon")
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
lexicon = readLexicon(open("vocab.lexicon"))

println("making documents/lexicon corpus...")
crps = TopicModels.Corpus(documents, lexicon)

topicnum = 10
println("making model with $topicnum topics...")
mdl = TopicModels.Model(fill(0.1, topicnum), fill(0.1, length(lexicon)), crps)
println("making state...")
st = TopicModels.State(mdl, crps)

iterations = 30
println("training model with $iterations iterations...")
TopicModels.trainModel(mdl, st, iterations)

numwords = 10
println("check $numwords most prevalent words for each topic...")
topWords = TopicModels.topTopicWords(mdl, st, numwords)
