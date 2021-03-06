
#=
generic stat of bag of words structured data
=#

function word_abundance(data::SparseMatrixCSC)
    wa = zeros(data.m)
    srt = sort(data.rowval)
    strt = 1
    for i in 1:length(srt)
        if srt[i] != srt[strt]
            wa[srt[strt]] = i-strt
            strt = i
        end
    end
    Int.(wa)
end


function word_abundance(mat)
    println("generic abundance")
    sizes = size(mat) # rows, cols
    abund = Int.(zeros(sizes[1]))
    for i in 1:sizes[1] #every row is a word
        abund[i] = sum(mat[i,:])
    end
    abund
end

function presence(mat::SparseMatrixCSC)
    res = copy(mat)
    for i in 1:length(res.nzval)
        res.nzval[i] = 1
    end
    res
end

function word_abundance_presence(mat::SparseMatrixCSC, lexi::Array{String,1})    
    word_abundance(presence(mat))
end