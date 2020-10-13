module eos_convert
    
  export convert

  include("faux.jl")
  include("eos_create_swir.jl")
  include("eos_create_vnir.jl")
  include("eos_create_FULL.jl")
  include("eos_create_pan.jl")
  using HDF5
  using CSV# per leggere tabella indexes_list.txt
  using DataFrames
  using DataFramesMeta
  using ArchGDAL

  
  function getIndexList()
    mkpath("downloads")
    download("https://github.com/sfacca/stage-Machine-learning/raw/master/extdata/md_indexes_list.txt","downloads/indexes_list.txt")
    index_list = CSV.read("downloads/indexes_list.txt")
    select!(index_list, Not(:id))
  end


  function attachExtension!(outformat::String, path::String)
      if outformat == "GTiff"
          path = string(path, ".tif")
      else
          path = string(path, ".envi")
      end
      path
  end

  function checkCommon(x::Array{Int,1}, y::Array{Int,1})# NB: x,y SORTED in maniera crescente, unici, ritorna true se almeno un elem di x è in y
      res = false
      i = 1
      for elemx in x

          while elemx > y[i] && i < length(y)# se elem di x è maggiore dell elem di y, scorro y
              i = i + 1
          end    

          if elemx == y[i]# se elemx = elemy -> interrompo ciclo ritornano true
              res = true
              break
          end

      # se elemx < elemy, scorro x
      end
      res# se non ho trovato uguali, res è ancora false
  end
  # O(length(x)+length(y))  
  closestDistanceFunction = faux.closestDistanceFunction

  

  extractWvl = faux.extractWvl
  

  function closestWvl(wvl::Array{Int64,1}, x::Int64)
      y = abs.(wvl .- x)
    # lapply(selbands_vnir, FUN = function(x) which.min(abs(wl_vnir - x))))
      minimum(abs.(wvl .- x))
  end

  function getAttr(file, name::String)
      # name è attributo globale del file(aperto) hdf5 file
      # ritorna campo valore name
      atts = attrs(file)
      content = read(atts, name)
      content
  end

  function convert(in_file,##NB: in_file dev esser già aperto, a diff di pr_convert    
      out_file,      
      source="HCO",      
      PAN=true,#boolean: true-> crea tif pancroatico
      VNIR=true,#boolean: true-> crea tif cubo vnir
      SWIR=true, #boolean: true-> crea tif pancroatico
      FULL=true,#boolean: true-> crea tif pancroatico
      join_priority="VNIR",
      overwrite=false,
      selbands_vnir=nothing, 
      selbands_swir=nothing,
      indexes=nothing,
      cust_indexes=nothing)

      
    out_folder = faux.dirname(out_file)
    mkpath(out_folder)
    #=
    out_filename = faux.filename(out_file)=#
    basefile = faux.fileSansExt(out_file)

    ##raccolta attributi
    #NB prodotti di macchine diverse possono avere nomi attributi diversi?
    
    proc_lev = getAttr(in_file, "Processing_Level")
    
    # Get wavelengths and fwhms ----
    wl_vnir = getAttr(in_file, "List_Cw_Vnir")
    wl_swir = getAttr(in_file, "List_Cw_Swir")
    fwhm_vnir = getAttr(in_file, "List_Fwhm_Vnir")
    fwhm_swir = getAttr(in_file, "List_Fwhm_Swir")

    # get additional metadata
    sunzen  = getAttr(in_file, "Sun_zenith_angle")
    sunaz  = getAttr(in_file, "Sun_azimuth_angle")
    acqtime  = getAttr(in_file, "Product_StartTime")

    # riordinazioni
    order_vnir = sortperm(wl_vnir)# permut
    wl_vnir = wl_vnir[order_vnir]    
    order_swir = sortperm(wl_swir)
    wl_swir = wl_swir[order_swir]      
    fwhm_vnir = fwhm_vnir[order_vnir]    
    fwhm_swir = fwhm_swir[order_swir]
    # join
    fwhms = vcat(fwhm_vnir, fwhm_swir)
    wls = vcat(wl_vnir, wl_swir)

    # If indexes need to be computed, retrieve the list of VNIR and SWIR ----
    # wavelengths required for the computataion and automatically fill
    # the selbands_vnir and selbands_swir variables
    if !isnothing(indexes) | !isnothing(cust_indexes) 
      if proc_lev in ["1", "2B"]
          @warn "Spectral indexes are usually meant to be computed on reflectance data. Proceed with caution!"          
      end
      
      index_list = getIndexList()
      #########################################################################
      av_indexes = select(index_list, [:Name,:Formula])        
      sel_indexes = filter(row -> row.Name ∈ indexes, av_indexes)# filter è poco performante?
      tot_indexes = vcat(sel_indexes, cust_indexes)
      # when computing indexes, find out the required wavelengths
      # on vnir and swir
      # req_wls : array di int unici, in ordine cresc, ogni int è il numero di una banda dalle formula di tot_indexes
      req_wvl = sort(unique(vcat(extractWvl.(tot_indexes[:Formula])...)))# req_wvl IS SORTED      
      max_vnir = maximum(wl_vnir)# var ausiliaria
      min_swir = minimum(filter(item -> item != 0, wl_swir))# var ausiliaria
      selbands_vnir = filter(item -> item <= max_vnir, req_wls)# bande minori della banda vnir + alta
      selbands_swir = filter(item -> item >= min_swir, req_wls)# bande maggiori della banda swir non0 più piccola
      if checkCommon(selbands_swir, selbands_vnir)# if selected vnir bands overlap selected swir bands:
        if (join_priority == "VNIR")# parametro di input
            selbands_swir = filter(item -> item >= max_vnir, selbands_swir)# selbands_swir sono solo quelle + grandi del vnir maggiore
        else 
            selbands_vnir = filter(item -> item <= min_swir, selbands_vnir)# bande vnir selez sono solo quelle minori della swir minore
        end
      end     
      #FULL = true
    else
      selbands_swir=nothing
      selbands_vnir=nothing
    end

    #=
    # write ATCOR files if needed ----
    if ATCOR == true && proc_lev == "1"
        make_atcor(f,
                  out_folder,
                  out_file,
                  ATCOR_wls,
                  wls,
                  fwhms,
                  order_vnir,
                  order_swir,
                  join_priority,
                  source)
    end=#   
    

    # create the "META" ancillary txt file----   
    out_file_angles = string(basefile, "_ANGLES.txt")
    ang_df = DataFrame(date=acqtime, sunzen=sunzen, sunaz=sunaz)
    CSV.write(out_file_angles, ang_df)

    

    
   
    

    # get VNIR data cube and convert to raster ----
    if VNIR
      out_file_vnir = string(basefile,"_VNIR.tif")
      if isfile(out_file_vnir) && overwrite==false
        println("file $out_file_vnir already exists, set overwrite to true")
      else
        out_file_vnir = create_vnir(in_file,proc_lev,source,basefile,wl_vnir,
          order_vnir,fwhm_vnir,false,nothing,selbands_vnir)
      end
    end

    # get SWIR data cube and convert to raster ----   
    if SWIR
      out_file_swir = string(basefile,"_SWIR.tif")
      if isfile(out_file_swir) && overwrite==false
        println("file $out_file_swir already exists, set overwrite to true")
      else
        out_file_vnir = create_swir(in_file,proc_lev,source,basefile,wl_swir,
          order_swir,fwhm_swir,false,nothing,selbands_swir)
      end
    end  

    
    
    
    #    Create and write the FULL hyperspectral cube if needed ----
    if FULL
      #get geo  
      out_file_full = string(basefile)    
      geo = eos_geoloc.get(in_file,"VNIR")#
      out_file_full = create_full(basefile,join_priority,overwrite,geo)
    end


    # Save PAN if requested ----    
    if PAN
      out_file_pan = create_pan(in_file,proc_lev,basefile)
    end

  end
#=
  function convert(in_file,
      out_folder,
      out_filebase="auto",
      out_format="ENVI",
      base_georef=true,
      fill_gaps=false,
      VNIR=false,
      SWIR=false,
      FULL=false,
      source="HCO",
      join_priority="SWIR",
      ATCOR=false,
      ATCOR_wls=nothing,
      PAN=false,
      CLOUD=false,
      LC=false,
      GLINT=false,
      ANGLES=false,
      LATLON=false,
      ERR_MATRIX=false,
      apply_errmatrix=false,
      overwrite=false,
      in_L2_file=nothing,
      selbands_vnir=nothing,
      selbands_swir=nothing,
      indexes=nothing,
      cust_indexes=nothing,
      keep_index_cube=false)

    # definisce funzione interna
      

    # chiama funzione interna
    # first run: ignore indexes ----
    auxconvert(in_file,out_folder,out_filebase,out_format,base_georef,fill_gaps,VNIR,
        SWIR,
        FULL,
        source,
        join_priority,
        ATCOR,
        ATCOR_wls,
        PAN,
        CLOUD,
        LC,
        GLINT,
        ANGLES,
        LATLON,
        ERR_MATRIX,
        apply_errmatrix,
        overwrite,
        in_L2_file,
        selbands_vnir,
        selbands_swir,
        indexes=NULL,
        cust_indexes=NULL,
        keep_index_cube=FALSE)

    # second run: create indexes -----
    # in this way we can use the same function,
    # and when creating indexes create a temporary full raster, containing  only
    # bands required for the selected indexes    
    if !isnothing(indexes)
      aux_convert(in_file,
                  out_folder,
                  out_filebase,
                  out_format,
                  base_georef,
                  fill_gaps,
                  VNIR = FALSE,
                  SWIR = FALSE,
                  FULL = FALSE,
                  source,
                  join_priority,
                  ATCOR = FALSE,
                  ATCOR_wls,
                  PAN = FALSE,
                  CLOUD = FALSE,
                  LC = FALSE,
                  GLINT = FALSE,
                  ANGLES = FALSE,
                  LATLON = FALSE,
                  ERR_MATRIX = FALSE,
                  apply_errmatrix,
                  overwrite,
                  in_L2_file,
                  selbands_vnir = NULL,
                  selbands_swir = NULL,
                  indexes       = indexes,
                  cust_indexes  = cust_indexes,
                  keep_index_cube = keep_index_cube)
    end
  end=#

end