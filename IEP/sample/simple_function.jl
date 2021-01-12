"""
simple function to test parser
"""
function simple_function(param1, param2)
    var1 = 12
    var2 = 0
    expression =  (x) -> (param1 + param2*x)
    # this is a comment
    for loop in 1:var12
        var2 = var2 + expression(loop)
    end
    var2
end

"""
overload of simple function
"""
function simple_function(param1, param2, param3)
    simple_function(param1,param2+param3)
end
