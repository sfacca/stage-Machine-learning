function remove_empty_rows(data)
    data[sort(unique(data.rowval)),:]
end

function word_weight(data)
    abu = word_abundance(data)
    srp = sortperm(data.rowval)
    nzv = data.nzval[srp]
    srt = data.rowval[srp]
    wa = zeros(data.m)
    srt = sort(data.rowval)
    strt = 1
    for i in 1:length(srt)
        if srt[i] != srt[strt]
            wa[srt[strt]] = sum(nzv[strt:(i-1)])/abu[srt[strt]]
            strt = i
        end
    end
    wa
end

function row_vals(data)
    srp = sortperm(data.rowval)
    nzv = data.nzval[srp]
    srt = data.rowval[srp]
    wa = []
    for i in 1:data.m
        push!(wa, [])
    end
    srt = sort(data.rowval)
    for i in 1:length(srt)
        push!(wa[srt[i]], nzv[i])            
    end
    wa
end


function capitalization_map(lexicon)
    
    lc_lexi = unique(lowercase.(lexicon))

    maps = [Array{Int,1}(undef,0) for _ in lc_lexi]

    for i in 1:length(lexicon)
        lc = lowercase(lexicon[i])
        push!(maps[findfirst((x)->(x==lc), lc_lexi)], i)
    end

    lc_lexi, maps   
end


function remove_rows!(mat, rows)
    for row in rows
        println("removing row $row")
        asd = findall((x)->(x==row), mat.rowval)
        for i in asd
            mat.nzval[i] = 0
        end
    end
    dropzeros(mat)
end

function capitalization_duplicates_finder(arr)
    lcarr = lowercase.(arr)
    sortp = sortperm(lcarr)
    lcarr = lcarr[sortp]
    res = []
    t = [sortp[1]]
    for i in 2:length(lcarr)
        if lcarr[i] == lcarr[i-1]
            push!(t, sortp[i])
        else
            push!(res, t)
            t = [sortp[i]]
        end
    end
    res
end

function capitalization_fixer_rowwise(mat, arr)
    a2 = filter((x)->(length(x)>1),arr)
    for rows in a2
        mat[rows[1],:] = mat[]
    end

end


function capitalization_fixer_colwise(mat, arr)
    a2 = filter((x)->(length(x)>1),arr)
    println("sum of duplicates")
    
    for col in 1:mat.n
        println("fixing column $col / $(mat.n)")
        for dups in a2
            #println("handling duplicates $dups")
            mat[dups[1],col] = sum(mat[dups,col])            
        end
    end
    a2, cleanup_rows(mat, a2)
end

function cleanup_rows(mat, arrs)
    for arr in arrs
        mat = remove_rows!(mat, arr[2:end])
    end
    mat
end

function capitalization_fixer_sp(mat, arr)
    a2 = filter((x)->(length(x)>1),arr)
    rowvals = [findall((x)->(x in tple), mat.rowval) for tple in a2]
    colptr_len = length(mat.colptr)
    for tple_i in 1:length(rowvals)
        # should be sorted
        summ = 0
        col_i = 1
        for tple_elem in rowvals[tple_i]
            while mat.colptr[col_i] < rowvals[tple_i]
                col_i += 1
                if col_i > colptr_len
                    break
                end
            end
        end
    end

end
