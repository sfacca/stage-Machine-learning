module eos_create


include("faux.jl")
include("eos_geoloc.jl")
include("eos_errcube.jl")
#fun aux crea e salva datacbue
#

#=
1. legge cubo dal file
2. tiene solo bande selezionate (o le più vicine per wvl)
3. toglie valori errati (se apply_errmatrix==true)
4. converte ratios 0-65535 in reflettanze
5. salva cubo come raster.tif
=#

export create_cube

function create_cube(
    f,
    proc_lev,
    source,#string ["HC0" | "HRC"], Considered Data Cub
    out_file,
    out_format,
    base_georef,
    fill_gaps,
    wl,
    order,
    fwhm,
    apply_errmatrix,
    ERR_MATRIX,
    selbands = NULL,
    in_L2_file = NULL,
    type)#string = [ VNIR , SWIR ]

    geo = get_geoloc(f, proc_lev, source, wvl = type, in_L2_file)

    type = uppercase(type)#
    if type in [ "VNIR", "SWIR"]#todo: PAN, LATLON
        #ok
    else
        throw(error("parametro type: $type non va bene, dev essere vnir o swir")) 
    end

    typelcase = titlecase(type, strict = true)

    if proc_lev == 1
        cube = faux.getData(f,string("HDFEOS/SWATHS/PRS_L1_",source,"/Data Fields/$(type)_Cube"))#sparsa?
        scale= faux.getAttr(f,"ScaleFactor_$(typelcase)")
        offset= faux.getAttr(f,"Offset_$(typelcase)")

        if any(apply_errmatrix)||any(ERR_MATRIX)
            err_cube= faux.getData(f,string("HDFEOS/SWATHS/PRS_L1_", source,"/Data Fields/$(type)_PIXEL_SAT_ERR_MATRIX/"))
        end        
    else
        cube= faux.getData(f,string("HDFEOS/SWATHS/PRS_L", proc_lev,"_",source, "/Data Fields/$(type)_Cube"))

        # converte ratio (0,65535) in reflectance 
        cube = faux.ratioToReflectance(f,cube,type)
        
        if any(apply_errmatrix) || any(ERR_MATRIX) 
            err_cube = faux.getData(f,string("HDFEOS/SWATHS/PRS_L", proc_lev,"_",source, "/Data Fields/$(type)_PIXEL_L2_ERR_MATRIX"))
        end
    end


    # Get the different bands in order of wvl, and convert to `raster` bands----
    # Also georeference if needed
    ind = 1

    maxbands = 0
    if type == "VNIR" 
        range = 1:66
    else
        range = 1:173
    end


    
    if isnothing(selbands)        
        seqbands = [range...]
    else
        seqbands = faux.closestDistanceFunction(wl_vnir).selbands
    end

    for band_i in seqbands
        if wl[band_i] != 0#skip 0-wavelength bands
            if proc_lev in ["1","2B","2C"]#=
                # on L1, 2B or 2C, apply bowtie georeferencing if requested ----
                band # =  raster::raster((vnir_cube[,order[band_vnir],]),crs = "+proj=longlat +datum=WGS84")
                if base_georef
                    println(string("Importing Band: ", band_i," (",wl[band_i], ") of:  and applying bowtie georeferencing"))
                    lat = geo.lat
                    lon = geo.lon
                    if proc_lev =="1"
                        band = (band/scale) - offset
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
                    println("Importing Band: ", band_i," (",wl[band_i], ") of: 66")
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
                end=#
                throw(error("processing level $proc_lev not supported yet"))
            else
                if proc_lev == "2D"
                    println("Importing Band: ", band_i," (",wl[band_i], ") of: 66")

                    crs = eos_geoloc.getCrs(geo,proc_lev)
                    band = cube[:,order[band_i],:]

                    #=
                    band <- raster::raster(
                            (vnir_cube[,order_vnir[band_vnir], ]),
                            crs = outcrs)
                    =#
                    # archgdal non usa extent
                    # traspose the band to get it correctly oriented and set
                    # extent
                    #band <- raster::t(band)
                    #band <- pr_setext_L2D(geo, band) archgdal non usa extent
                    #########################

                    if apply_errmatrix || ERR_MATRIX
                        
                        #setta valori con errori a nothing
                        count = errcube.apply!(ERR_MATRIX,band,[0])
                        @warn "tolto $count pixel con errori"

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
            if ind == 1
                rast = band
                if ERR_MATRIX
                    rast = satband
                end
                
            else
                #rast <- raster::stack(rast, band)
                if ERR_MATRIX
                    #rast_err <- raster::stack(rast_err, satband)
                end
            end
            ind = ind +1
        else
            println("Band: ", band_i, " not present")
        end
    end

    # Write the cube ----

    # create arrays of wavelengths to be used for creation of envi header and
    # bandnames

    if isnothing(selbands)
        orbands = seqbands
        for i = 1:length(wl)
            if wl[i]==0 && i <= length(seqbands)
                orbands[i]=nothing
            end
        end
        orbands = filter(x->!isnothing(x),orbands)

        rename!(rast, "b".*string.(orbands))
        wl_sub = filter(x->x!=0,wl)
        fwhm_sub = fwhm
        for i = 1:length(wl)
            if wl[i]==0 && i <= length(fwhm_sub)
                fwhm_sub[i]=nothing
            end
        end
        filter!(x->!uisnothing(x),fwhm_sub)
    else
        orbands = seqbands
        rename!(rast, "b".*string.(orbands))
        wl_sub = wl[seqbands]
        fwhm_sub = fwhm[seqbands]
    end

    cube = nothing
    bands = nothing
    #garbage collect

    println("- Writing VNIR raster -")

    pr_rastwrite_lines(rast,
                    out_file)


    if (ERR_MATRIX) 
        println("- Writing ERR raster -")

        out_file_err = string(out_file,"_ERR")
        pr_rastwrite_lines(rast_err,
                        out_file_err,
                        out_format,
                        "ERR",
                        scale_min = NULL,
                        scale_max = NULL)
        rast_err=nothing
    end

    if out_format == "ENVI"
        out_hdr = string(out_file,".hdr")        
        write(out_file,string("band names = {", join(rast_err,","),"}","\n"))
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