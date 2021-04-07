using StringAnalysis, JLD2, FileIO#, TextAnalysis

#load = WordTokenizers.load

include("../doc_fun.jl")

println("loading docs")
df = FileIO.load("doc_funs.jld2")["doc_funs"]
docstrings = [x.doc for x in df]

stringdocs = [StringAnalysis.StringDocument(x) for x in docstrings]
ngramdocs = [StringAnalysis.NGramDocument(x) for x in docstrings]
tokendocs = [StringAnalysis.TokenDocument(x) for x in docstrings]

#crps = StringAnalysis.Corpus(ngramdocs)

using Languages
println("setting language")
for x in stringdocs
    StringAnalysis.language!(x, Languages.English());
    StringAnalysis.prepare!(x, StringAnalysis.strip_punctuation|StringAnalysis.strip_articles|StringAnalysis.strip_prepositions|StringAnalysis.strip_whitespace);
end

println("building corpus...")
crps = StringAnalysis.Corpus(stringdocs)

StringAnalysis.update_lexicon!(crps)

StringAnalysis.update_inverse_index!(crps)


M = StringAnalysis.DocumentTermMatrix{Float32}(crps, collect(keys(crps.lexicon)));

lm = StringAnalysis.LSAModel(M, k=4, stats=:tfidf)

V = StringAnalysis.embed_document(lm, crps)

function x_save()
    save_lsa_model(lm, "lsa model.txt")
    save("embed.jld2", Dict("embed"=>V))
end

#=
qry = stringdocs[42]

idxs, corrs = cosine(lm, crps, qry)

for (idx, corr) in zip(idxs, corrs)
    println("$corr -> \"$(crps[idx].text)\"");
end
=#


