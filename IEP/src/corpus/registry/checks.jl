## doesnt work

function check()
    names = unique([replace(string(x), r"\r"=>"") for x in split(read("pkg_corpus.txt",String),"\n")])
    zips = []
    jld2s = []
    for (root, dirs, files) in walkdir("out")
        for file in files
            if file == "file.zip"
                push!(zips, string(split(root, "/")[end]))
            end
        end
    end

    
    for (root, dirs, files) in walkdir("scrapes")
        for file in files
            if endswith(file, ".jld2")
                push!(jld2s, splitext(file)[1])
            end
        end
    end

    not_found = []
    for name in names
        if name in zips
        else
            push!(not_found, string(name, " missing zip"))
        end
        if name in jld2s
        else
            push!(not_found, string( name, " missing jld2"))
        end
    end

    not_found
end

function check_zips()
    names = unique([replace(string(x), r"\r"=>"") for x in split(read("pkg_corpus.txt",String),"\n")])
    zips = [] 
    for (root, dirs, files) in walkdir("out")
        for file in files
            if file == "file.zip"
                push!(zips, string(split(root, "/")[end]))
            end
        end
    end

    not_found = []
    for name in names
        if name in zips
        else
            push!(not_found, name)
        end
    end

    not_found
end

function check_jld2s()
    names = unique([replace(string(x), r"\r"=>"") for x in split(read("pkg_corpus.txt",String),"\n")])    
    jld2s = []
    for (root, dirs, files) in walkdir("scrapes")
        for file in files
            if endswith(file, ".jld2")
                push!(jld2s, splitext(file)[1])
            end
        end
    end

    not_found = []
    for name in names
        if name in jld2s
        else
            push!(not_found, name)
        end
    end

    not_found
end

function check_jld2_keys(dir="scrapes")
    fails = []
    for (root, dirs, files) in walkdir("scrapes")
        for file in files
            if endswith(file, ".jld2")
                try
                    load(joinpath(root, file))[splitext(file)[1]]
                catch e
                    push!(fails, file)

                end
                
            end
        end
    end
    fails
end


