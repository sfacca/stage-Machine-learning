using Catlab
using Catlab.Theories
#using Catlab.Meta # Expr0


""" Generate and parse computer programs representing morphisms.
"""
module Programs

using Reexport

#include("Expr0.jl")
#const Expr0 = Union{Symbol,Expr}

include("GenerateJuliaPrograms.jl")
include("ParseJuliaPrograms.jl")
include("RelationalPrograms.jl")

@reexport using .GenerateJuliaPrograms
@reexport using .ParseJuliaPrograms
@reexport using .RelationalPrograms

end
