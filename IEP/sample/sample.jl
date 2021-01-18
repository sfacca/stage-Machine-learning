function base_function(x)
    x = x + 1
    for i in 1:x
        aux_func(i)
        if iseven(i)
            aux_func2()
        else
            aux_func3()
        end
    end
    x
end

"""
this function gets called in every loop
    """
function aux_func(x)
    aux_func2()
end

"""
this function is called by aux in 1/2 loops
    is also called by aux_func
"""
function aux_func2()
    1 + 2 + 5
end

"""
this function is called in 1/2 base loops
"""
function aux_func3()
    3
end
