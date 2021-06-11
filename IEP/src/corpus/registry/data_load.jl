using FileIO
slim_doc = load("no_nums_slim_doc.jld2")["slim_doc"]
doc_lexi = load("doc_lexi.jld2")["lexicon"]
function_names = load("slim_names.jld2")["function_names"]