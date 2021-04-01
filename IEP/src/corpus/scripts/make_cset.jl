using FileIO, JLD2

try
    files_to_cset
catch
    include("../corpus.jl")
end

# get cset from srapes folder
println("generating CSet from files in scrapes folder...")
CSet = files_to_cset("scrapes")
# save it
println("saving CSet.jld2...")
save("../CSet.jld2", Dict("CSet"=>CSet)
CSet = nothing
