include("load_docs.jl")
include("../tokenize.jl")
include("../bag_of_words.jl")

using JLD2, FileIO
using TextAnalysis



crps = Corpus(strings)
update_lexicon!(crps)

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