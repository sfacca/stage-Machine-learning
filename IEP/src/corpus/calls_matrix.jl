using SparseArrays

# we assume similar functions will have similar calls

#=
we're building a nxm matrix A of m=Functions, n=Code_block
a_ij = 1 if code block i calls function j
type = "function" or "Function" means we will actuall make a mxm matrix, where m=Functions and a_ij = 1 if and only if function i calls function j

type = "advanced" means we will make a nxn matrix where n=code_blocks, a_ij = 1 means code block i calls code block j, we determine that from the code block's defining module's scope    
=#
function calls_matrix(cset; type = "blocks", verbose=false)
    if type in ["blocks", "Blocks", "Code_blocks", "block", "Block", "Code_block", "code_block", "code_blocks"]
        _simple_calls_matrix(cset, verbose)
    elseif type in ["function", "functions", "Function", "Functions"]
        _func_calls_matrix(cset, verbose)
    elseif type in ["advanced", "Advanced"]
        _adv_calls_matrix(cset, verbose)
    end
end
function _adv_calls_matrix(cset)
    calls = _resolve_call(cset)
    num_blocs = length(cset[:,:block])
    mat = spzeros(num_blocs, num_blocs)



end
# cset[i,:ImplementsFunc] contains func id of block
function _func_calls_matrix(cset, verbose)
    calls = _resolve_call(cset)
    calls = [(cset[x[1], :ImplementsFunc],x[2]) for x in calls]
    num_funs = length(cset[:,:func])
    mat = spzeros(num_funs, num_funs)
    len = length(calls)
    i = 0
    if verbose
        for call in calls
            # call[1] calls call[2]
            mat[call[1], call[2]] += 1
            i+=1
            println("handled call $i of $len")    
        end
    else
        for call in calls
            # call[1] calls call[2]
            mat[call[1], call[2]] += 1 
        end
    end
    mat
end
# functions are in cset[:,:Function], the names are in cset[:,:func]
# code blocks are in cset[:, :Code_block]
# calls are defined by XCalledByY in cset[:, :XCalledByY]
function _simple_calls_matrix(cset, verbose)
    calls = _resolve_call(cset)
    num_blocs = length(cset[:,:block])
    num_funs = length(cset[:,:func])
    mat = spzeros(num_blocs, num_funs)
    len = length(calls)
    i = 0
    if verbose
        for call in calls
            # call[1] calls call[2]
            mat[call[1], call[2]] = 1
            i+=1
            println("handled call $i of $len")    
        end
    else
        for call in calls
            # call[1] calls call[2]
            mat[call[1], call[2]] = 1
        end
    end
    mat
end
# to resolve call i, we find the function(called) id in [i, :X], the block(callee) id in [i, :Y]
function _resolve_call(call_id::Int, cset)# 1 calls 2
    cset[call_id,:Y] , cset[call_id,:X]
end
function _resolve_call(calls::Array{Int}, cset)
    [_resolve_call(x, cset) for x in calls]
end
function _resolve_call(cset)
    _resolve_call(collect(1:length(cset[:,:X])), cset)
end
