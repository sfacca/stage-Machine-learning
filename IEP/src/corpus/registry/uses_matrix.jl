using SparseArrays

# we assume similar modules will use similar modules (if two modules use the same modules, those two modules probably do similar things)

# handling CUsesD obs
# C is an Any, the Any is either a file or a module
# if it's a module, we're fine, if it's a file, that file could be included in a module
function uses_matrix(cset;show_fails=false)
    modnum = length(cset[:,:modname])
    println("building a $modnum x $modnum sparse uses matrix")
    fails = []
    mat = spzeros(modnum,modnum)
    len = length(cset[:,:D])
    for i in 1:len
        c = cset[i,:C]
        d = cset[i,:D]
        tmp = _isModule(c, cset)
        if tmp == 0
            tmp = _isFile(c, cset)
            if tmp == 0
                throw("C $i is Any $c which is neither a file nor a module")
            else
                fle = tmp
                tmp = file_to_module(tmp, cset)
                if isnothing(tmp) || isempty(tmp) || tmp==0
                    println("could not find any module that includes file $fle")
                    push!(fails, fle)
                    c = 0
                else
                    tmp = unique(filter((x)->(x!=0),tmp))
                    if isnothing(tmp) || isempty(tmp) || tmp==0
                        println("could not find any module that includes file $fle")
                        push!(fails, fle)
                        c = 0
                    elseif length(tmp) > 1                
                        # more than one module include file pointed by any C
                        # we need to resolve all of them (we leave the last to the block outside the ifs)
                        c = tmp[end]
                        for acs in tmp[1:end-1]
                            mat[acs,d] += 1
                        end
                    else
                        c = tmp[1]
                    end

                end
            end
        else
            c = tmp
        end
        println("c is $c d is $d")
        if c !=0            
            mat[c,d] += 1
        end
        println("handled using $i out of $len")
    end
    show_fails ? (mat, fails) : mat
end

function _get_uses(cset)

end

function _isModule(i, cset)
    cset[i,:isModule]
end
function _isFile(i,cset)
    cset[i,:isFile]
end

function file_to_module(file_id, cset)
    # includes are handled by :EIncludesF, which is Any -> File    
    # we need the Anys that include File file_id
    # -> it's a findall in :F, looking for Fs that are == file_id
    # -> we take the :Es at these indexes
    # -> the Any in the :Es might be files, we recurse over these
    tmp = cset[findall((x)->(x==file_id), cset[:,:F]),:E]
    res = []
    if isnothing(tmp) || isempty(tmp)
        return 0
    else
        for i in 1:length(tmp)
            a = _isModule(tmp[i], cset)
            if a == 0
                a = _isFile(tmp[i], cset)
                if a == 0
                    throw("Any $(tmp[i]) is neither File nor Module")
                else
                    a = file_to_module(a, cset)
                    res = vcat(res, a)
                end
            else
                push!(res, a)
            end
        end

        res
    end   
    
end

function __flatt(asd::Array{T,1}) where {T}
    res = []
    for elem in asd
        if isarray(elem)
            res = vcat(res, __flatt(elem))
        else
            push!(res, elem)
        end
    end
    res
end



