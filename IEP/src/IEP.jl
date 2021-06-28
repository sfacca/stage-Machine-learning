module IEP
    using AbstractTrees, AlgebraicPetri, AlgebraicRelations, CSTParser, Catlab, Compose, Conda, Convex, DelimitedFiles, DifferentialEquations
    using LabelledArrays, Match, PyCall, Reexport, SCS, TikzPictures, Tokenize
    using Pkg, JLD2, FileIO
    using Catlab.CategoricalAlgebra, Catlab.WiringDiagrams, DataFrames, Match
    using Catlab.Theories, SCS, TikzPictures, Catlab.Graphics.ComposeWiringDiagrams, Catlab.Programs, Catlab.Syntax
    using Catlab.CSetDataStructures, JSON
    using WordTokenizers, SparseArrays
    import Catlab.WiringDiagrams: to_hom_expr
    using Compose: draw, PGF
    using TextAnalysis, TopicModels
    using Clustering, Languages, FileIO
    #using OrdinaryDiffEq

    #using MethodAnalysis

    using AlgebraicRelations.Presentations, AlgebraicRelations.Interface, AlgebraicRelations.Queries, AlgebraicRelations.DB
    #using Flux
    #using InteractiveUtils, Markdown

    # some functions have same name in different packages
    load = FileIO.load
    


    include("src.jl")

    # cset
    export folder_to_CSet, join_data, add_module!, module_to_CSet
    export get_newSchema, handle_FunctionContainer!, draw_newSchema
    # dict
    export make_dict, make_dict_complete, make_head_expr_dict
    # expr
    export flattenExpr, get_all_heads, get_all_vals, find_heads, get_calls, getName
    export getName, folder_to_scrape, scrape, scrape_check
    export read_folder
    # struct
    export NameDef, InputDef, FuncDef, FunctionContainer
    export getCode, getInputs, getName, isequal

    #
    export word_is_numeric


    export read_folder


end