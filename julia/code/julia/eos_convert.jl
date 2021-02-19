module eos_convert

  export maketif

  include("faux.jl")
  include("eos_create_FULL.jl")
  include("eos_create_pan.jl")
  include("eos_create.jl")
  using HDF5
  using CSV# per leggere tabella indexes_list.txt
  using DataFrames
  using DataFramesMeta
  using ArchGDAL


  

  
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

  function maketif(in_file,##NB: in_file dev esser già aperto, a diff di pr_convert
      out_file::String;
      allowed_errors = nothing,
      source="HCO",
      PAN=true,#boolean: true-> crea tif pancromatico
      VNIR=true,#boolean: true-> crea tif cubo vnir
      SWIR=true, #boolean: true-> crea tif pancromatico
      FULL=true,#boolean: true-> crea tif pancromatico
      join_priority="VNIR",
      overwrite=false,
      selbands_vnir=nothing,
      selbands_swir=nothing,
      indexes=nothing,
      cust_indexes=nothing)


    @show out_folder = faux.dirname(out_file)
    println("creating folder $out_folder")
    mkpath(out_folder)
    println("made folder")


    basefile = faux.fileSansExt(out_file)

    ##raccolta attributi
    println("loading attributes...")
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


    #type check selbands
    if !isnothing(selbands_vnir) && typeof(selbands_vnir[1])!= Float32
      selbands_vnir = Base.convert(Array{Float32,1},selbands_vnir)
    end
    if !isnothing(selbands_swir) && typeof(selbands_swir[1])!= Float32
      selbands_swir = Base.convert(Array{Float32,1},selbands_swir)
    end


    # create the "META" ancillary txt file----
    out_file_angles = string(basefile, "_ANGLES.txt")
    ang_df = DataFrame(date=acqtime, sunzen=sunzen, sunaz=sunaz)
    CSV.write(out_file_angles, ang_df)


    # get VNIR data cube and convert to raster ----
    if VNIR
      println("building VNIR raster...")
      out_file_vnir = create_cube(in_file,proc_lev,source,basefile,wl_vnir,order_vnir,fwhm_vnir;
        overwrite =overwrite,type="VNIR",selbands=selbands_vnir, allowed_errors=allowed_errors)
    end



    # get SWIR data cube and convert to raster ----
    if SWIR
      println("building VNIR raster...")
      out_file_swir = create_cube(in_file,proc_lev,source,basefile,wl_swir,order_swir,fwhm_swir;
        overwrite =overwrite,type="SWIR",selbands=selbands_swir, allowed_errors=allowed_errors)
    end



    #    Create and write the FULL hyperspectral cube if needed ----
    if FULL
      #get geo
      geo = eos_geoloc.get(in_file,"VNIR")#
      out_file_full = create_full(basefile,join_priority,overwrite,geo)
    end


    # Save PAN if requested ----
    if PAN
      out_file_pan = create_pan(in_file,proc_lev,basefile;overwrite=overwrite)
    end

  end

end
