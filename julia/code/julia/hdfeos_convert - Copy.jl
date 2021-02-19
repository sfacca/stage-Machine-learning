
######## porting in julia di https://github.com/lbusett/prismaread/blob/master/R/pr_convert.R

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

function seq_along(arr::Array{})
  res = [1:length(arr)...]
  res
end


function attachExtension!(outformat::String,path::String)
  if outformat == "GTiff"
    path = string(path,".tif")
  else
    path = string(path,".envi")
  end
  path
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

function aux_convert(in_file, out_folder,
  out_filebase, out_format, base_georef,
  fill_gaps, VNIR,
  SWIR, FULL,
  source, join_priority,
  ATCOR, ATCOR_wls,
  PAN, CLOUD,
  LC, GLINT,
  ANGLES, LATLON,
  ERR_MATRIX, apply_errmatrix,
  overwrite,in_L2_file,
  selbands_vnir, selbands_swir,
  indexes,
  cust_indexes,
  keep_index_cube)
  out_folder = string(out_folder,"/")
  ##NB: input_file dev esser già aperto, a diff di pr_convert
  proc_lev = getAttr(in_file,"Processing_Level")
  if out_filebase == "auto"
    out_filebase = "out/$in_file"
  end
  out_file = out_filebase
  
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
      #=
      vedere se riesci a fare un array data frame (per un pixel a scelta e 
      per più pixel a scelta sulla base delle coordinate) che riporti coordinate 
      pixel + banda (sia tutte sia a scelta dell'utente) + riflettanza; un 
      grafico x::bande y::riflettanza; [?esportazione poi in csv?]
      =#
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
if selbands_vnir!=nothing #selbands_vnir != ∅ #incerto
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
out_file_swir = attachExtension!(out_format,out_file_swir)  
else
out_file_swir=string(tempdir(),out_file,"_",source,".tif")
end     

if (SWIR || FULL )&&(selbands_swir==nothing||length(selbands_swir)!=0)
#procedura sotto è identica a quella nell if VNIR || FULL ma con swir invece che vnir 
# -> si può creare fun a parte per rimpicciolire codice
if isfile(out_file_swir) && overwrite == false
  println("SWIR file already exists - use overwrite = TRUE or change
              output file name to reprocess")
  # rast_swir = (funzione che prende filename o oggetto raster e ritorna ogg rasterstack)
  # raster stack ≈ raster dataset ?############# TODO, DA VEDERE SU pr_create_vnir 
else
  println("- Importing SWIR Cube - ") 
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
end
if selbands_swir!=nothing#selbands_swir != ∅ #incerto
  seqbands_swir = closestDistanceFunction(wl_swir).(selbands_swir)
  #fun ritorna una fun che viene applic a ogni elem di selbands_vnir
  #per ogni elemento di selbands_vnir ritorna, in un array, la distanza tra l elemento e la
  #banda più vicina ad esso in wl_vnir
else
  seqbands_swir =[1:173...]
  for i in i:173
    if wl_swir[i]==0
      seqbands_swir[i]=0      
    end
  end
  seqbands_swir = filter(x->x!=0,seqbands_swir)
  wl_swir = wl_swir[seqbands_swir]
  fwhm_swir = fwhm_swir[seqbands_swir]
end
# create FULL data cube and convert to raster ----
if FULL && indexes == nothing
out_file_full = string(out_folder,out_file,"_",source,"_FULL")
out_file_full = attachExtension!(out_format,out_file_full)

else
if keep_index_cube
  out_file_full = string(out_folder,out_file,"_",source,"_INDEXES")
  out_file_full = attachExtension!(out_format,out_file_full)
else
  out_file_full = string(tempdir(),out_file,"_",source,"_INDEXES",".tif")
end
end
# Create and write the FULL hyperspectral cube if needed ----
if FULL
if isfile(out_file_full) && overwrite==false
  println("FULL file already exists - use overwrite = TRUE or change
                output file name to reprocess")
else
  println("- Creating FULL raster -")
  # Save hyperspectral cube
  if isfile(out_file_vnir) && isfile(out_file_swir)
    #rast vnir = raster stack letto da out_file_vnir
    #rast_swir = raster stack letto da out_file_swir
    if join_priority == "SWIR"
      #rast_tot = crea raster sovrapponendo rast swir a rast vnir 
      #(toglie layer vnir con bande superiuori alla banda swir minore)
      aux_vnir = filter(x->x<min_swir,wl_vnir)
      wl_tot = vcat(aux_vnir,wl_swir)
      #wl tot = bande swir inferiori alla banda vnir minore + bande swir
      fwhm_tot = vcat(fwhm_vnir[aux_vnir],fwhm_swir)
      #mette nome ai layer(?) di rast_tot con pattern b[banda vnir]_v;b[banda swir]_s
    else
      # rast_tot = 
      #fa la stessa cosa ma, nelle sovrapposizioni delle bande, le bande vnir prendono 
      #precedenza sulle swir
      aux_swir = filter(x->x>max_vnir,wl_swir)
      wl_tot = vcat(wl_vnir,aux_swir)
      fwhm_tot = vcat(fwhm_vnir,fwhm_swir[aux_swir])
      #mette nome ai layer(?) di rast_tot con pattern b[banda vnir]_v;b[banda swir]_s      
    end
    println("- Writing FULL raster -")
    pr_rastwrite_lines(rast_tot, out_file_full, out_format, proc_lev,
                            join = TRUE)#########TODO
    rast_vnir = nothing
    rast_swir = nothing
    #garbage collect todo
  elseif isfile(out_file_vnir)&& isfile(out_file_swir)==false
    #legge raster stack da out_file_vnir e lo carica in rast_vnir
    println("SWIR file not created - FULL file will be equal to VNIR
                  one")
    cp(out_file_vnir,out_file_full,force=true)
    rast_tot = rast_vnir
    wl_tot = wl_vnir
    fwhm_tot = fwhm_vnir
  elseif isfile(out_file_swir) && isfile(out_file_vnir)==false
    #rast_swir = raster stack da file out_file_swir
    println("VNIR file not created - FULL file will be equal to SWIR
                  one")
    cp(out_file_swir,out_file_full,force=true)
    rast_tot = rast_swir
    wl_tot = wl_swir
    fwhm_tot = fwhm_swir
  else
    @warn "FULL file not created because neither SWIR nor VNIR created"
  end
  # Write ENVI header if needed ----
  if out_format == "ENVI"##############DA CONTROLLARE
    out_hdr = string(out_file_full,".hdr")
    myHdr = string("band names = {", join(names(rast_tot),","),"}","\n")#stringa header
    write(out_hdr, myHdr)
    write(out_hdr,
      string(  
        "wavelength = {", join(wl_tot,",") , "}"
      ))
    write(out_hdr,
      string(
        "fwhm = {", join(fwhm_tot,","), "}","\n"
      )
    )
    write(out_hdr,"wavelength units = Nanometers")
    write(out_hdr,"sensor type = PRISMA")
  end
  out_file_txt = string(out_file_full,".wvl")
  CSV.write(out_file_txt,
    DataFrame(
      band=seq_along(wl_tot),
      orband = names(rast_tot)[2:length(names(rast_tot))],
      wl = wl_tot,
      fwhm = fwhm_tot
      )#string as factors = false?
    )
  rast_tot = nothing
  #garbage collect here
end
# If only FULL selected, remove files related to VNIR and sWIR cubes if
      # existing
if !VNIR
  rm(out_file_vnir)
end
if !SWIR
  rm(out_file_swir)
end

if indexes!=nothing || cust_indexes!=nothing
  # now COMPUTE INDExEs if necessary ----
  pr_compute_indexes(in_file  = out_file_full,
                        out_file= out_file,
                        out_format = out_format,
                        indexes  = indexes,
                        cust_indexes = cust_indexes,
                        overwrite = overwrite)
end

end
# Save PAN if requested ----
out_file_pan = string(out_folder,out_file,"_",source,"_PAN")
attachExtension!(out_format,out_file_pan)
if isfile(out_file_pan) && overwrite==false
println("PAN file already exists - use overwrite = TRUE or change output
            file name to reprocess")
else
if PAN
  pr_create_pan(f,
                    proc_lev,
                    source,
                    out_file_pan,
                    out_format,
                    base_georef,
                    fill_gaps,
                    in_L2_file = in_L2_file)
end
end
# Save LATLON if requested ----

out_file_latlon = string(out_folder,out_file,"_",source,"_LATLON")
attachExtension!(outformat,out_file_latlon)

if isfile(out_file_latlon)
println("LATLON file already exists - use overwrite = TRUE or change ",
"output file name to reprocess")
else
if LATLON
  pr_create_latlon(f,
                      proc_lev,
                      out_file_latlon,
                      out_format,
                      base_georef,
                      fill_gaps,
                      in_L2_file = in_L2_file)
end
end

if proc_lev in ["2B", "2C", "2D"] || ( proc_lev =="1" && in_L2_file!=nothing )
# Save ANGLES if requested ----
out_file_ang = string(out_folder,out_file,"_",source,"_ANG")
attachExtension!(outformat,out_file_ang)
if isfile(out_file_ang) && overwrite == false
  println("ANG file already exists - use overwrite = TRUE or change ",
  "output file name to reprocess")
else
  if ANGLES
    pr_create_angles(f,
                        proc_lev,
                        out_file_ang,
                        out_format,
                        base_georef,
                        fill_gaps,
                        in_L2_file = in_L2_file)
  end
end
end

if proc_lev == 1 ####### ATTENZIONE: proc_lev trattato come string in altri if ma come int qua?
# Save CLD if requested ----
out_file_cld = string(out_folder,out_file,"_",source,"_CLD")
attachExtension!(outformat,out_file_cld)
if isfile(out_file_cld)
  println("CLD file already exists - use overwrite = TRUE or change ")
  println("output file name to reprocess")
else
  if CLOUD
    pr_create_additional(f,
                            type = "CLD",
                            out_file_cld,
                            out_format,
                            base_georef,
                            fill_gaps,
                            in_L2_file = in_L2_file)
  end
end
# Save GLINT if requested ----
out_file_glnt = string(out_folder,out_file,"_",source,"_GLINT")
attachExtension!(out_format,out_file_glnt)

if isfile(out_file_glnt) && overwrite==false
  println("GLINT file already exists - use overwrite = TRUE or change 
    output file name to reprocess")
else
  if GLINT
    pr_create_additional(f,
                            type = "GLINT",
                            out_file_glnt,
                            out_format,
                            base_georef,
                            fill_gaps,
                            in_L2_file = in_L2_file)
  end
end
# Save LC if requested ----
out_file_lc = string(out_folder,out_file,"_",source,"_LC")
attachExtension!(out_format,out_file_lc)
if LC
  if isfile(out_file_lc) && overwrite==false
    println("LC file already exists - use overwrite = TRUE or change 
    output file name to reprocess")
  else
    pr_create_additional(f,
                            type = "LC",
                            out_file_lc,
                            out_format,
                            base_georef,
                            fill_gaps,
                            in_L2_file = in_L2_file)
  end
end
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

    #definisce funzione interna
    

  #chiama funzione interna
  # first run: ignore indexes ----
  convert(in_file,out_folder,out_filebase,out_format,base_georef,fill_gaps,VNIR,
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
      indexes       = NULL,
      cust_indexes  = NULL,
      keep_index_cube = FALSE)

    #=
    

  .pr_convert(in_file,
              out_folder,
              out_filebase,
              out_format,
              base_georef,
              fill_gaps,
              VNIR,
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
              indexes       = NULL,
              cust_indexes  = NULL,
              keep_index_cube = FALSE)

  # second run: create indexes -----
  # in this way we can use the same function,
  # and when creating indexes create a temporary full raster, containing  only
  # bands required for the selected indexes

  if (!is.null(indexes)) {

    .pr_convert(in_file,
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
  }

=#
      
    
    
end


end