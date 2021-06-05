using FileIO, Clustering
include("cluster.jl")
include("cluster_stats.jl")
kres16 = load("kmeans/kmeans_16.jld2")["kmeans"]
doc_lexi = load("doc_lexi.jld2")["lexicon"]
include("get_slim_script.jl")
