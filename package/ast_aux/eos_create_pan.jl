using ArchGDAL

#   helper function used to process and save the PAN data cube

function create_pan(
        f,
        proc_lev,
        out_file;
        overwrite=false      
        )

        println("###### create_pan start ######")
    if proc_lev != "2D"
        println("errore: file non è prodotto lvl 2d")
        return nothing
    end

    geo = eos_geoloc.get(f,"PAN") 
    
    #prendo cubo

    cube = getData(f,"HDFEOS/SWATHS/PRS_L$(proc_lev)_PCO/Data Fields/Cube")
    dims = size(cube)
    width = dims[1]
    if length(dims)==2
        height=dims[2]
    else
        height=dims[3]
    end

    out_file = string(out_file,"_PAN")
    #scrivo cubo

    rastwrite_lines(cube,
        out_file;
        gtf=geo.gtf,
        crs=geo.crs,
        overwrite=overwrite
    )
    println("###### create full end #######")
end



#=
function create_pan(f,# input data he5 from caller
    proc_lev,#proc_lev `character` Processing level (e.g., "1", "2B")
    source,#
    out_file_pan,# output file name for PAN
    out_format,#
    base_georef,#
    fill_gaps,#
    in_L2_file = nothing)#



    geo = pr_get_geoloc(f, proc_lev, source, wvl = "PAN", in_L2_file)

    println(" - Accessing PAN dataset - ")
    if proc_lev == "1"
        pan_scale  = getAttr(f,"ScaleFactor_Pan")
        pan_offset = getAttr(f, "Offset_Pan")
        pan_cube   = getData(f,string("/HDFEOS/SWATHS/PRS_L1_",replace(source, "H"=>"P"),"/Data Fields/Cube"))    
    else
        pan_cube  = getData(f,string("//HDFEOS/SWATHS/PRS_L", proc_lev,"_PCO/Data Fields/Cube"))
        panscale_min = getAttr(f, "L2ScalePanMin")
        panscale_max = getAttr(f, "L2ScalePanMax")
    end

    if proc_lev in ["1", "2B", "2C"]

        if base_georef
            println("Applying bowtie georeferencing")
            #rast_pan <- raster::raster(pan_cube,
                                       #crs = "+proj=longlat +datum=WGS84")
            if proc_lev == "1"
                rast_pan = (rast_pan / pan_scale) - pan_offset
            end
            rast_pan = pr_basegeo(rast_pan, geo$lon, geo$lat, fill_gaps)
        else
            #rast_pan <- raster::raster(pan_cube)
            #rast_pan <- raster::flip(rast_pan, 1)
            #raster::projection(rast_pan) <- NA
        end
    else 
        if proc_lev == "2D"
            #=rast_pan <- raster::raster(
                pan_cube,
                crs = paste0("+proj=utm +zone=", geo$proj_code,
                             ifelse(substring(geo$proj_epsg, 3, 3) == 7,
                                    " +south", ""),
                             " +datum=WGS84 +units=m +no_defs"))=#
            #rast_pan <- raster::t(rast_pan)
            ex = [
                geo.xmin - 2.5 , geo.ymin - 2.5, 
                geo.xmin - 2.5 + (5*length(rast_pan[1,:])),
                geo.ymin - 2.5 + (5*length(rast_pan[:,1]))
            ]
            ex = reshape(ex,2,2)            
            
            #ex <- raster::extent(ex)
            #rast_pan <- raster::setExtent(rast_pan, ex, keepres = FALSE)
        end
    end
    pan_cube = nothing
    #garbArchGDALe collect

    println("- Writing PAN raster -")

    pr_rastwrite_lines(rast_pan, out_file_pan, out_format, proc_lev,
                       scale_min = panscale_min,
                       scale_max = panscale_max)
    rast_pan=nothing
    geo=nothing
    #garbArchGDALe collect

end=#