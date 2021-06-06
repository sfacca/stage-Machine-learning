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

function remove_rows!(mat, rows)
    for row in rows
        asd = findall((x)->(x==row), mat.rowval)
        for i in asd
            mat.nzval[i] = 0
        end
    end
    dropzeros(mat)
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

function capitalization_duplicates_finder(arr)
    lcarr = lowercase.(arr)
    sortp = sortperm(lcarr)
    lcarr = lcarr[sortp]
    res = []
    t = [sortp[1]]
    for i in 2:length(lcarr)
        if lcarr[i] == lcarr[i-1]
            push!(t, sortp[i])
        else
            push!(res, t)
            t = [sortp[i]]
        end
    end
    res
end

function capitalization_fixer(mat, arr)
    a2 = filter((x)->(length(x)>1),arr)
    for dups in a2
        for col in 1:mat.n
            # sum vals in 
            val = sum(mat[dups,col])
            mat[dups[1], col] = val
        end      
    end

    a2 = [x[2:end] for x in a2]
    a3 = 0
    for i in 1:length(a2)
        a3 = vcat(a3, a2[i])
    end
    remove_rows!(mat, a3)
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