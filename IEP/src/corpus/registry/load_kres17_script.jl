include("activate.jl")
using FileIO, Clustering
slim_doc = load("slim_doc.jld2")["slim_doc"]
function_names = load("slim_names.jld2")["function_names"]
include("cluster.jl")
include("cluster_stats.jl")
kres17 = load("kmeans/kmeans_17.jld2")["kmeans"]
doc_lexi = load("doc_lexi.jld2")["lexicon"]
include("get_slim_script.jl")
