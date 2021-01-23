function base_function(x::Int)
    x = x + 1
    c::Float32 = 1.2
    for i in 1:x
        aux_func(i)
        if iseven(i)
            aux_func2(x,x)
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
function aux_func2(x,y::Int)
    x + y + 5
end

"""
this function is called in 1/2 base loops
"""
function aux_func3()
    3
end

"""
other type of function definition in julia
"""
foo = (x)->(2x)

"""
this is not a function
    """
    var_x = 3.14

    """
    abstract struct
        """
        abstract type Abstroo end

"""
sample struct
    """
    struct stroo :< Abstroo
        a::Int
        b::Float64
    end

