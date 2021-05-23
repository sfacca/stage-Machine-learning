function word_abundance(mat)
    println("generic abundance")
    sizes = size(mat) # rows, cols
    abund = Int.(zeros(sizes[1]))
    for i in 1:sizes[1] #every row is a word
        abund[i] = sum(mat[i,:])
    end
    abund
end


#=
struct SparseMatrixCSC{Tv,Ti<:Integer} <: AbstractSparseMatrixCSC{Tv,Ti}
    m::Int                  # Number of rows
    n::Int                  # Number of columns
    colptr::Vector{Ti}      # Column j is in colptr[j]:(colptr[j+1]-1)
    rowval::Vector{Ti}      # Row indices of stored values
    nzval::Vector{Tv}       # Stored values, typically nonzeros
end
=#



function word_abundance(mat::SparseMatrixCSC)
    println("abundance of sparse matrix")
    abund = Int.(zeros(mat.m))
    for i in 1:length(mat.nzval)
        abund[mat.rowval[i]] += mat.nzval[i]
    end
    abund
end
#=
function inverse_bags(mat::SparseMatrixCSC)
    inv = Array{Array{Int,1},1}(undef,mat.m)
    for i in 1:length(inv)
        inv[i] = []
    end
    for j in 1:mat.n# Column j is in colptr[j]:(colptr[j+1]-1)
        for i in mat.colptr[j]:(mat.colptr[j+1]-1)
            # add column number j to 
        end
        push!(inv[mat.rowval[i]] += mat.nzval[i]
    end
    inv
end
=#
function presence(mat::SparseMatrixCSC)
    res = copy(mat)
    for i in 1:length(res.nzval)
        res.nzval[i] = 1
    end
    res
end

