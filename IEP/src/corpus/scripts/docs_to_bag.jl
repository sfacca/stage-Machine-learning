#include("../corpus.jl")
println("including code...")

include("../tokenize.jl")
include("../bag_of_words.jl")

println("loading docs...")

include("load_docs.jl")

println("running code...")
bags, vocab = bag_of_words(strings)

println("finished")
println(":bags contains the bags, :vocab is the vocabolary")
println("every column of bags is the vector of a document")
println("every element of vocab is a word")