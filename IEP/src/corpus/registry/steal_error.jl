function steal_error(func)
    res = nothing
    try
        func()
    catch e
        res = e
    end
    res
end

function attry(x, y=1,z=2)
    x+y+z
end