

include("faux.jl")
include("eos_geoloc.jl")
include("eos_errcube.jl")
include("eos_rastwrite_lines.jl")
using CSV
using DataFrames
#fun aux crea e salva datacube

#=
1. legge cubo dal file
2. tiene solo bande selezionate (o le più vicine per wvl)
3. toglie valori errati (se apply_errmatrix==true)
4. converte ratios 0-65535 in reflettanze
5. salva cubo come raster.tif
=#



function create_cube(
        f,
        proc_lev,
        source,#string ["HC0" | "HRC"], Considered Data Cub
        out_file,
        wl,#NB: ORDERED wl = raw_wvl[order]
        order,
        fwhm;#NB: riordinate con ordine order
        overwrite=false,
        type="VNIR",
        ERR_MATRIX=nothing,        
        apply_errmatrix=false,
        selbands = nothing,
        in_L2_file = nothing
        )#string = [ VNIR , SWIR ]
        
    println("####### create_cube start #########")
    
    #geo = get_geoloc(f, proc_lev, source, wvl = type, in_L2_file)
    println("eos_create_$type")
    type = uppercase(type)#
    if type in [ "VNIR", "SWIR"]#todo: PAN, LATLON
        #ok
    else
        throw(error("parametro type: $type non va bene, dev essere vnir o swir")) 
    end

    typelcase = titlecase(type, strict = true)

    if proc_lev == 1
        println("processing level 1")
        cube = faux.getData(f,string("HDFEOS/SWATHS/PRS_L1_",source,"/Data Fields/$(type)_Cube"))#sparsa?
        scale= faux.getAttr(f,"ScaleFactor_$(typelcase)")
        offset= faux.getAttr(f,"Offset_$(typelcase)")

        if apply_errmatrix
            println("prendo cubo errori")
            err_cube= faux.getData(f,string("HDFEOS/SWATHS/PRS_L1_", source,"/Data Fields/$(type)_PIXEL_SAT_ERR_MATRIX/"))
        end        
    else
        println("processing level: $proc_lev")
        cpath = string("HDFEOS/SWATHS/PRS_L", proc_lev,"_",source, "/Data Fields/$(type)_Cube")
        println("prendo cubo da $f $cpath")
        cube= faux.getData(f,cpath)
        # converte ratio (0,65535) in reflectance 
        #cube = faux.ratioToReflectance(f,cube,type)
        
        if apply_errmatrix 
            err_cube = faux.getData(f,string("HDFEOS/SWATHS/PRS_L", proc_lev,"_",source, "/Data Fields/$(type)_PIXEL_L2_ERR_MATRIX"))
        end
    end


    # Get the different bands in order of wvl
    ind = 1

    maxbands = 0
    if type == "VNIR" 
        println("prendo vnir")
        range = 1:66
    else
        println("prendo swir")
        range = 1:173
    end


    
    if isnothing(selbands)  
        println("no selbands, prendo tutto")      
        seqbands = [range...]
    else
        sort!(selbands)
        println("$type wavelengths requested: $selbands")
        seqbands = faux.closestElements(selbands,wl)
        println("closest $type wavelengths: $(wl[seqbands])")
    end

    #estrae matrici delle bande in seqbands e le aggiunge a un cubo di nome rast
    #NB: una banda i del cubo preso dall'hdf è cube[:,i,:] mentre una banda in rast sarà rast[:,:,i]
    #cerchiamo di usare cubi con indice di banda in mezzo solo qua per coerenza


    rast = nothing
    println("creating cube...")
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
                    println("Importing Band: ", band_i," (",wl[band_i], ") of: $range")
                    
                    band = cube[:,order[band_i],:]

                    if apply_errmatrix || !isnothing(ERR_MATRIX)                    
                        
                        #setta valori con errori a nothing
                        count = errcube.apply!(ERR_MATRIX,band,[0])
                        @warn "tolto $count pixel con errori"
                        
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
                #println("first band is cube")
                rast = copy(band)                
            else
                #println("appending band to cube")
                rast = cat(rast,band,dims=3)  
                #println("cube has $(size(rast)) dims")              
            end
            ind = ind +1
        else
            println("Band: ", band_i, " not present")
        end
    end 
    println("cube created")
    println("cube has $(size(rast)) dims")            
   

    cube = nothing
    bands = nothing
    #garbage collect

    println("- Writing raster -")

    # crea geoloc
    geo = eos_geoloc.get(f,type)

    #scrive file
    out_file = string(out_file,"_",type)
    rastwrite_lines.write(rast, out_file; gtf=geo.gtf, crs=geo.crs,overwrite=overwrite)


    #scrittura parti aggiuntive

    #raster errori
    if !isnothing(ERR_MATRIX) 
        println("- Writing ERR raster -")

        out_file_err = string(out_file,"_ERR")
        rastwrite_lines.write(rast_err,
                        out_file_err;
                        overwrite=overwrite
                        )
        rast_err=nothing
    end  
    rast_err = nothing

    #
    out_file_txt = string(out_file,".wvl")   
    if isnothing(selbands)    
        wl_sub = filter(x->x!=0,wl)
        myind = faux.indexesOfNonZero(wl)
        orbands = seqbands[myind]
        fwhm_sub = fwhm[myind]
    else
        orbands = seqbands        
        wl_sub  = wl[seqbands]
        fwhm_sub = fwhm[seqbands]
    end
    println("creating and writing dataframe of selected bands with wavelengths and bandwidths")
    myDf = DataFrame(
        band = faux.seq_along(wl_sub),
        orband = orbands,
        wl = wl_sub,
        fwhm = fwhm_sub
    )
    
    CSV.write(out_file_txt,myDf)
    println("####### create_cube end #########")
    out_file
end #end funzione create vnir


