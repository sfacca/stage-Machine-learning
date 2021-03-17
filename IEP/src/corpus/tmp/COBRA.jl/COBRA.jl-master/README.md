![COBRA logo](https://prince.lcsb.uni.lu/img/logos/logo-COBRA.jl.png)

COBRA.jl - COnstraint-Based Reconstruction and Analysis
=======================================================

| **Documentation** | **Coverage** | **Continuous integration - [ARTENOLIS](http://opencobra.github.io/artenolis)** |
|:-----------------:|:------------:|:--------------------------:|
|[![](https://img.shields.io/badge/COBRA-docs-blue.svg?maxAge=0)](https://opencobra.github.io/COBRA.jl/stable) | [![coverage status](http://codecov.io/github/opencobra/COBRA.jl/coverage.svg?branch=master)](http://codecov.io/github/opencobra/COBRA.jl?branch=master) | [![linux](https://prince.lcsb.uni.lu/badges/linux-COBRA.jl.svg)](https://prince.lcsb.uni.lu/jenkins/job/COBRA.jl-branches-auto-linux/) [![macOS](https://prince.lcsb.uni.lu/badges/macOS-COBRA.jl.svg)](https://prince.lcsb.uni.lu/jenkins/job/COBRA.jl-branches-auto-macOS/) [![windows10](https://prince.lcsb.uni.lu/badges/windows-COBRA.jl.svg)](https://prince.lcsb.uni.lu/jenkins/job/COBRA.jl-branches-auto-windows10/) |

`COBRA.jl` is a package written in [Julia](http://julialang.org/downloads/) used to perform COBRA analyses such as Flux Balance Anlysis (FBA), Flux Variability Anlysis (FVA), or any of its associated variants such as `distributedFBA` [[1](#References-1)].

FBA and FVA rely on the solution of LP problems. The package can be used with ease when the LP problem is defined in a `.mat` file according to the format outlined in the [COBRA Toolbox](https://github.com/opencobra/cobratoolbox) [[2](#References-1)].

Installation of COBRA.jl
------------------------

> If you are new to Julia, you may find the [Beginner's Guide](http://opencobra.github.io/COBRA.jl/stable/beginnerGuide.html) interesting. A working installation of Julia is required.

At the Julia prompt, add the `COBRA` package:
```Julia
julia> Pkg.add("COBRA")
```

Use the `COBRA.jl` module by running:
```Julia
julia> using COBRA
```

`COBRA.jl` has been tested on `Julia v0.5+` on *Ubuntu Linux 14.04+*, *MacOS 10.7+*, and *Windows 7 (64-bit)*. All solvers supported by [`MathProgBase.jl`](https://github.com/JuliaOpt/MathProgBase.jl) are supported by `COBRA.jl`, but must be installed **separately**. A COBRA model saved as a `.mat` file can be read in using [`MAT.jl`](https://github.com/JuliaIO/MAT.jl). `MathProgBase.jl` and `MAT.jl` are automatically installed during the installation of the `COBRA.jl` package.

Tutorial, documentation and FAQ
-------------------------------

The [comprehensive tutorials](https://opencobra.github.io/COBRA.jl/latest/tutorials.html) are based on [interactive Jupyter notebooks](https://github.com/opencobra/COBRA.jl/tree/master/tutorials).

The `COBRA.jl` package is fully documented [here](http://opencobra.github.io/COBRA.jl). You may also display the documentation in the Julia REPL:
```Julia
julia> ? distributedFBA
```
:bulb: Should you encounter any errors or unusual behavior, please refer first to the [FAQ section](http://opencobra.github.io/COBRA.jl/stable/faq.html) or open an issue.

Testing and benchmarking
------------------------

You can test the package using:
```Julia
julia> Pkg.test("COBRA")
```
Shall no solvers be detected on your system, error messages may be thrown when testing the `COBRA.jl` package.

The code has been benchmarked against the `fastFVA` implementation [[3](#References-1)]. A test model `ecoli_core_model.mat` [[4](#References-1)] can be used to pre-compile the code and can be downloaded using
```Julia
julia> using HTTP, COBRA
julia> pkgDir = joinpath(dirname(pathof(COBRA)), "..")
julia> include(pkgDir*"/test/getTestModel.jl")
julia> getTestModel()
```

How to cite `distributedFBA.jl`?
--------------------------------

The corresponding paper can be downloaded from [here](https://academic.oup.com/bioinformatics/article-lookup/doi/10.1093/bioinformatics/btw838). You may cite `distributedFBA.jl` as follows:

> Laurent Heirendt, Ines Thiele, Ronan M. T. Fleming; DistributedFBA.jl: high-level, high-performance flux balance analysis in Julia. Bioinformatics 2017 btw838. doi: 10.1093/bioinformatics/btw838

Limitations
-----------

- At present, a COBRA model in `.mat` format is loaded using the `MAT.jl` package. A valid MATLAB license is **not** required.
- The inner layer parallelization is currently done within the solver. No log files of each spawned thread are generated.
- The current benchmarks have been performed using default optimization and compilation options of Julia and a set of solver parameters. The performance may be further improved by tuning these parameters.

References
-----------

1. [B. O. Palsson., Systems Biology: Constraint-based Reconstruction and Analysis. Cambridge University Press, NY, 2015.](http://www.cambridge.org/us/academic/subjects/life-sciences/genomics-bioinformatics-and-systems-biology/systems-biology-constraint-based-reconstruction-and-analysis?format=HB)
2. [Heirendt, L. and Arreckx, S. et al., Creation and analysis of biochemical constraint-based models: the COBRA Toolbox v3.0 (submitted), 2017, arXiv:1710.04038.](https://github.com/opencobra/cobratoolbox)
3. [Steinn, G. et al., Computationally efficient flux variability analysis. BMC Bioinformatics, 11(1):1–3, 2010.](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-11-489)
4. [Orth, J. et al., Reconstruction and use of microbial metabolic networks: the core escherichia coli metabolic model as an educational guide. EcoSal Plus, 2010.](http://gcrg.ucsd.edu/Downloads/EcoliCore)
