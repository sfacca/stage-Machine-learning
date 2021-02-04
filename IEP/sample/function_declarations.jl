"""
function declared with function kw
"""
function basic_function(x::Int)
    "block"
end

"""
declared with ()->(block)
    """
foo = (x::Int)->("block")


"""
declared without function kw
"""
foo2(x::Bool) = "block"
#=
"""
function declared with function kw
    with declared output type
"""
function basic_functionO(x::Int)::String
    "block"
end

"""
declared with ()->(block)
with declared output
    """
fooO = (x::Int)->(x)::Int


"""
declared without function kw
    with declared output
"""
foo2O(x::Bool)::Bool = x=#