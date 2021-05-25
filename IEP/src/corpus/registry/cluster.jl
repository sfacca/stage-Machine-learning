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

function _differences(arr1, arr2)
    l = length(unique(vcat(arr1,arr2)))
    (l - length(arr1)) + (l - length(arr2))
end

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

#=
[a.b.c.d] = A
[a,d,v] = B

[a b c d v] = A°B

n° membri in B non in A = AB - A
=#