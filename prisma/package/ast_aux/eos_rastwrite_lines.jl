using ArchGDAL, HDF5
#scrive cubo in raster
function rastwrite_lines(cube,
        out_file;
        gtf=nothing,
        crs=nothing,
        overwrite=false
        )


    println("preparing to write tiff")
    mkpath(f_dirname(out_file))
    out_file = string(out_file,".tif")
    if isfile(out_file)
        println("file $out_file already exists")
        if overwrite
            println("overwrite set, removing file")
            rm(out_file)
            actuallyWrite(cube,out_file;gtf=gtf,crs=crs)
        else
            println("set overwrite to true to overwrite")
        end
    else
        actuallyWrite(cube,out_file;gtf=gtf,crs=crs)
    end    
end

function actuallyWrite(cube,
        out_file;
        gtf=nothing,
        crs=nothing)


    dims = size(cube)
    

    width = dims[1]
    println("<=========================================")
    if length(dims)==2#se cubo è a due dimensioni, cubo è una banda

        height = dims[2]
        tpe = typeof(cube[1,1])
        bandsnum = 1
    else
        tpe = typeof(cube[1,1,1])
        height = dims[2]
        bandsnum = dims[3]
    end
    println("writing $bandsnum bands of $width x $height")
    println("dims: $dims")
    println("cube type: $(typeof(cube))")
    #tpe = typeof(cube[end])
    println("type: $tpe")
    ArchGDAL.create(
        out_file,
        driver = ArchGDAL.getdriver("GTiff"),
        width=width,
        height=height,
        nbands=bandsnum,
        dtype=tpe
    ) do dataset
        println("writing bands in  empty tiff")
        if length(dims)==2
            ArchGDAL.write!(dataset, cube[:,:], 1)
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
    out_file


end