module eos_create_additional

export  create_additional

include("faux.jl")

function create_additional(f,
    type,
    out_file,
    out_format,
    base_georef,
    fill_gaps,
    in_L2_file = NULL)


    println(" - Accessing ", type, " dataset - ")

    # Get geo info ----
    geo = pr_get_geoloc(f, "1", "HCO", "VNIR", in_L2_file)

    if type == "CLD"
        cube = faux.getData(f,"/HDFEOS/SWATHS/PRS_L1_HCO/Data Fields/Cloud_Mask")
    end

    if type == "LC"
        cube = faux.getData(f,"/HDFEOS/SWATHS/PRS_L1_HCO/Data Fields/LandCover_Mask")
    end

    if type == "GLINT"
        cube = faux.getData(f,"/HDFEOS/SWATHS/PRS_L1_HCO/Data Fields/SunGlint_Mask")
    end
    
    rast = nothing #raster::raster(cube)

    if base_georef
        println("Applying bowtie georeferencing")
        rast = pr_basegeo(rast, geo.lon, geo.lat, fill_gaps)
    else
        #rast <- raster::flip(rast, 1)
        #raster::projection(rast) <- NA
    end
    
    if type in ["CLD", "LC", "GLINT"]
        for i in i:length(rast)
            if rast[i] == 255
                rast[i] = nothing
                break
            end
        end
    end

    cube = nothing
    #garbage collect

    println(" - Writing  ", type, " raster - ")
    pr_rastwrite_lines(rast, out_file, out_format)

end



end