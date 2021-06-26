include("src/file.jl")

using AlgebraicJulia, Catlab

"""
This is the following module's docstring
"""
module MyPkg

    include("src/file2.jl")    
    using SparseArrays, Plots

    """
    This is the following function's docstring
    """
    function foo(x)
        x=x+1
    end

    module submod
        function foo2()
            1+1
        end
    end

end