using Clustering
using Distances
using StatsPlots
using FileIO

dmat = load("dmat.jld2")["dmat"]
slim_doc = load("no_nums_slim_doc.jld2")["slim_doc"]
kres22 = load("kmeans/kmeans_22.jld2")["kmeans"]
idx = findall((x)->(x==10), kres22.assignments)
slim_doc = slim_doc[:,idx]
dmat = dmat[idx, idx]
# GC
kres22 = nothing
idx = nothing

# normal ordering
hcl1 = hclust(dmat)
p = plot(
    plot(hcl1, xticks=false),
    heatmap(slim_doc[:, hcl1.order], colorbar=false, xticks=(1:size(dmat)[1], ["$i" for i in hcl1.order])),
    layout=grid(2,1, heights=[0.2,0.8])
    )
#savefig("dendro plot of cl10.svg")