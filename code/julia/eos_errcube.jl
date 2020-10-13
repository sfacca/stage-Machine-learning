module errcube

export apply

function apply!(err,target,allowed)
    #=
    legenda errcube:
    x_{ibj} = 0 -> pixel_{ij} della banda b va bene
    x_{ibj} = 1 -> pixel_{ij} della banda b Invalid pixel from L1 product
    x_{ibj} = 2 -> pixel_{ij} della banda b Negative value after atcor
    x_{ibj} = 3 -> pixel_{ij} della banda b Saturated value after atcor
    =#
    count = 0
    for i = 1:length(target)
        if err[i] in allowed
        else
            target[i] = nothing
            count = count +1
        end
    end
    count
end

end