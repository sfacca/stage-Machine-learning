using WordCloud

function wordcloud_cluster(kres, docs, lexi)

    
    clusters = Array{Array{Int,1},1}(undef, maximum(kres.assignments))
    for i in 1:length(kres.assignments)
        push!(clusters[kres.assignments[i]], i)
    end
    clusters = [docs[:,x] for x in clusters]

    for cluster in clusters
        
    end
end