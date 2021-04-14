# sets up ConceptNet word embedding
using ConceptnetNumberbatch, Languages

include("../make_lexicon.jl")
include("../load_embedded_lexicon.jl")


file_conceptnet = "./_conceptnet_/conceptnet.h5"
if !isfile(file_conceptnet)
    println("conceptnet file $file_conceptnet is missing, downloading...")
    file_conceptnet = download_embeddings(url=CONCEPTNET_HDF5_LINK, localfile=file_conceptnet)
    println("downloaded conceptnet at $file_conceptnet")
end
println("loading conceptnet...")
conceptnet = load_embeddings(file_conceptnet, languages=:en)

embedded_lexicon_path = "./embedded_vocab.lexicon"
try
    TopicModels
    println("TopicModels is loaded into workspace")
    if isfile(embedded_lexicon_path)
        println("embedded lexicon found, loading...")
        global lexicon = load_embedded_lexicon(embedded_lexicon_path)
    elseif isfile("./vocab.lexicon")
        println("embedded lexicon not found")
        println("converting lexicon into word embeddings...")
        global lexicon = conceptnet[readLexicon(open("vocab.lexicon"))]
    else
        println("embedded lexicon not found")
        println("vocab.lexicon not found")
        println("run latent_dirichlet_allocation.jl to create lexicon")
    end
catch e
    println(e)
end
