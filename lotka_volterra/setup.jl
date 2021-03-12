using Pkg
Pkg.activate(".")
Pkg.add("SymPy")
Pkg.add("Plots")
Pkg.add("GR")
Pkg.add("Latexify")
Pkg.add("Catalyst")
Pkg.add("DifferentialEquations")
Pkg.add("DPluto")
using GR
using SymPy, Plots, Latexify, Catalyst, DifferentialEquations
using Pluto