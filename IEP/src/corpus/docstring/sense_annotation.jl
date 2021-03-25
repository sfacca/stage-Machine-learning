# * https://juliahub.com/docs/CorpusLoaders/SUfHm/0.3.1/SemCor/

using CorpusLoaders
# NB: CorpusLoaders is not compatible with AlgebraicRelations

include("../load_docs.jl")

corp = load(SemCor())
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