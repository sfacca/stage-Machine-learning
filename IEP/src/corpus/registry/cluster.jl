using SparseArrays

function revert_assignments(arr)
    res = Array{Array{Int,1},1}(undef, maximum(arr))
    for i in 1:length(res)
        res[i] = []
    end

    for i in 1:length(arr)
        push!(res[arr[i]], i)
    end
    res
end

function find_closest(arr, arr_of_arr)
    distances = Array{Int,1}(undef, length(arr_of_arr))
    for i in 1:length(arr_of_arr)
        distances[i] =  _differences(arr, arr_of_arr[i]) - _similarities(arr, arr_of_arr[i])
    end
    sort_perm = sortperm(distances)
    sort_perm[1], distances[sort_perm[1]]
end

# returns number of elements in arr1 that are not in arr2 + number of elements that are in arr2 but not in arr1
function _differences(arr1, arr2)
    l = length(unique(vcat(arr1,arr2)))
    (l - length(arr1)) + (l - length(arr2))
end

#returns number of elements in arr1 that are in arr2
function _similarities(arr1, arr2)
    s = 0
    for e in arr1
        if !isnothing(findfirst((x)->(x==e), arr2))
            s+=1
        end
    end
    s
end
function find_all_close(arr_of_arr1, arr_of_arr2)
    res = []
    for arr in arr_of_arr1
        push!(res, find_closest(arr, arr_of_arr2))
    end
    res
end

function non_empty_bags_indexes(mat)
    filter((x)->(!isempty(mat[:,x].nzval)), [i for i in 1:size(mat)[2]])
end

function get_clusters(kres, names)
    order = sortperm(kres.assignments)
    o_names = names[order]
    o_clusters = kres.assignments[order]
    res = []
    for i in 1:maximum(o_clusters)
        push!(res, [])
    end
    for i in 1:length(o_names)
        push!(res[o_clusters[i]], o_names[i])
    end 
    res
end

function txt_cluster(arr, name="clusters", presort=true)
    open("$name.txt", "w") do io 
        for i in 1:length(arr)
            write(io, "####################################### CLUSTER $i #######################################\n")
            str = "# "
            if presort
                a = sort(arr[i])
            else
                a = arr[i]
            end
            for j in 1:length(a)
                if length(str) + length(a[j]) >= 89
                    
                    write(io, str)
                    if length(str)<79
                        write(io, repeat(" ", 89-length(str)))
                    end
                    write(io, "#\n")
                    str = "# "
                else
                    str*=" ; "
                end
                str*=a[j]                
            end
            write(io, str)
            if length(str)<79
                write(io, repeat(" ", 89-length(str)))
            end
            write(io, "#\n")
            write(io, "##########################################################################################\n")
        end
    end
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

function get_clusters(kres, data)
    res = Array{Cluster,1}(undef,0)
    for i in 1:maximum(kres.assignments)
        indexes = findall((x)->(x==i), kres.assignments)
        push!(res, Cluster(data[:,indexes], indexes))
    end
    res
end

struct Cluster
    docs
    indexes::Array{Int,1}
end


function cluster_terms_frequency(kres, data)
    clusters = get_clusters(kres,data)
    freqs = []
    for cluster in clusters
        push!(freqs, [count((x)->(x>0) , data[i,cluster.indexes])/(length(cluster.indexes)) for i in 1:data.m])# data.m = number of rows = number of words
    end
    clusters, freqs  


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



function txt_freqs(arr, lexi, name="freqs", num::Int=0)

    open("$name.txt", "w") do io 
        for i in 1:length(arr)
            write(io, "####################################### CLUSTER $i #######################################\n")
            str = "# "



            sort_p = sortperm(arr[i].nzval, rev=true)
            a = lexi[arr[i].nzind]
            a = a[sort_p]
            if num > 0 && num < length(a)
                a = a[1:num]
            end

            for j in 1:length(a)
                if length(str) + length(a[j]) >= 89
                    
                    write(io, str)
                    if length(str)<79
                        write(io, repeat(" ", 89-length(str)))
                    end
                    write(io, "#\n")
                    str = "# "
                else
                    str*=" ; "
                end
                str*=a[j]                
            end
            write(io, str)
            if length(str)<79
                write(io, repeat(" ", 89-length(str)))
            end
            write(io, "#\n")
            write(io, "##########################################################################################\n")
        end
    end

end
#=
function cluster_terms_frequency(clusters::Array{Cluster,1})
    freqs = []
    for cluster in clusters
        push!(freqs, [count((x)->(x>0) , data[i,cluster.indexes])/(length(indexes)) for i in 1:data.m])# data.m = number of rows = number of words
    end
    clusters, freqs  


end=#


#=
[a.b.c.d] = A
[a,d,v] = B

[a b c d v] = A°B

n° membri in B non in A = AB - A
=#