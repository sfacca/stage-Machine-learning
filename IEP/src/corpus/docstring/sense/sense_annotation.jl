# * https://juliahub.com/docs/CorpusLoaders/SUfHm/0.3.1/SemCor/
# * http://web.eecs.umich.edu/~mihalcea/downloads.html#semcor

using CorpusLoaders
# NB: CorpusLoaders is not compatible with AlgebraicRelations

using JLD2, FileIO
using TextAnalysis
include("../doc_fun.jl")



doc_funs = FileIO.load("../doc_funs.jld2")["doc_funs"]
doc_funs = filter((x)->(x.doc != "error finding triplestring"),doc_funs)



strings = [StringDocument(x.doc) for x in doc_funs]
names = [StringDocument(x.fun) for x in doc_funs]
doc_funs = nothing

"strings contains the docstrings, names contains the function names"

corp = CorpusLoaders.load(SemCor())
index = Dict{String, Vector{Vector{String}}}()

for sentence in flatten_levels(corp, (!lvls)(SemCor, :sent, :word))
    multisense_words = filter(x->x isa SenseAnnotatedWord,  sentence)
    context_words = word.(sentence)
    for target in multisense_words
        word_sense = sensekey(target)
        uses = get!(Vector{Vector{String}}, index, word_sense)
        push!(uses, context_words)
    end
end