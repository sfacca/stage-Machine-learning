# 1430+ packages are a lot
# split them

function split(dir, times=10)
    for i in 1:times
        mkpath(joinpath(dir, "part $i"))
    end
    to_move = []
    for (root, dirs, files) in walkdir(dir)
        to_move = vcat(to_move, [(root, x) for x in files])        
    end

    n = 1
    for tuple in to_move
        mv(joinpath(tuple[1],tuple[2]), joinpath(dir, "part $n/$(tuple[2])");force=true)
        if n==times
            n=1
        else
            n+=1
        end
    end
end