#=
what we know:
    * called function name <- cset
    * number of inputs on call <- expr
    * scope of call:
        * file containing call <- struct
        * usings of module containing call <- cset
        * file includes <- struct

what we want to know:
    * dynamic dispatch

using cset, call name, code_block id
1. get module A defining code_block
2. find every code_block of function of call name defined by module  A
3. for every module B used by module A
    3.1 find every code_block of function of call name defined by module B
4. 
=#
#=
function _call_lookup(call, code_block_id, cset)

    #1 get module defining code block
    module_id = cset[code_block_id, :DefinedIn]
    if module_id == 0
        return 0 #give up
        # maybe put files in cset?
    end

    #2 get ids of modules used by module_id module
    used_modules = cset[findall((x)->(x == module_id), cset[:,:C]), :D]# <------------------ n
    push!(used_modules, module_id)

    #3 get ids of all blocks defined on scope modules
    block_ids = findall((x)->(x in used_modules), cset[:,:DefinedIn])

    #4 find names == call
    block_ids[findall((x)->(x == call),cset[cset[block_ids,:ImplementsFunc], :func])]
end=#

function call_lookup(call, code_block_id, data)
    scope = get_scope(data[code_block_id, :DefinedIn], data)

    res = findfirst((x)->(x[2] == call),scope)
    if isnothing(res)
        res = 0
    else
        res = scope[res][1]
    end
    res
end
