module IEP
    using Pkg, Catlab, JLD2, FileIO, CSTParser
    using DelimitedFiles
    using Catlab, Catlab.CategoricalAlgebra, Catlab.WiringDiagrams, DataFrames, Match
    using Flux
    #using InteractiveUtils, Markdown


    include("src.jl")

    # cset
    export folder_to_CSet, join_data, add_module!, module_to_CSet
    # dict
    export make_dict, make_dict_complete, make_head_expr_dict
    # expr
    export flattenExpr, get_all_heads, get_all_vals, find_heads, get_calls, getName
    export getName, folder_to_scrape, scrape, scrape_check
    # struct
    export NameDef, InputDef, FuncDef, FunctionContainer
    export getCode, getInputs, getName, isequal


end