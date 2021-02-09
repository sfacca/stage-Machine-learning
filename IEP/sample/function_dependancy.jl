function foo1(x::Int)
    foo2(x) + foo2(x)
end

function foo2(x::Int)
    if x > 1
        Float(x)
    else
        Int(x)
    end
end
