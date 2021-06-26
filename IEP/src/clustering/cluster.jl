#=
this file contains generic functions to handle and modify bag of words datasets to run clustering
=#

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

function find_words(lexi, sw)
    res = []
    lexi = lowercase.(lexi)
    for word in sw
        for i in 1:length(lexi)
            if lexi[i] == word
                push!(res, i)
            end
        end
    end
    res
end

function sum_check(fll, slim)
    fllsums = zeros(fll.n)
    slimsums = zeros(fll.n)

    for col in 1:fll.n
        fllsums[col] = sum(fll[:,col])
        slimsums[col] = sum(slim[:,col])
    end

    res = true
    i=1
    while res && i<length(fllsums)
        if fllsums[i] != slimsums[i]
            res = false

        end
    end
    res
end

"""sums every column"""
function sumwords(mat)    
    res = zeros(mat.n)
    for colptr_i in 1:mat.n
        res[colptr_i] = sum(mat.nzval[mat.colptr[colptr_i]:mat.colptr[colptr_i+1]])
    end
    res
end

function capitalization_fixer_sp(mat, arr)
    a2 = filter((x)->(length(x)>1),arr)
    rowvals = [findall((x)->(x in tple), mat.rowval) for tple in a2]
    colptr_len = length(mat.colptr)
    for tple_i in 1:length(rowvals)
        # should be sorted
        summ = 0
        col_i = 1
        for tple_elem in rowvals[tple_i]
            while mat.colptr[col_i] < rowvals[tple_i]
                col_i += 1
                if col_i > colptr_len
                    break
                end
            end
        end
    end

end

function cluster_clusters(kres, data, k::Int)
    cls = get_cluster_mats(kres, data)
    sqr_clusters = []
    c = 1
    for sub_data in cls
        if sub_data.n > k
            println("calculating clustering of cluster $c (indexes $cluster) with k = $k...")
            push!(sqr_clusters, Clustering.kmeans(sub_data, k))
        else
            println("cluster $c has $(length(cluster)) elements, cant generate $k clusters...")
            push!(sqr_clusters, nothing)
        end
    end
    indexing, sqr_clusters
end


function get_cluster_mats(kres, data)
    cls = [[] for _ in 1:maximum(kres.assignments)]
    for i in 1:length(kres.assignments)
        push!(cls[kres.assignments[i]], i)
    end
    [data[:,x] for x in cls]
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

function word_is_numeric(word)
    return tryparse(Float64, word) !== nothing
end


function __savearr(arr, name)
    open(name, "w") do io
        for el in arr
            write(io, el)
            write(io, "\n")
        end
    end
end

function find_mods(ids, rngs, mods)
    res = []
    for id in ids
        push!(res, mods[findfirst((x)->(id in x),rngs)])
    end
    res
end

function find_mods(idx, dict)
    rngs = [value for (key, value) in dict]
    mds = [key for (key, value) in dict]
    find_mods(idx, rngs, mds)
end

                