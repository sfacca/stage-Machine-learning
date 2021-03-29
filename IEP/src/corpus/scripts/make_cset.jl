using FileIO, JLD2

function _trk()
    try
        files_to_cset
        global res = "empty.jl"
    catch
        global res = "../corpus.jl"
    end
    res
end
include(_trk())

# get cset from srapes folder
println("generating CSet from files in scrapes folder...")
CSet = files_to_cset("scrapes")
# save it
println("saving CSet.jld2...")
save("../CSet.jld2", Dict("CSet"=>CSet)
CSet = nothing
