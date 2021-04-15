module IEP
    using AbstractTrees, AlgebraicPetri, AlgebraicRelations, CSTParser, Catlab, Compose, Conda, Convex, DelimitedFiles, DifferentialEquations
    using JLD2, LabelledArrays, Match, OrdinaryDiffEq, PyCall, Reexport, SCS, TikzPictures, Tokenize
    using Pkg, JLD2, FileIO
    using Catlab.CategoricalAlgebra, Catlab.WiringDiagrams, DataFrames, Match
    using Catlab.Theories, SCS, TikzPictures, Catlab.Graphics.ComposeWiringDiagrams, Catlab.Programs, Catlab.Syntax
    using Catlab.CSetDataStructures, JSON
    import Catlab.WiringDiagrams: to_hom_expr
    using Compose: draw, PGF

    #using MethodAnalysis

    using AlgebraicRelations.Presentations, AlgebraicRelations.Interface, AlgebraicRelations.Queries, AlgebraicRelations.DB
    #using Flux
    #using InteractiveUtils, Markdown
    


    include("src.jl")

    # cset
    export folder_to_CSet, join_data, add_module!, module_to_CSet
    export get_newSchema, handle_FunctionContainer!, draw_newSchema
    # dict
    export make_dict, make_dict_complete, make_head_expr_dict
    # expr
    export flattenExpr, get_all_heads, get_all_vals, find_heads, get_calls, getName
    export getName, folder_to_scrape, scrape, scrape_check
    # struct
    export NameDef, InputDef, FuncDef, FunctionContainer
    export getCode, getInputs, getName, isequal


end