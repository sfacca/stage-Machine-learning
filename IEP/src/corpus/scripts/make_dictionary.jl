using FileIO, JLD2

try
    get_dict
catch e
    println("loading code...")
    include("../corpus.jl")
end

# generate dictionary from scrapes folder
prinltn("building dictionary...")
dict = get_dict("scrapes")
# save it
println("saving dictionary...")
save("../dictionary.jld2", Dict("dictionary"=>dict))
dict = nothing