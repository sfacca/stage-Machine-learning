using Pkg
Pkg.activate("../.")
include("../corpus.jl")
include("doc_fun.jl")

using TextAnalysis

doc_funs = load("docstring/doc_funs.jld2")["doc_funs"]


strings = [StringDocument(x.doc) for x in doc_funs]
names = [StringDocument(x.fun) for x in doc_funs]

crps = Corpus(strings)
update_lexicon!(crps)
m = DocumentTermMatrix(crps)
dense = dtm(m, :dense)

#standardize!(crps, NGramDocument)
