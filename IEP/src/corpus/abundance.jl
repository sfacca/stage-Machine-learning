function abund(arr::Array{T,1}) where {T}
    vocab = unique(arr)
    counts = zeros(Int, length(vocab))
    for word in arr
        counts[findfirst((x)->(x==word), vocab)]
    end
    vocab[sortperm(counts)]
end