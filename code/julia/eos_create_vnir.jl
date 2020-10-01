module eos_create_vnir


include("faux.jl")
#fun aux crea e salva datacbue vnir
#

#=sched
1. converti create vnir 
2. vedi create_swir
3. si può tramutare creatye vnir in create_generico?
=#

export create_vnir

function create_vnir(
    f,
    proc_lev,
    source,#string ["HC0" | "HRC"], Considered Data Cub
    out_file_vnir,
    out_format,
    base_georef,
    fill_gaps,
    wl_vnir,
    order_vnir,
    fwhm_vnir,
    apply_errmatrix,
    ERR_MATRIX,
    selbands_vnir = NULL,
    in_L2_file = NULL)

    geo = get_geoloc(f, proc_lev, source, wvl = "VNIR", in_L2_file)

    if proc_lev == 1
        vnir_cube = faux.getData(f,string("HDFEOS/SWATHS/PRS_L1_",source,"/Data Fields/VNIR_Cube"))#sparsa?
        vnir_scale= faux.getAttr(f,"ScaleFactor_Vnir")
        vnir_offset= faux.getAttr(f,"Offset_Vnir")

        if any(apply_errmatrix)||any(ERR_MATRIX)
            err_cube= faux.getData(f,string("HDFEOS/SWATHS/PRS_L1_", source,"/Data Fields/VNIR_PIXEL_SAT_ERR_MATRIX/"))
        end        
    else
        vnir_cube= faux.getData(f,string("HDFEOS/SWATHS/PRS_L", proc_lev,"_",source, "/Data Fields/VNIR_Cube"))
        vnir_max = faux.getAttr(f, "L2ScaleVnirMax")
        vnir_min = faux.getAttr(f, "L2ScaleVnirMin")
        if any(apply_errmatrix)|| any(ERR_MATRIX) 
            err_cube = faux.getData(f,string("HDFEOS/SWATHS/PRS_L", proc_lev,"_",source, "/Data Fields/VNIR_PIXEL_L2_ERR_MATRIX"))
        end
    end


    # Get the different bands in order of wvl, and convert to `raster` bands----
    # Also georeference if needed
    ind_vnir = 1

    
    if isnothing(selbands_vnir)        
        seqbands = [1:66...]
    else
        seqbands = faux.closestDistanceFunction(wl_vnir).selbands_vnir
    end

    for band_vnir in seqbands
        if wl_vnir[band_vnir] != 0#skip 0-wavelength bands
            if proc_lev in ["1","2B","2C"]
                # on L1, 2B or 2C, apply bowtie georeferencing if requested ----
                band # =  raster::raster((vnir_cube[,order_vnir[band_vnir],]),crs = "+proj=longlat +datum=WGS84")
                if base_georef
                    println(string("Importing Band: ", band_vnir," (",wl_vnir[band_vnir], ") of: 66 and applying bowtie georeferencing"))
                    lat = geo.lat
                    lon = geo.lon
                    if proc_lev =="1"
                        band = (band/vnir_scale) - vnir_offset
                    end
                    band = pr_basegeo(band,lon,lat,fill_gaps)
                    if apply_errmatrix || ERR_MATRIX
                        satband # =raster::raster((err_cube[,order_vnir[band_vnir], ]),crs = "+proj=longlat +datum=WGS84")
                        satband = pr_basegeo(satband,lon,lat,fill_gaps)
                    end
                    if apply_errmatrix
                        for i = 1:length(satband)#band[satband > 0] <- NA
                            if satband[i]&&i<=length(band)
                                band[i] = nothing
                            end                                
                        end
                    end
                else
                    println("Importing Band: ", band_vnir," (",wl_vnir[band_vnir], ") of: 66")
                    if proc_lev == "1"
                        band = (band/vnir_scale)-vnir_offset
                    end
                    #=
                    # flip the band to get it north/south
                        band <- raster::flip(band, 1)
                        raster::projection(band) <- NA
                    =#
                    if apply_errmatrix || ERR_MATRIX
                        #=
                        satband <- raster::raster(
                                (err_cube[,order_vnir[band_vnir], ]),
                                crs = "+proj=longlat +datum=WGS84")
                            satband <- raster::flip(satband, 1)
                            raster::projection(satband) <- NA
                        =#
                    end
                    if apply_errmatrix
                        for i = 1:length(satband)#band[satband > 0] <- NA
                            if satband[i]&&i<=length(band)
                                band[i] = nothing
                            end                                
                        end
                    end
                end
            else
                if proc_lev == "2D"
                    println("Importing Band: ", band_vnir," (",wl_vnir[band_vnir], ") of: 66")
                    outcrs = string("+proj=utm +zone=", geo$proj_code)
                    if geo.proj_epsg[3] == 7
                        outcrs = string(outcrs," +south")
                    end
                    outcrs = string(outcrs," +datum=WGS84 +units=m +no_defs")
                    #=
                    band <- raster::raster(
                            (vnir_cube[,order_vnir[band_vnir], ]),
                            crs = outcrs)
                    =#
                    # traspose the band to get it correctly oriented and set
                    # extent
                    #band <- raster::t(band)
                    #band <- pr_setext_L2D(geo, band)
                    if apply_errmatrix || ERR_MATRIX
                        #=satband <- raster::raster(
                                err_cube[,order_vnir[band_vnir], ],
                                crs = outcrs)
                            satband <- raster::t(satband)
                            satband <- pr_setext_L2D(geo, satband) =#
                    end
                    if apply_errmatrix
                        for i = 1:length(satband)#band[satband > 0] <- NA
                            if satband[i]&&i<=length(band)
                                band[i] = nothing
                            end                                
                        end
                    end
                end
            end
            if ind_vnir == 1
                rast_vnir = band
                if ERR_MATRIX
                    rast_vnir = satband
                end
                
            else
                #rast_vnir <- raster::stack(rast_vnir, band)
                if ERR_MATRIX
                    #rast_err <- raster::stack(rast_err, satband)
                end
            end
            ind_vnir = ind_vnir +1
        else
            println("Band: ", band_vnir, " not present")
        end
    end

    # Write the cube ----

    # create arrays of wavelengths to be used for creation of envi header and
    # bandnames

    if isnothing(selbands_vnir)
        orbands = seqbands
        for i = 1:length(wl_vnir)
            if wl_vnir[i]==0 && i <= length(seqbands)
                orbands[i]=nothing
            end
        end
        orbands = filter(x->!isnothing(x),orbands)

        rename!(rast_vnir, "b".*string.(orbands))
        wl_sub = filter(x->x!=0,wl_vnir)
        fwhm_sub = fwhm_vnir
        for i = 1:length(wl_vnir)
            if wl_vnir[i]==0 && i <= length(fwhm_sub)
                fwhm_sub[i]=nothing
            end
        end
        filter!(x->!uisnothing(x),fwhm_sub)
    else
        orbands = seqbands
        rename!(rast_vnir, "b".*string.(orbands))
        wl_sub = wl_vnir[seqbands]
        fwhm_sub = fwhm_vnir[seqbands]
    end

    vnir_cube = nothing
    bands = nothing
    #garbage collect

    println("- Writing VNIR raster -")

    pr_rastwrite_lines(rast_vnir,
                    out_file_vnir,
                    out_format,
                    proc_lev,
                    scale_min = vnir_min,
                    scale_max = vnir_max)


    if (ERR_MATRIX) 
        println("- Writing ERR raster -")

        out_file_vnir_err = string(out_file_vnir,"_ERR")
        pr_rastwrite_lines(rast_err,
                        out_file_vnir_err,
                        out_format,
                        "ERR",
                        scale_min = NULL,
                        scale_max = NULL)
        rast_err=nothing
    end

    if out_format == "ENVI"
        out_hdr = string(out_file_vnir,".hdr")        
        write(out_file_vnir,string("band names = {", join(rast_err,","),"}","\n"))
        write(out_hdr,string("wavelength = {", join(round(wl_sub, digits=4),","),"}"))        
        write(out_hdr,string("fwhm = {", join(round(fwhm_sub, digits = 4), ","), "}"))        
        write(out_hdr,"wavelength units = Nanometers")
        write(out_hdr,"sensor type = PRISMA")##### cosa prisma
    end

    rast_err = nothing
    
    out_file_txt = string(out_file_vnir,".wvl")

    myDf = DataFrame(
        band = faux.seq_along(wl_sub),
        orband = orbands,
        wl = wl_sub,
        fwhm = fwhm_sub
    )
    using CSV
    CSV.write(out_file_txt,myDf)

end #end funzione create vnir


end #end module