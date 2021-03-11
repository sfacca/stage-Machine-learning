#0 prepare env
println("prep")
include("activate.jl")
using TextAnalysis, TextModels, WordTokenizers

#1 get data
println("loading data")
include("load_docs.jl")

#2 split sentences
println("split sentences")
strings = [text(x) for x in strings]
strings = [split_sentences(x) for x in strings]

#3 flatten
println("flatten")
function _flatt(elem::Union{Array{T,1}, T}) where {T}
    res = Array{T, 1}(undef, 0)
    if typeof(elem) == Array{T,1}
        for e in elem
            res = vcat(res, _flatt(e))
        end
    else
        push!(res, elem)
    end
    res
end
strings = filter((x)->(x != ""), _flatt(strings))

#4 stem
println("stem")
include("tokenize.jl")
stemmer = Stemmer("english")
strings = [StringDocument(string(x)) for x in strings]
for x in strings
    stem!(stemmer, x)
end

#crps = stem_tokenize_doc(strings)

#5 make Corpus
println("make corpus")
crps = Corpus(strings)
update_lexicon!(crps)


# pos tag corpus
println("tag pos")
include("tag_pos.jl")
tagged = _tag_pos!(crps)