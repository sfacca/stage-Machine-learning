using CSTParser

include("is_include.jl")
include("another_include.jl")
include("subfolder/more.jl")

module mood
    include("IEP.jl")

    function foo()
        x = 1
    end
end