using JLD2, FileIO, TickTock

function download_module(dict, name::String)
    println("Module $name")
	mkpath("out/$name")
	println("downloading...")
    if isfile("out/$name/file.zip")
        throw("out/$name/file.zip already exists")
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
function download_module(dict, names::Array{String,1}; force=false)
    len = length(names)
    i = 0
    fails = []
    count = 0
    tick()
    kys = [x[1] for x in dict]
    for name in names        
        try
            if contains(name, ".zip")
                download_module(name)
            else
                if isfile("out/$name/file.zip") && !force
                    println("out/$name/file.zip already exists")
                    count -= 1
                elseif name in kys
                    if isfile("out/$name/file.zip") && force
                        rm("out/$name/file.zip")
                    end
                    download_module(dict, name)
                else
                    println("$name not in dictionary")
                    push!(fails, name)
                    count -= 1
                end
            end
            i += 1
            println("module $name downloaded, $(len-i) modules left. $count")
        catch e
            println(e)
            push!(fails, name)
        end
        count += 1
        if count >= 60 # we reached maximum
            # check if timer is under one hour
            tme = peektimer()
            tock()
            if tme < 3600 
                println("about to exceed Github rate limit")
                println("sleeping for $(3600-tme) seconds")
                # if it is, wait remaining timer                
                sleep(3600-tme)
                println("finished waiting, resuming module downloads")
            end
            # reset timer
            tick()
            
            count = 0
        end
    end
    println("$(len - i) modules failed to download")
    fails
end

if !isfile("./registry.jld2")   
    println("registry not found, making registry.")
    include("make_registry.jl")
end
include("../write_to_txt.jl")

function download_from_file(filename; rate::Int=1, start::Int=1, number::Int=0)
        # load name -> url,name,version dictionary
    println("loading registry...")
    modules_dict = load("./registry.jld2")["registry"]

    # get names of modules from pkg_corpus.txt
    names = unique([replace(string(x), r"\r"=>"") for x in split(read(filename,String),"\n")])
    if (start+number) >= length(names)
        throw("invalid start/number values, out of bounds")
    end
    #generate scrapes folder containing .jld2 files of scrape results for every module in names
    println("downloading...")
    if number > 0 && (start+number<length(names))
        fails = download_module(modules_dict, names[start:(start+number)])
    else
        fails = download_module(modules_dict, names[start:Int(round(length(names)/rate))])
    end
    
    write_to_txt("fails", fails)

    fails
end

function download_from_name(name::String; force=false)
    println("loading registry...")
    modules_dict = load("./registry.jld2")["registry"]
    if isfile("out/$name/file.zip") && force
        rm("out/$name/file.zip")
    end
    try
        download_module(modules_dict, name)
    catch e
        e
    end
end
function download_from_name(names::Array{String,1}; force=false)
    println("loading registry...")
    modules_dict = load("./registry.jld2")["registry"]
    fails = []
    for name in names
        if isfile("out/$name/file.zip") && force
            rm("out/$name/file.zip")
        end
        try
            download_module(modules_dict, name)
        catch e
            push!(fails, (name, e))
        end
    end
    fails
end

"For unauthenticated requests, the rate limit allows for up to 60 requests per hour. "
