function steal_error(func)
    res = nothing
    try
        func()
    catch e
        res = e
    end
    res
end