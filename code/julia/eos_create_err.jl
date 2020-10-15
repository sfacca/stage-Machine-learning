include("eos_rastwrite_lines.jl")

function create_err(indexes,err_cube,whose_err;geo=nothing,overwrite=false)

    if isnothing(geo)
        crs = nothing
        gtf=nothing
    else
        crs = geo.crs
        gtf = geo.gtf
    end

    rast = nothing
    println("getting indexes $indexes from error cube")
    for i = 1:length(indexes)
        if i == 1
            rast = copy(err_cube[:,indexes[i],:])
        else
            rast = cat(rast,err_cube[:,indexes[i],:],dims=3) 
        end
    end


    out_file = string(whose_err,"_ERR")


    rastwrite_lines.write(rast,out_file;gtf=gtf,crs=crs,overwrite=overwrite)
end