include("../corpus.jl")
save_scrapes_from_Modules(
    filter((x)->(contains(x,".zip")), 
    string.(replace.(split(read("base_misto_corpus.txt", String), "\n"), r"\r"=>"")))
    )