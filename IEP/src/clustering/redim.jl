function remove_empty_rows(data)
    data[sort(unique(data.rowval)),:]
end

function word_abundance(data)
    wa = zeros(data.m)
    srt = sort(data.rowval)
    strt = 1
    for i in 1:length(srt)
        if srt[i] != srt[strt]
            wa[srt[strt]] = i-strt
            strt = i
        end
    end
    wa
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