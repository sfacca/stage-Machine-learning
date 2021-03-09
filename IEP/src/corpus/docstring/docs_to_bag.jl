using Pkg
Pkg.activate(".")
#include("../corpus.jl")
include("doc_fun.jl")
include("tokenize.jl")
include("bag_of_words.jl")

using JLD2, FileIO
using TextAnalysis

include("load_docs.jl")

bags, vocab = bag_of_words(strings)

#=
crps = Corpus(strings)
update_lexicon!(crps)
m = DocumentTermMatrix(crps)
dense = dtm(m, :dense)

asd =Int(round(length(strings)/4))
crps = Corpus(strings)=#
#=
crps_1 = Corpus(strings[1:asd])
crps_2 = Corpus(strings[asd:2*asd])
crps_3 = Corpus(strings[2*asd:3*asd])
crps_4 = Corpus(strings[3*asd:end])
=#

#update_lexicon!(crps)

#"crps, crps_1, crps_2, crps_3, crps_4"
#lsa(crps_2)
#==#
#standardize!(crps, NGramDocument)
