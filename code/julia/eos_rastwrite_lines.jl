module rastwrite_lines

include("faux.jl")
using HDF5
using ArchGDAL

export rastwrite_lines


#scrive cubo in raster
function write(cube,
        out_file,
        gtf=nothing,
        crs=nothing
        )


    println("preparing to write tiff")

    out_file = string(out_file,".tif")
    dims = size(cube)
    width = dims[1]

    if length(dims)==2#se cubo è a due dimensioni, cubo è una banda
        height = dims[2]
        bandsnum = 1
    else
        height = dims[2]
        bandsnum = dims[3]
    end   


    ArchGDAL.create(
        out_file,
        driver = ArchGDAL.getdriver("GTiff"),
        width=width,
        height=height,
        nbands=bandsnum,
        dtype=typeof(cube[1])
    ) do dataset
        println("writing bands in  empty tiff")
        if length(dims)==2
            ArchGDAL.write!(dataset, cube, 1)
        else
            for i = 1:bandsnum
                #println("writing $i th band")
                ArchGDAL.write!(dataset, cube[:,:,i], i)
            end
        end
        println("finished writing bands")
        if isnothing(gtf)
            println("no geotransform array")
        else
            println("setting geotransform")
            ArchGDAL.setgeotransform!(dataset, gtf)
        end

        if isnothing(crs)            
            println("no coordinate reference system string")
        else
            println("setting crs string")
            ArchGDAL.setproj!(dataset, crs)    
        end
        println("finished writing on $out_file")
    end

end


end