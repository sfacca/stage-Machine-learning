include("unzip.jl")

download(
    "https://github.com/sisl/algforopt-notebooks/archive/master.zip",
    "notebooks/algforopt-notebooks.zip"    
    )

download(
    "https://github.com/MarcoVela/AlgorithmsForOptimization/archive/master.zip",
    "notebooks/algorithmsforoptimization.zip"    
    )

unzip("notebooks/algforopt-notebooks.zip", "notebooks/tmp/alg_nb")
unzip("notebooks/algorithmsforoptimization.zip", "notebooks/tmp/alg")