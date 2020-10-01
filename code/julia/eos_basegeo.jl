module eos_basegeo

export basegeo

using Statistics

function basegeo(band, #`Raster` layer to be georeferenced
    lon, #`Matrix` containing the longitudes of each pixel (as derived from
    #'  the geolocation fields datasets of the hdf5)
    lat, #`Matrix` containing the latitudes of each pixel (as derived from
    #'  the  geolocation fields datasets of the hdf5)
    fill_gaps = true)#`logical` If TRUE, pixels with no values in the
    #'  georeferenced image are filled based on a 3x3 average focal filter of the
    #'  neighbouring valid pixels, Default: TRUE


    # https://www.harrisgeospatial.com/docs/backgroundgltbowtiecorrection.html
    #
    # Estimate the median X and Y pixel sizes, using the center column and row
    # from the GLT.

    numlines = length(lon[:,1])#numero di righe
    numcols  = length(lat[:,1])#numero di righe
    
    psize_x = abs(Statistics.median(faux.diffLag(lon[:,round(numcols/2)],1)))
    psize_y = abs(Statistics.median(faux.diffLag(lat[round(numlines/2),:],1))) 

    # Compute the size of the grid, using the following IDL notation.
    # The CEIL function returns the closest integer greater than or equal to
    # its argument.

    ncols = round((maximum(dropmissing(lon))- missing(dropmissing(lon)))/psize_x)
    nrows = round((maximum(dropmissing(lat))- missing(dropmissing(lat)))/psize_y)
    
    # Map all X and Y entries in the GLT to the output grid
    out_grd = Array{Union{Nothing, Float32}}(nothing, nrows, ncols)
    minlon = minimum(dropmissing(lon))
    minlat = minimum(dropmissing(lat))
    #vals    <- raster::values(band)

    columns = round((lon - minlon) / psize_x) + 1
    rows    = nrows - round((lat - minlat) / psize_y)

    #♫ remove data if out of bounds to avoid potential crashes
    for i = ncols:length(columns)
        columns[i]=0
    end

    for i = nrows:length(rows)
        rows[i]=0
    end

    # transfer values from 1000*1000 cube to the regular 4326 grid ----
    for indpix = 1:(numlines*numcols) 
        out_grd[rows[indpix], columns[indpix]] = vals[indpix]
    end
    # Transform to raster ----

    #=
    outrast <- raster::raster(
        out_grd,
        xmn = min(lon, na.rm = TRUE) - 0.5 * psize_x,
        xmx = min(lon, na.rm = TRUE) - 0.5 * psize_x + ncols*psize_x,
        ymn = max(lat, na.rm = TRUE) + 0.5 * psize_y - nrows*psize_y,
        ymx = max(lat, na.rm = TRUE) + 0.5 * psize_y,
        crs = "+init=epsg:4326")
    =#

    # Fill gaps if requested ----
    if fill_gaps 
        println("Filling Gaps")
        #=outrast <- raster::focal(outrast, w=matrix(1,3,3), fun=mean,
                                 na.rm = TRUE, NAonly = TRUE)=#
    end

    outrast


end#fine fun basegeo

end#fine module