 using Base: String
# we want to analyze clusters of documents(bag of words)

# 1. frequency of every word (documents word appears in/ number of documents)
# 2. differences between above freqeucneis and frequencies of words acrosds the whole corpus, highlighting words with a 
#    significantly higher frequency compared to corpus frequency and words that have a significantly lower frequency   
# 3. names of elements (function names)
# 4. file/modules where elements are from
# 5. center word fractions
# 5. document closest to cluster center

struct Cluster
    docs
    indexes::Array{Int,1}
end
struct Cluster_stats
    cluster::Cluster
    freq
    diff_freq
    names
    origins
    center
    closest_to_center
end
"""
clusters_info(kres, data, names)
"""
function clusters_info(kres, data, names)
    #1 word frequency
    tmp = cluster_terms_frequency(kres, data)
    clusters = tmp[1]
    freq = tmp[2]

    #2 diff freq
    corpus_freq = word_frequency(data)
    diff_freqs = []
    for cl_freq in freq
        push!(diff_freqs, [cl_freq[i]-corpus_freq[i] for i in 1:length(corpus_freq)])
    end

    #3 names
    nms = []
    for cl in clusters
        push!(nms, names[cl.indexes])
    end

    funcsorts = []
    # costs orders for functions
    for i in 1:length(clusters)# this is a bad way to do this
        push!(funcsorts, sortperm(kres.costs[findall((x)->(x==i),kres.assignments)], rev=true))
    end

    #4 origins
    ogs = []
    for i in 1:length(nms)
        push!(ogs, [split(n,".")[1] for n in nms[i][funcsorts[i]]])
    end
    _nms = []
    for i in 1:length(nms)
        push!(_nms, [split(n,".")[end] for n in nms[i][funcsorts[i]]])
    end

    #5,6 center stuff
    centers = []
    closests_to_center = []
    for i in 1:length(clusters)
        push!(centers, kres.centers[:,i])
        push!(closests_to_center, data[:,clusters[i].indexes[argmin(kres.costs[clusters[i].indexes])]])
    end

    res = []
    for i in 1:length(ogs)
        push!(res, Cluster_stats(
            clusters[i], 
            freq[i], 
            diff_freqs[i], 
            _nms[i], 
            ogs[i],
            centers[i],
            closests_to_center[i]
            )
            )
    end


    res
end


"""sums all documents of cluster into a single document"""
function sum_clusters(kres, data)

    res = spzeros(data.m, maximum(kres.assignments))
    for i in 1:maximum(kres.assignments)
        res[:,i] = sum_docs(data[:,findall((x)->(x==i), kres.assignments)])
    end
    res
end

function sum_docs(docs)
    # every column is a doc
    res = spzeros(docs.m)
    for i in 1:docs.n
        for j in 1:length(res)
            res[j] = docs[j,i]
        end
    end
    res
end

function get_bags(docs, lexi::Array{String,1})
    res =  []
    for i in 1:docs.n 
        push!(res, get_bag(docs[:,i], lexi))
    end
    res
end

function get_bag(doc::SparseVector{Float64,Int64}, lexi::Array{String,1})
    res = []
    s = sortperm(doc.nzval, rev=true)
    nzval = doc.nzval[s]
    nzind = doc.nzind[s]
    for i in 1:length(nzval)
        res = vcat(res, repeat([lexi[nzind[i]]], Int(nzval[i])))
    end
    res
end

function _get_Clusters(kres, data)::Array{Cluster,1}
    res = Array{Cluster,1}(undef,0)
    for i in 1:maximum(kres.assignments)
        indexes = findall((x)->(x==i), kres.assignments)
        push!(res, Cluster(data[:,indexes], indexes))
    end
    res
end


function cluster_terms_frequency(kres, data)
    clusters = _get_Clusters(kres,data)
    freqs = []
    for cluster in clusters
        push!(freqs, [count((x)->(x>0) , data[i,cluster.indexes])/(length(cluster.indexes)) for i in 1:data.m])# data.m = number of rows = number of words
    end
    clusters, freqs  


end

function indexes_of_closest_to_center(kres, names=nothing)

    cluster_num = maximum(kres.assignments)

    cost_sort = sortperm(kres.costs)
    sorted_ass = kres.assignments[cost_sort]
    res = []
    for i in 1:cluster_num
        push!(res, cost_sort[findfirst((x)->(x==i), kres.assignments[cost_sort])])
    end
    if !isnothing(names)
        names[res]
    else
        res
    end
end

function word_frequency(data)
    [(length(data[i,:].nzval)/data.n) for i in 1:data.m]
end

function most_frequent(frqs)
    res = []
    for fr in frqs
        push!(res, sortperm(fr, rev=true))# indexes of words, by frequency
    end
    res
end
function most_frequent(frqs, lexi)
    freq = most_frequent(frqs)    
    [lexi[x] for x in freq]
end

function differential_frequency(kres, data, mean=false)
    #1 calc clusters freq
    println("calculating term frequencies for the clusters...")
    tmp = cluster_terms_frequency(kres, data)
    clusters = tmp[1]
    clusters_tf = tmp[2]# this is an array of arrays, the arrays contain the cluster's internal word frequencies
    res = []
    if mean #compare each frequency with the mean frequency
        println("calculating mean frequency...")
        means = [(sum(clusters_tf[:][i])/length(clusters)) for i in 1:length(clusters)]
        println("calculating differences...")
        for cluster in clusters_tf
            tmp = spzeros(length(cluster))
            for j in 1:length(cluster)
                if cluster[j] != 0
                    tmp[j] = cluster[j] - means[j]
                end
            end
            push!(res, tmp)
        end
    else
        # calc base freqs
        println("calculating corpus wide term frequencies...")
        freqs = word_frequency(data)        
        println("calculating differences...")



        for cluster in clusters_tf
            tmp = spzeros(length(cluster))
            for j in 1:length(cluster)
                if cluster[j] != 0
                    tmp[j] = cluster[j] - freqs[j]
                end
            end
            push!(res, tmp)
        end
    end
    # 
    res
end

function remove_frequent(freqs, doc_freqs, num=20)

    freq_ind = sortperm(doc_freqs, rev=true)[1:num]

    for i in 1:length(freqs)
        for ind in freq_ind
            freqs[i][ind] = 0
        end
    end    
    freqs
end

#=
struct Cluster
    docs
    indexes::Array{Int,1}
end
struct Cluster_stats
    cluster::Cluster
    freq
    diff_freq
    names
    origins
    center
    closest_to_center
end
=#

function ind_half_safe(i, rate=2)
    Int.(round(i/rate))
end

function k_index_maximum(dir)
    counts = []
    ks = []
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file, ".jld2")
                tmp = FileIO.load(joinpath(root,file))["kmeans"]
                push!(counts, tmp.counts)
                push!(ks, maximum(tmp.assignments))
            end
        end
    end

    srp = sortperm(ks)
    counts = counts[srp]
    ks = ks[srp]
    res = []

    for i in 1:length(ks)
        tmp = findmax(counts[i])
        push!(res, "k= $(ks[i]) maximum cluster population is $(tmp[1]) at cluster index $(tmp[2])")
    end
    res

end

function prepare_labels(kres)
    open("cluster_labels.txt", "w") do io
        cnts = kres.counts
        for i in 1:length(cnts)

            write(io , "# cluster $i, $(cnts[i]) items\n\n\n")

        end

    end
end

function txt_cluster_info(arr, lexi=nothing)
    if !isnothing(lexi)
        i=1
        for cl_info in arr
            open("cluster_$i.txt", "w") do io
                write(io, "############################## HIGHEST CENTER RATIO #############################\n")
                num_nn0 = count((x)->(x>0), cl_info.center)
                if num_nn0 > 30
                    num_nn0=30
                end
                center_sort = sortperm(cl_info.center, rev=true)[1:num_nn0]
                write_split(io, lexi[center_sort])
                write(io, "############################ CENTER NEAREST NEIGHBOHOR ############################\n")
                write_split(io, get_bag(cl_info.closest_to_center, lexi))
                write(io, "################################### FREQUENCY ###################################\n")
                lnn0 = length(findall((x)->(x>0), cl_info.freq))
                srp = sortperm(cl_info.freq ,rev=true)
                clp = lexi[srp]
                clp = clp[1:(lnn0 > 200 ? 200 : end)]
                write_split(io, clp)                
                write(io, "################################# DIFF FREQUENCY ################################\n")                
                write(io, "################################# more frequent ################################\n")
                ln = lnn0 >100 ? 100 : lnn0
                write_split(io, lexi[sortperm(cl_info.diff_freq, rev=true)[1:ln]])                               
                write(io, "################################# less frequent ################################\n")
                write_split(io, lexi[sortperm(cl_info.diff_freq )[1:ln]])
                write(io, "################################# FUNCTION NAMES ################################\n")
                write_split(io, sort(cl_info.names))
                write(io, "############################### FUNCTION ORIGINS ################################\n")
                write_split(io, sort(unique(cl_info.origins)))


            end
            i+=1
        end        
    else

    end
    
end

using Clustering

function nmi_folder(dir)
    kresses = []
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file, ".jld2")
                push!(kresses, FileIO.load(joinpath(root,file))["kmeans"])
            end
        end
    end
    # sorting
    kresses = kresses[sortperm([maximum(k.assignments) for k in kresses])]

    res = zeros(length(kresses)+1, length(kresses)+1)
    res[1,1] = 1
    for kres_i in 1:length(kresses)
        res[1,kres_i+1] = maximum(kresses[kres_i].assignments)        
        res[1+kres_i,1] = maximum(kresses[kres_i].assignments)
    end
    for kres_i in 1:length(kresses)
        #i = kres_i+1
        for i in 1:length(kresses)
            res[kres_i+1,i+1] = Clustering.mutualinfo(kresses[kres_i], kresses[i]; normed=true)            
        end
    end

    res
end

"""
p(word | class)
p(word | class)
p(word)"""
function frequent_and_predictive_words_method(kres, data)
    # get p(word)
    cols = data.n
    rows = data.m
    wsums = [count((x)->(x>0),data[i,:]) for i in 1:rows]
    pword = [(wsums[i] == 0 ? 0 : wsums[i]/cols) for i in 1:rows]

    res = []
    for cluster in 1:maximum(kres.assignments)
        ids = findall((x)->(x==cluster),kres.assignments)
        sums = [count((x)->(x>0),data[i,ids]) for i in 1:rows]
        frqs = [(sums[i]==0 ? 0 : sums[i]/length(ids)) for i in 1:rows]
        push!(res, [(frqs[i]==0 ? 0 : frqs[i]*(frqs[i]/pword[i])) for i in 1:rows])
    end

    res

end

function print_fapwm(arr, lexi::Array{String,1}, name::String="frequent and predictive words.md")
    res = []
    for clust in arr
        srp = sortperm(clust, rev=true)
        limit = findfirst(iszero, clust[srp])
        if !isnothing(limit)
            push!(res, lexi[srp][1:limit])
        else
            push!(res, lexi[srp])
        end
    end
    print_fapwm(res, name)
end

function print_fapwm(arr, name="frequent and predictive words.md")
    open(name, "w") do io
        write(io, "This file contains every word present in each cluster, ordered by the score given by the Frequent and Predictive words Method,\nwhich scores words based on the product of local frequency and predictiveness.\n, For more informations, see https://iarjset.com/upload/2017/july-17/IARJSET%203.pdf\n")
        for i in 1:length(arr)
            write(io, "[Cluster $i](#cluster$i)\n")
        end

        for i in 1:length(arr)
            write(io, "# Cluster$i\n\n")
            ln = length(arr[i])#>50 ? 50 : length(arr[i])
            for j in 1:ln
                write(io, arr[i][j])
                if round(j/10) == j/10
                    write(io, "\n")
                else
                    write(io, ", ")
                end
            end
            write(io, "\n\n")
        end

    end
end

function to_presence_mat(mat)
    res = copy(mat)

    for i in 1:length(res.nzval)
        res.nzval[i] = 1
    end
    res

end

function sorted_non0_frqs(frqs)
    res = []

    for arr in frqs
    end
end

function write_split(io, str, len=100)
    
    
    i=0
    for el in str
        write(io, string(el))
        i+=1
        if i >= 20
            write(io, "\n")
            i=0
        else
            write(io, ", ")
        end
    end
    write(io, "\n")
end


function test_ws()
    open("tset.jl", "w") do io 
        write_split(io, rand(100))
    end
end

function cluster_distributions(dir)
    res = []
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file, ".jld2")
                push!(res, FileIO.load(joinpath(root,file))["kmeans"].counts)
            end
        end
    end
    res
end 


function intr_dist(arr)
    res = []
    for ar in arr
        mn = sum(ar)/length(ar)
        push!(res, [abs(x-mn) for x in ar])
    end
    res
end