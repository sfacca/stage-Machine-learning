using FileIO
function get_scrapes(dir)
    res = []
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file,  ".jld2")
                res = vcat(res, load(joinpath(root,file))[splitext(file)[1]])
            end
        end
    end
    res
end