module Mood

    function foo1()
        println("mood foo1")
    end

    function foo2()
        println("mood foo2")
        foo1()
    end

    function foo3()
        println("mood foo3")
    end

    function foo4()
        println("mood foo4")
        foo3()
    end
end

function foo1()
    println("base foo1")
end

foo2 = Mood.foo2
foo4 = Mood.foo4
try
    foo2()
catch e
    println("error running foo2")
    println(e)
end
try
    foo4()
catch e
    println("error running foo4")
    println(e)
end
