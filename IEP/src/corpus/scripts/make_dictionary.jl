using FileIO, JLD2

function _trk()
    try
        get_dict
        global res = "empty.jl"
    catch
        global res = "../corpus.jl"
    end
    res
end
include(_trk())

# generate dictionary from scrapes folder
prinltn("building dictionary...")
dict = get_dict("scrapes")
# save it
println("saving dictionary...")
save("../dictionary.jld2", Dict("dictionary"=>dict))
dict = nothing