using JLD2, FileIO
println("includeing code...")
include("../docstring/doc_fun.jl")
try
	IEP
catch e
	println("including IEP code...")
	include("../../IEP.jl")
end
include("../docstring/_dir_to_docfuns.jl")



println("getting data from ./scrapes...")
doc_funs = _dir_to_docfuns("scrapes")

println("saving file...")
save("docstring/doc_funs.jld2", Dict("doc_funs"=>doc_funs))
println("done")
