function not_commented(param1::Int, param2::Int)
    x = param1 + param2
    for i in 1:x
        println(i)
        if param1 > param2
            not_commented(0, param2)
        else
            not_commented(param1, 0)
        end
    end
    param2
end

function second_function(x::Int)
    x+1
end