using JLD2, FileIO
using TextAnalysis
include("doc_fun.jl")

if !isnothing(doc_funs)
    x_tmp = doc_funs
else
    x_tmp = nothing
end

doc_funs = FileIO.load("doc_funs.jld2")["doc_funs"]
doc_funs = filter((x)->(x.doc != "error finding triplestring"),doc_funs)



strings = [StringDocument(x.doc) for x in doc_funs]
names = [StringDocument(x.fun) for x in doc_funs]
doc_funs = x_tmp

"strings contains the docstrings, names contains the function names"