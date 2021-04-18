using CSTParser
"""this is a docstring to mood"""
module mood
    include("IEP.jl")
    # this comment is inside mood
    """this is a docstring to foo"""
    function foo()
        #this comment is inside foo
        x = 1
    end
end

# this is a comment

"""this is a docstring without anything following"""