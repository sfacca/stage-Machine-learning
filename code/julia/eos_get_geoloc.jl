module eos_get_geoloc

include("faux.jl")

using HDF5

export get_geoloc



function get_geoloc(f,
    proc_lev,
    source,
    wvl        = NULL,
    in_L2_file = NULL)

    if proc_lev == "1"
        if isnothing(in_L2_file)
            # If plev = L1, and no L2 file ,get geo from L1 ----
            if isnothing(wvl) || wvl == "VNIR"
                #= 
                lat <- raster::t(f[[paste0(
                        "/HDFEOS/SWATHS/PRS_L1_", source,
                        "/Geolocation Fields/Latitude_VNIR")]][,])
                lon <- raster::t(f[[paste0(
                        "/HDFEOS/SWATHS/PRS_L1_",
                        source,
                        "/Geolocation Fields/Longitude_VNIR")]][,])
                        =#          
                   
            else
                if wvl == "SWIR"
                    #=
                    lat <- raster::t(f[[paste0(
                            "/HDFEOS/SWATHS/PRS_L1_",
                            source,
                            "/Geolocation Fields/Latitude_SWIR")]][,])
                        lon <- raster::t(f[[paste0(
                            "/HDFEOS/SWATHS/PRS_L1_",
                            source,
                            "/Geolocation Fields/Longitude_SWIR")]][,])
                    =#                        
                else
                    #=
                        lat <- raster::t(f[[paste0(
                            "/HDFEOS/SWATHS/PRS_L1_",
                            gsub("H", "P", source),
                            "/Geolocation Fields/Latitude")]][,])
                        lon <- raster::t(f[[paste0(
                            "/HDFEOS/SWATHS/PRS_L1_",
                            gsub("H", "P", source),
                            "/Geolocation Fields/Longitude")]][,])
                            =#
                end                  
            end
        else
            # If plev = L1, and L2 file ,get geo from L2 ----
            try
                f2 = HDF5.h5open(in_L2_file,"r+")
            catch e
                println("Unable to open the input accessory L2 file as a hdf5 file. Verify your inputs. Aborting!")
                e
            end
                
                proc_lev_f2  = faux.getAttr(f2,"Processing_Level")

            if proc_lev_f2 == "1"
                println("in_L2_file is not a L2 PRISMA file. Aborting!")
                return nothing
            end
            if wvl != "PAN"
                #=
                lat <- raster::t(f2[[paste0(
                    "/HDFEOS/SWATHS/PRS_L",
                    proc_lev_f2, "_", source,
                    "/Geolocation Fields/Latitude")]][,])
                lon <- raster::t(f2[[paste0(
                    "/HDFEOS/SWATHS/PRS_L",
                    proc_lev_f2, "_",
                    source,
                    "/Geolocation Fields/Longitude")]][,])=#
            else
                #= 
                lat <- raster::t(f2[[paste0(
                    "/HDFEOS/SWATHS/PRS_L", proc_lev_f2,
                    "_", gsub("H", "P", source),
                    "/Geolocation Fields/Latitude")]][,])
                lon <- raster::t(f2[[paste0(
                    "/HDFEOS/SWATHS/PRS_L", proc_lev_f2,
                    "_", gsub("H", "P", source),
                    "/Geolocation Fields/Longitude")]][,])=#
            end            
        end

        out = DataFrame(lat = lat, lon = lon)
        out           
    else 
        if isnothing(wvl) || wvl != "PAN"
            #=
                lat <- raster::t(f[[paste0("/HDFEOS/SWATHS/PRS_L",
                                                    proc_lev, "_",
                                                    source,
                                                    "/Geolocation Fields/Latitude")]][,])
                lon <- raster::t(f[[paste0("/HDFEOS/SWATHS/PRS_L", proc_lev, "_",
                                                    source,
                                                    "/Geolocation Fields/Longitude")]][,])
            =#
        else
            #=
            lat <- raster::t(f[[paste0("/HDFEOS/SWATHS/PRS_L",
                                       proc_lev,
                                       "_", gsub("H", "P", source),
                                       "/Geolocation Fields/Latitude")]][,])
            lon <- raster::t(f[[paste0("/HDFEOS/SWATHS/PRS_L", proc_lev,
                                       "_", gsub("H", "P", source),
                                       "/Geolocation Fields/Longitude")]][,])
                                       =#        
        end

        if proc_lev == "2D"            
            # If plev = L2D, get also the corners and projection ----

            #=
            proj_code <- hdf5r::h5attr(f, "Projection_Id")
            proj_name <- hdf5r::h5attr(f, "Projection_Name")
            proj_epsg <- hdf5r::h5attr(f, "Epsg_Code")
            xmin  <- min(hdf5r::h5attr(f, "Product_ULcorner_easting"),
                         hdf5r::h5attr(f, "Product_LLcorner_easting"))
            xmax  <- max(hdf5r::h5attr(f, "Product_LRcorner_easting"),
                         hdf5r::h5attr(f, "Product_URcorner_easting"))
            ymin  <- min(hdf5r::h5attr(f, "Product_LLcorner_northing"),
                         hdf5r::h5attr(f, "Product_LRcorner_northing"))
            ymax  <- max(hdf5r::h5attr(f, "Product_ULcorner_northing"),
                         hdf5r::h5attr(f, "Product_URcorner_northing"))
                         =#

            out = DataFrame(xmin = xmin,
                        xmax = xmax,
                        ymin = ymin,
                        ymax = ymax,
                        proj_code = proj_code,
                        proj_name = proj_name,
                        proj_epsg = proj_epsg,
                        lat = lat,
                        lon = lon)
            out
        end
        if proc_lev  in ["2B", "2C"]
            out = DataFrame(lat = lat, lon = lon)
            out
        end      
        
    end

    out

end#end get geoloc

end#end modulo