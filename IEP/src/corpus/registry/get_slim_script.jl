println("this script loads the matrix only containing non empty bags of the docstring bags of words matrix")
include("cluster.jl")
using FileIO, SparseArrays
t = FileIO.load("doc_mat.jld2")["doc_mat"]
indexes = non_empty_bags_indexes(t)
slim_doc = t[:,indexes]
t = nothing
println("slim_doc contains the matrix")
println("indexes contains the indexes of the whole mat that correspond with the reduced one")
println("meaning slim_doc[:,i] == doc_mat[:,indexes[i]]")