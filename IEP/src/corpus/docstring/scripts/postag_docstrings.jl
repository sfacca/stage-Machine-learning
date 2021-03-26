#0 prepare env
println("prep")
using TextAnalysis, TextModels, WordTokenizers

#1 get data
println("loading data")
include("load_docs.jl")

#2 pos tag docstrings
println("tag pos")
include("../tag_pos.jl")
stemmer = Stemmer("english")
tagger = TextModels.PerceptronTagger(true)
tagged_docs = postag_docstring(strings, stemmer, tagger)