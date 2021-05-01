using JLD2, FileIO

function download_module(dict, name::String)
    println("Module $name")
	mkpath("out/$name")
	println("downloading...")
    if isfile("out/$name/file.zip")
        println("out/$name/file.zip already exists")
    else
	    download(dict[name], "out/$name/file.zip")
    end
end
function download_module(url::String)
    name = string(split(url,"/")[end-2])
    println("Module $name")
	mkpath("out/$name")
	println("downloading...")
    if isfile("out/$name/file.zip")
        throw("out/$name/file.zip already exists")
    else
	    download(url, "out/$name/file.zip")
    end
end
function download_module(dict, names::Array{String,1})
    len = length(names)
    i = 0
    fails = []
    for name in names
        try
            if contains(name, ".zip")
                download_module(name)
            else
                download_module(dict, name)
            end
            i += 1
            println("module $name downloaded, $(len-i) modules left")
        catch e
            println(e)
            push!(fails, name)
        end
    end
    println("$(len - i) modules failed to download")
    fails
end

if !isfile("./registry.jld2")   
    println("registry not found, making registry.")
    include("make_registry.jl")
end
# load name -> url,name,version dictionary
println("loading registry...")
modules_dict = load("./registry.jld2")["registry"]

# get names of modules from pkg_corpus.txt
names = unique([replace(string(x), r"\r"=>"") for x in split(read("pkg_corpus.txt",String),"\n")])

#generate scrapes folder containing .jld2 files of scrape results for every module in names
println("generating scrapes...")
fails = download_module(modules_dict, names[1:Int(round(length(names)/4))])

include("../write_to_txt.jl")
write_to_txt("fails", vcat(["---- FAILED TO DOWNLOAD MODULES ----"], fails)

fails
