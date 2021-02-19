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
    ind = 1
    for i in indexes
        if ind == 1
            rast = copy(err_cube[:,i,:])
        else
            rast = cat(rast,err_cube[:,i,:],dims=3) 
        end
        ind = ind + 1
    end


    out_file = string(whose_err,"_ERR")

    println("created error cube of $(size(rast)) dimensions")
    rastwrite_lines.write(rast,out_file;gtf=gtf,crs=crs,overwrite=overwrite)
end