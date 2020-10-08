module rastwrite_lines

include("faux.jl")
using HDF5
using ArchGDAL

export rastwrite_lines


#scrive cubo in raster
function rastwrite_lines(cube,
        out_file,
        gtf=nothing,
        crs=nothing
        )

    out_file = string(out_file,".tif")
    dims = size(cube)
    width = dims[1]

    if length(dims)==2#se cubo è a due dimensioni, cubo è una banda
        height = dims[2]
        bandsnum = 1
    else
        height = dims[3]
        bandsnum = dims[2]
    end   


    ArchGDAL.create(
        out_file,
        driver = ArchGDAL.getdriver("GTiff"),
        width=width,
        height=height,
        nbands=bandsnum,
        dtype=typeof(cube[1])
    ) do dataset
        if length(dims)==2
            ArchGDAL.write!(dataset, cube, 1)
        else
            for i = 1:bandsnum
                ArchGDAL.write!(dataset, cube[:,i,:], i)
            end
        end

        if isnothing(gtf)
            println("no geotransform array")
        else
            ArchGDAL.setgeotransform!(dataset, gtf)
        end

        if isnothing(crs)
            println("no coordinate reference system string")
        else
            ArchGDAL.setproj!(dataset, crs)    
        end

    end

end