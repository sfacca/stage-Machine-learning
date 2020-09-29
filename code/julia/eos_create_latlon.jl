module eos_create_latlon

export crate_latlon

function create_latlon(f,
    proc_lev,
    out_file,
    out_format,
    base_georef,
    fill_gaps,
    in_L2_file = NULL)


    println(" - Accessing LatLon dataset - ")

    # Get geo info ----
    geo = pr_get_geoloc(f, proc_lev, "HCO", "VNIR", in_L2_file)

    if proc_lev != "2D"
        #rast_lat  <- raster::t(raster::raster(geo$lat))
        #rast_lon  <- raster::t(raster::raster(geo$lon))
        if base_georef
            #rast_lat  <- pr_basegeo(rast_lat, geo$lon, geo$lat, fill_gaps)
            #rast_lon  <- pr_basegeo(rast_lon, geo$lon, geo$lat, fill_gaps)

        else
            #rast_lat  <- raster::flip(rast_lat, 1)
            #rast_lon  <- raster::flip(rast_lon, 1)
            #raster::projection(rast_lat) <- NA
            #raster::projection(rast_lon) <- NA
        end        
    else
        outcrs = "+proj=utm +zone="*geo.proj_code
        if geo.proj_epsg[3] == 7
            outcrs = outcrs*" +south"
        end
        #rast_lat  <- raster::raster(geo$lat, crs = outcrs)
        #rast_lon  <- raster::raster(geo$lon, crs = outcrs)
        rast_lat = pr_setext_L2D(geo, rast_lat)
        rast_lon = pr_setext_L2D(geo, rast_lon)

    end

    #rastlatlon <- raster::stack(rast_lat, rast_lon)
    rename!(rastlatlon,["lat", "lon"])
    #garbage collect
    println(" - Writing LATLON raster - ")
    pr_rastwrite_lines(rastlatlon, out_file, out_format)

    if out_format == "ENVI"
        out_hdr =string(out_file, ".hdr")
        write(out_hdr,string("band names = {",join(names(rastlatlon),","),"}","\n"))
    end

    rastlatlon = nothing
    rast_lat = nothing
    rast_lon = nothing
    geo = nothing
    
end


end