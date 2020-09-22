module hdfeos

export convert, getAttr

using HDF5


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
    if (!is.nothing(indexes) | !is.nothing(cust_indexes)) {

        if (proc_lev %in% c("1", "2B")){
  
          warning("Spectral indexes are usually meant to be computed on ",
                  "reflectance data. Proceed with caution!")
  
        }
  
        index_list <- read.table(system.file("extdata/indexes_list.txt",
                                             package = "prismaread"), sep = "\t",
                                 header = TRUE)
        av_indexes <- as.list(index_list$Formula)
        names(av_indexes) <- index_list$Name
  
        sel_indexes <- which(names(av_indexes) %in% indexes)
        tot_indexes <- c(av_indexes[sel_indexes], cust_indexes)
  
        # when computing indexes, find out the required wavelengths
        # on vnir and swir
        getwls <- function(x) {
          substring(stringr::str_extract_all(x, "R[0-9,.]*")[[1]],2,100)
        }
        req_wls <- sort(as.numeric(
          unique(unlist((lapply(tot_indexes, FUN = function(x) getwls(x)))))))
  
        selbands_vnir <- req_wls[req_wls <= max(wl_vnir)]
        selbands_swir <- req_wls[req_wls >= min(wl_swir[wl_swir != 0])]
  
        if (any(selbands_swir %in% selbands_vnir)) {
          if (join_priority == "VNIR") {
            selbands_swir <- selbands_swir[selbands_swir >= max(wl_vnir)]
          } else {
            selbands_vnir <- selbands_vnir[selbands_vnir <=
                                             min(wl_swir[wl_swir != 0])]
          }
        }
  
        FULL <- TRUE
      }
    
    
end

end