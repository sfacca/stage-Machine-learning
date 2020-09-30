module rastwrite_lines

include("faux.jl")
using HDF5

export rastwrite_lines

function rastwrite_lines(rast_in,
        out_file,
        out_format = "tif",
        proc_lev = "1",
        scale_min = NULL,
        scale_max = NULL,
        join = FALSE)
    #=
    if (se rast_in ha >1 numero di layers)
        out <- raster::brick(rast_in, values = FALSE)
    else
        out <- raster::raster(rast_in)
    end=#    
    #bs =  raster::blockSize(out)

    if proc_lev == "ERR"
        datatype = "INT1U"
    end

    #= ??????????????????????
    if proc_lev[1] == "1"
        datatype = "FLT4S"
    else
        datatype = "FLT4S"
    end
    =#
    datatype = "FLT4S"

#=
    out <- raster::writeStart(out,
                              filename = out_file,
                              overwrite = TRUE,
                              options = c("COMPRESS=LZW"),
                              datatype = datatype)
                              =#

    for i in 1:bs.n
        println("Writing Block: ", i, " of: ", bs.n)
        #v <- raster::getValues(rast_in, row = bs$row[i], nrows = bs$nrows[i] )
        if proc_lev[1] == "2" && !join
            v <- scale_min + (v * (scale_max - scale_min)) / 65535
        end
        #out <- raster::writeValues(out, v, bs$row[i])
    end
    
    #out <- raster::writeStop(out)
    nothing
end