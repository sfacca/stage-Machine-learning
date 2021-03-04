using Pkg
Pkg.activate(".")
#include("../corpus.jl")
include("doc_fun.jl")

using TextAnalysis

doc_funs = load("doc_funs.jld2")["doc_funs"]
doc_funs = filter((x)->(x.doc != "error finding triplestring"),doc_funs)

open("docstrings.txt", "w") do io
    for df in doc_funs
        write(io, "name: $(df.fun) \n $(df.doc)")
    end
end

strings = [StringDocument(x.doc) for x in doc_funs]
names = [StringDocument(x.fun) for x in doc_funs]

crps = Corpus(strings)
update_lexicon!(crps)
m = DocumentTermMatrix(crps)
dense = dtm(m, :dense)

asd =Int(round(length(strings)/4))
crps_1 = Corpus(strings[1:asd])
crps_2 = Corpus(strings[asd:2*asd])
crps_3 = Corpus(strings[2*asd:3*asd])
crps_4 = Corpus(strings[3*asd:end])
lsa(crps_2)
#==#
#standardize!(crps, NGramDocument)
