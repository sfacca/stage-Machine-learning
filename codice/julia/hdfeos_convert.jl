module hdfeos

export convert, getAttr

using HDF5
using CSV#per leggere tabella indexes_list.txt
using DataFrames
using DataFramesMeta
using ArchGDAL

function extractWvl(str::String)#prende stringa, ritorna array di int 
    currnum = ""
    res::Array{Int,1}=[]
    intc = ['1','2','3','4','5','6','7','8','9','0']
    afterR = false
    for char in str 
      if afterR

        if char in intc
          currnum = currnum*10
          currnum = currnum + parse(Int,char)             
                  
        else
          push!(res,currnum)
          currnum=0
          afterR = false
        end
           
      end
      if char == 'R'
        afterR = true
      end
    end
    push!(res,currnum)  
    res
  end

function checkCommon(x::Array{Int,1},y::Array{Int,1})#NB: x,y SORTED in maniera crescente, unici, ritorna true se almeno un elem di x è in y
  res = false
  i = 1
  for elemx in x

    while elemx > y[i] && i < length(y)#se elem di x è maggiore dell elem di y, scorro y
      i = i+1
    end    

    if elemx == y[i]#se elemx = elemy -> interrompo ciclo ritornano true
      res = true
      break
    end

    #se elemx < elemy, scorro x
  end
  res# se non ho trovato uguali, res è ancora false
end
# O(length(x)+length(y))  
function closestDistanceFunction(wvl::Array{Int64,1})
  (x)->(minimum(abs.(wvl.-x)))
end

function closestWvl(wvl::Array{Int64,1},x::Int64)
  y = abs.(wvl.-x)
  #lapply(selbands_vnir, FUN = function(x) which.min(abs(wl_vnir - x))))
  minimum(abs.(wvl.-x))
end

    


function getAttr(file, name::String)
    # name è attributo globale del file(aperto) hdf5 file
    # ritorna campo valore name
    atts = attrs(file)
    content = read(atts, name)
    content
end

function convert(in_file,
    out_folder,
    out_filebase    = "auto",
    out_format      = "ENVI",
    base_georef     = true,
    fill_gaps       = false,
    VNIR            = false,
    SWIR            = false,
    FULL            = false,
    source          = "HCO",
    join_priority   = "SWIR",
    ATCOR           = false,
    ATCOR_wls       = nothing,
    PAN             = false,
    CLOUD           = false,
    LC              = false,
    GLINT           = false,
    ANGLES          = false,
    LATLON          = false,
    ERR_MATRIX      = false,
    apply_errmatrix = false,
    overwrite       = false,
    in_L2_file      = nothing,
    selbands_vnir   = nothing,
    selbands_swir   = nothing,
    indexes         = nothing,
    cust_indexes    = nothing,
    keep_index_cube = false)
    ##NB: input_file dev esser già aperto, a diff di pr_convert
    proc_lev = getAttr(in_file,"Processing_Level")
    if out_filebase == "auto"
      out_filebase = "out/$in_file"
    end
    
    # Get wavelengths and fwhms ----
    wl_vnir=getAttr(in_file,"List_Cw_Vnir")
    wl_swir=getAttr(in_file,"List_Cw_Swir")
    fwhm_vnir=getAttr(in_file,"List_Fwhm_Vnir")
    fwhm_swir=getAttr(in_file,"List_Fwhm_Swir")

    # get additional metadata
    sunzen  = getAttr(f, "Sun_zenith_angle")
    sunaz  = getAttr(f, "Sun_azimuth_angle")
    acqtime  = getAttr(f, "Product_StartTime")
    
    #riordinazioni
    order_vnir=sortperm(wl_vnir)#permut
    wl_vnir=wl_vnir[order_vnir]    
    order_swir=sortperm(wl_swir)
    wl_swir=wl_swir[order_swir]      
    fwhm_vnir=fwhm_vnir[order_vnir]    
    fwhm_swir=fwhm_swir[order_swir]
    #join
    fwhms=vcat(fwhm_vnir, fwhm_swir)
    wls=vcat(wl_vnir, wl_swir)

    # If indexes need to be computed, retrieve the list of VNIR and SWIR ----
    # wavelengths required for the computataion and automatically fill
    # the selbands_vnir and selbands_swir variables
    if indexes!=nothing | cust_indexes!=nothing 

        if proc_lev in [c"1", "2B"]
          @warn "Spectral indexes are usually meant to be computed on "
          @warn  "reflectance data. Proceed with caution!"
        end
        
        
        mkpath("downloads")
        download("https://github.com/sfacca/stage-Machine-learning/raw/master/extdata/md_indexes_list.txt",
          "downloads/indexes_list.txt")
        index_list = CSV.read("downloads/indexes_list.txt")
        select!(index_list, Not(:id))

        #av_indexes= index_list[:Formula]
        #########################################################################
        av_indexes= select(index_list, [:Name,:Formula])        
        sel_indexes = filter(row -> row.Name ∈ indexes, av_indexes)#filter è poco performante?
        tot_indexes = vcat(sel_indexes,cust_indexes)
  
        # when computing indexes, find out the required wavelengths
        # on vnir and swir

        #req_wls : array di int unici, in ordine cresc, ogni int è il numero di una banda dalle formula di tot_indexes
        req_wvl = sort(unique(vcat(extractWvl.(tot_indexes[:Formula])...)))#req_wvl IS SORTED      
        max_vnir = maximum(wl_vnir)#var ausiliaria
        min_swir = minimum(filter(item -> item !=0,wl_swir))#var ausiliaria
        selbands_vnir = filter(item -> item <= max_vnir,req_wls)#bande minori della banda vnir + alta
        selbands_swir = filter(item -> item >= min_swir,req_wls)#bande maggiori della banda swir non0 più piccola
        

        if checkCommon(selbands_swir,selbands_vnir)# if selected vnir bands overlap selected swir bands:
          if (join_priority == "VNIR")#parametro di input
            selbands_swir = filter(item-> item >= max_vnir,selbands_swir)# selbands_swir sono solo quelle + grandi del vnir maggiore
          else 
            selbands_vnir = filter(item-> item <= min_swir,selbands_vnir)# bande vnir selez sono solo quelle minori della swir minore
          end
        end     
        FULL = true
      end

      # write ATCOR files if needed ----
    if ATCOR == TRUE && proc_lev == "1"
      pr_make_atcor(f,
                    out_file,
                    ATCOR_wls,
                    wls,
                    fwhms,
                    order_vnir,
                    order_swir,
                    join_priority,
                    source)
    end
    ################# todo: convert pr_make_atcor

    #create the "META" ancillary txt file----   
    out_file_angles = string(out_folder,out_file,source,"_ANGLES.txt")
    ang_df = DataFrame(date = acqtime,sunzen = sunzen,sunaz = sunaz)
    CSV.write(out_file_angles,ang_df,delim=' ',quotechar='"',quotestrings=true)

    # get VNIR data cube and convert to raster ----
    if VNIR
      out_file_vnir = string(out_folder,out_file,source_"_VNIR")
      if out_format=="GTiff"
        out_file_vnir=string(out_file_vnir,".tif")
      else
        out_file_vnir=string(out_file_vnir,".envi")
      end
    else
      out_file_vnir = string(tempdir(),out_file,source_"_VNIR", ".tif")   #######TEMPDIR LIFETIME?   
    end


    if VNIR || FULL
      println("- Importing VNIR Cube -")
      if isfile(out_file_vnir) && overwrite != true
        println("VNIR file already exists - use overwrite = TRUE or change
        output file name to reprocess")
        # rast_vnir = (funzione che prende filename o oggetto raster e ritorna ogg rasterstack)
        # raster stack ≈ raster dataset ?############# TODO, DA VEDERE SU pr_create_vnir
      else
        pr_create_vnir(f,
          proc_lev,
          source,
          out_file_vnir,
          out_format,
          base_georef,
          fill_gaps,
          wl_vnir,
          order_vnir,
          fwhm_vnir,
          apply_errmatrix,
          ERR_MATRIX,
          selbands_vnir = selbands_vnir,
          in_L2_file = in_L2_file)
      end ################# todo: convert pr_create_vnir
    end
# Build array of effectively processed bands/wl/fwhm  ----
if selbands_vnir != ∅ #incerto
  seqbands_vnir = closestDistanceFunction(wl_vnir).(selbands_vnir)#fun ritorna una fun che viene applic a ogni elem di selbands_vnir
  #per ogni elemento di selbands_vnir ritorna, in un array, la distanza tra l elemento e la
  #banda più vicina ad esso in wl_vnir
else
  seqbands_vnir = [1:66...]
  for i in i:66
    if wl_vnir[i]==0
      seqbands_vnir[i]=0      
    end
  end
  seqbands_vnir = filter(x->x!=0,seqbands_vnir)
  #1. crea array seqbands_vnir = 1:66
  #2. se wl_vnir[i] ==0 -> seqbands_vnir[i] = 0
  #3. rimuovi tutti gli elem == 0 da seqbands_vnir
end

wl_vnir = wl_vnir[seqbands_vnir]
fwhm_vnir = fwhm_vnir[seqbands_vnir]

# get SWIR data cube and convert to raster ----   
if SWIR
  out_file_swir = string(out_folder,out_file,"_",source,"_SWIR")
  if out_format =="GTiff"
    out_file_swir = string(out_file_swir,".tiff")
  else
    out_file_swir = string(out_file_swir,".envi")
  end
else
  out_file_swir=string(tempdir(),out_file,"_",source,".tif")
end     


#=
   if ((SWIR | FULL) &&
        (is.null(selbands_swir) | length(selbands_swir) != 0)) {
      if (file.exists(out_file_swir) & !overwrite) {
        message("SWIR file already exists - use overwrite = TRUE or change
                output file name to reprocess")
        rast_swir <- raster::stack(out_file_swir)
      } else {

        message("- Importing SWIR Cube - ")
        pr_create_swir(f,
                       proc_lev,
                       source,
                       out_file_swir,
                       out_format,
                       base_georef,
                       fill_gaps,
                       wl_swir,
                       order_swir,
                       fwhm_swir,
                       apply_errmatrix,
                       ERR_MATRIX,
                       selbands_swir = selbands_swir,
                       in_L2_file = in_L2_file)
      }

      if (!is.null(selbands_swir)){
        seqbands_swir <- unlist(lapply(
          selbands_swir, FUN = function(x) which.min(abs(wl_swir - x))))
      } else {
        seqbands_swir <- (1:173)[wl_swir != 0]
      }
      wl_swir   <- wl_swir[seqbands_swir]
      fwhm_swir <- fwhm_swir[seqbands_swir]
    }
=#
      
    
    
end


end