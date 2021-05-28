using ParallelKMeans

# get k,d where k is number o clusters, d is mean distance of elements to their cluster's center
function clusters_mean_distance(kres)
    # distances are in .costs
    # centers are in .centers
    # assignments are in .assignments
    # k is maximum assignments
    ass = sort(kres.costs)
    (ass[round(length(ass)/2)], nclusters(kres))
end
#X = FileIO.load("doc_mat.jld2")["doc_mat"]

# Multi-threaded Implementation of Lloyd's Algorithm by default
#c = [ParallelKMeans.kmeans(X, i; tol=1e-6, max_iters=300, verbose=true) for i = 2:10]
"""
calculates k-means clusterings with ks ranginge from range[1] to range[2]
mat is supposed to be a sparse matrix where each column represents a data point
default range is 1:number of columns/50
save_parts = true will have the function save each k means result as a jld2 called [name][k].jld2
set step > 1 to skip values in the range, eg step = 2 will have the function calculate 1 every two k values in the range
"""
function kmeans_range(mat, range=nothing, verbose=false, save_parts=false, name="kmeans_", step=1)
    if isnothing(range)
        range = 2:round(length(mat[:,1]/50))
    end
    if save_parts
        mkpath("kmeans")
    end
    res = []
    c_step=1
    for i in range
        if step <= c_step
            push!(res, ParallelKMeans.kmeans(mat, i; tol=1e-6, max_iters=300, verbose=verbose))
            if save_parts && !(isfile("kmeans/$name$i.jld2"))
                FileIO.save("kmeans/$name$i.jld2", Dict("kmeans"=>res[end]))
                println("saved k means $i to $name$i.jld2")
            end
            if verbose
                println("done k means $i in $range")
            end
            c_step = 1
        else
            println("skipping $i")
            c_step +=1
        end
    end
    res
end

function clusters_distortion(kres)
    #1 square distances
    #2 mean
    sum([x^2 for x in kres.costs])/length(kres.costs)
end

function clusters_silhouette(kres)
end

# distortion: mean sum of squared distances to centers
# silhouette: mean ratio of intra-cluster and nearest-cluster distance
# calinski_harabasz: ratio of within to between cluster dispersion