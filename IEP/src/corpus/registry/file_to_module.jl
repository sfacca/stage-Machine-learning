
function file_to_module(file_id, cset)
    # includes are handled by :EIncludesF, which is Any -> File    
    # we need the Anys that include File file_id
    # -> it's a findall in :F, looking for Fs that are == file_id
    # -> we take the :Es at these indexes
    # -> the Any in the :Es might be files, we recurse over these
    tmp = cset[findall((x)->(x==file_id), cset[:,:F]),:E]
    for 
        
    
end