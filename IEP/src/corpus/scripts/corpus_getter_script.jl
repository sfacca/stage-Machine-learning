

include("../corpus.jl")

# load name -> url,name,version dictionary
modules_dict = load("../registry/registry.jld2")["modules_dict"]

# get names of modules from pkg_corpus.txt
names = unique([replace(string(x), r"\r"=>"") for x in split(read("../pkg_corpus.txt",String),"\n")])

#generate scrapes folder containing .jld2 files of scrape results for every module in names
save_scrapes_from_Modules(modules_dict, names)

# generate dictionary from scrapes folder
dict = get_dict("scrapes")
# save it
save("../dictionary.jld2", Dict("dictionary"=>dict))
dict = nothing

# get cset from srapes folder
CSet = files_to_cset("scrapes")
# save it
save("../CSet.jld2", Dict("CSet"=>CSet)
CSet = nothing
