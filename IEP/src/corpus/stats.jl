function get_func_number(dir)
    length(names_in_dir(dir))
end

function stats_of_cset(cset)
    unique_names = length(cset[:,:func]) # number of unique function name calls
    symbols = length(cset[:, :symbol])
    variables = length(cset[:, :variable])
    langs = length(cset[:,:language])
    math_expr =  length(cset[:,:math_expression])
    concepts =  length(cset[:,:concept])
    units =  length(cset[:,:unit])
    code_symbols = length(cset[:,:code_symbol])
    entities = length(cset[:,:entity])
    str = "CSet contains: \n
    $unique_names unique function names \n
    $symbols symbols \n
    $variables variables \n
    $langs languages \n
    $math_expr math expressions \n
    $concepts concepts \n
    $units units \n
    $code_symbols code symbols \n
    $entities entities"

    open("stats.txt", "w") do f
        write(f, str)
    end
    str
end