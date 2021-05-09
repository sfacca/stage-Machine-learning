include("../../IEP.jl")
include("../corpus.jl")
adicset = load("adicset.jld2")["cset"]
fileset = load("scrapes/Aqua.jld2")["Aqua"]
testfile = fileset[10]
#IEP.handle_Scrape(fileset, adicset)
IEP.handle_FileDef!(testfile, adicset)
#IEP.handle_ModuleDef!(testmodule, adicset)

# container 37