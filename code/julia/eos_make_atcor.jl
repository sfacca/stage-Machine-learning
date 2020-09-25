module make_atcor

include("faux.jl")
using CSV
using DataFrames
using HDF5


export make_atcor
#fun ausiliaria per creaz file necessari per correz atmosf
#ATmospheric CORrection

function make_atcor(f,#file aperto di un hdf
    out_folder,#path a folder output, termina in /
    out_file,#nome base file outpu
    ATCOR_wls::Union{Nothing,Array{Number,1}},#
    wls::Array{Float32,1},#array di wavelengths
    fwhms::Array{Float32,1},#array di fwhms
    order_vnir,#ordine dell array di wvl vnir
    order_swir,
    join_priority::String,#eg: join_priority == VNIR se VNIR sovrascrivono SWIR
    source)#string ["HC0" | "HRC"], Considered Data Cub
    ATCOR_fold = string(out_folder,"ATCOR/")
    out_file_wvl = string(ATCOR_fold,out_file,"_atcor_wvl_nominal.wvl")
    mkpath(ATCOR_fold)
    wl_tot_atcor   = filter(x->x!=0,wls)
    fwhm_tot_atcor = filter(x->x!=9,fwhms)

    #crea e savla dataframe wavelengths
    out = DataFrame(
        channel_number = faux.seq_along(wl_tot_atcor),
        channel_center_wavelength = round.(wl_tot_atcor/1000,digits=6),
        bandwidth = fwhm_tot_atcor)#stringasvectors?
    rename!(out,["channel number","channel center wavelength","bandwidth"])
    CSV.write(out_file_wvl,out)

    #crea, salva dataframe wvl /1000 (?)
    out_file_cal = string(ATCOR_fold,out_file,"_atcor_cal.cal")
    out = DataFrame(
        wavelengths = round(wl_tot_atcor/1000,digits=6),
        radiometric_offset_c0 = 0,#<=============== dato hc?
        radiometric_offset_c1 = 1#<=============== dato hc?
    )
    rename!(out,["wavelengths","radiometric offset c0","radiometric offset c1"])
    CSV.write(out_file_cal,out)

    out_file_dat = string(ATCOR_fold,out_file,"atcor_dat.dat")
    download("https://github.com/lbusett/prismaread/raw/master/inst/extdata/atcor_dat.dat",out_file_dat)#<==========dati specifici prisma
    
    # if specified, save additional wvl files corresponding to selected ----
    # columns

    if ATCOR_wls!=nothing
        if source != "HCO"
            if HDF5.exists(file,"//KDP_AUX/Cw_Vnir_Matrix")
                ##typecheck su ATCOR_wls è come definizione di tipo del parametro

                #ATTENZONE: questi parametri sono solo presenti in prodotti a lvl1!
                if faux.getAttr(f,"Processing_Level")==1#file è lvl 1
                    vnir_start = faux.getAttr(f, "Start_index_EO_VNIR")#sono numeri Uint8
                    vnir_stop   = faux.getAttr(f, "Stop_index_EO_VNIR")
                    swir_start  = faux.getAttr(f, "Start_index_EO_SWIR")
                    swir_stop   = faux.getAttr(f, "Stop_index_EO_SWIR")
                    #todo: fare/trovare funzione per estrarre dataset da hdf5 in maniera ordinata
                    #vnir_wl_mat = matrice presa da file/kdp_Aux/cw_vnir_matrix
                    #vnir_wl_mat = riordina righe seguendo order_vnir

                #=vnir_wl_mat <- t(f[["//KDP_AUX/Cw_Vnir_Matrix"]]
                                 [vnir_start:vnir_stop,])
                vnir_wl_mat = vnir_wl_mat[,order_vnir]
                vnir_wl_mat <- vnir_wl_mat[, which(vnir_wl_mat[1,] != 0)]
                vnir_fwhm_mat <- t(f[["KDP_AUX/Fwhm_Vnir_Matrix"]]
                                  # [vnir_start:vnir_stop,])
                vnir_fwhm_mat <- vnir_fwhm_mat[,order_vnir]
                vnir_fwhm_mat <- vnir_fwhm_mat[, which(vnir_fwhm_mat[1,] != 0)]
                
                
                swir_wl_mat <- t(f[["//KDP_AUX/Cw_Swir_Matrix"]]
                                 [swir_start:swir_stop,])
                swir_wl_mat <- swir_wl_mat[,order_swir]
                swir_wl_mat <- swir_wl_mat[, which(swir_wl_mat[1,] != 0)]
                swir_fwhm_mat <- t(f[["//KDP_AUX/Fwhm_Swir_Matrix"]]
                                   [swir_start:swir_stop,])
                swir_fwhm_mat <- swir_fwhm_mat[,order_swir]
                swir_fwhm_mat <- swir_fwhm_mat[, which(swir_fwhm_mat[1,] != 0)]
                =#
                else #file NON è lvlk1

                end#fine parte per file non lvl 1

            end
        end#fine if source != hco
    end#fine id atcor_wls != nothing

    
#=      

    if (!is.null(ATCOR_wls)) {

        if (source != "HCO") {

            if (hdf5r::existsGroup(f, "//KDP_AUX/Cw_Vnir_Matrix")) {

                if (!is.numeric(ATCOR_wls)) {
                    stop("ATCOR_wls should be either NULL or a vector ",
                         "containing the column numbers at which wavelengths ",
                         "should be retrieved")
                }

                vnir_start  <- hdf5r::h5attr(f, "Start_index_EO_VNIR")
                vnir_stop   <- hdf5r::h5attr(f, "Stop_index_EO_VNIR")
                vnir_wl_mat <- t(f[["//KDP_AUX/Cw_Vnir_Matrix"]]
                                 [vnir_start:vnir_stop,])
                vnir_wl_mat <- vnir_wl_mat[,order_vnir]
                vnir_wl_mat <- vnir_wl_mat[, which(vnir_wl_mat[1,] != 0)]
                vnir_fwhm_mat <- t(f[["KDP_AUX/Fwhm_Vnir_Matrix"]]
                                   [vnir_start:vnir_stop,])
                vnir_fwhm_mat <- vnir_fwhm_mat[,order_vnir]
                vnir_fwhm_mat <- vnir_fwhm_mat[, which(vnir_fwhm_mat[1,] != 0)]

                swir_start  <- hdf5r::h5attr(f, "Start_index_EO_SWIR")
                swir_stop   <- hdf5r::h5attr(f, "Stop_index_EO_SWIR")
                swir_wl_mat <- t(f[["//KDP_AUX/Cw_Swir_Matrix"]]
                                 [swir_start:swir_stop,])
                swir_wl_mat <- swir_wl_mat[,order_swir]
                swir_wl_mat <- swir_wl_mat[, which(swir_wl_mat[1,] != 0)]
                swir_fwhm_mat <- t(f[["//KDP_AUX/Fwhm_Swir_Matrix"]]
                                   [swir_start:swir_stop,])
                swir_fwhm_mat <- swir_fwhm_mat[,order_swir]
                swir_fwhm_mat <- swir_fwhm_mat[, which(swir_fwhm_mat[1,] != 0)]

                if(join_priority == "VNIR") {
                    swir_wl_mat   <- swir_wl_mat[,which(
                        swir_wl_mat[1,] > max(vnir_wl_mat[1,]))]
                    swir_fwhm_mat <- swir_fwhm_mat[,which(
                        swir_wl_mat[1,] > max(vnir_wl_mat[1,]))]
                } else {
                    vnir_wl_mat   <- vnir_wl_mat[,which(
                        vnir_wl_mat[1,] < min(swir_wl_mat[1,]))]
                    vnir_fwhm_mat <- vnir_fwhm_mat[,which(
                        vnir_wl_mat[1,] < min(swir_wl_mat[1,]))]
                }

                wl_mat_tot    <- cbind(vnir_wl_mat, swir_wl_mat )
                fwhm_mat_tot  <- cbind(vnir_fwhm_mat, swir_fwhm_mat )

                for (col in ATCOR_wls) {
                    dir.create(file.path(ATCOR_fold, trimws(col)),
                               showWarnings = FALSE)
                    out_file_wvl <- file.path(
                        ATCOR_fold, trimws(col),
                        paste0(tools::file_path_sans_ext(basename(out_file)),
                               paste0("_atcor_wvl_", trimws(col), ".wvl")))
                    out <- data.frame(
                        `channel number`            = 1:dim(wl_mat_tot)[2],
                        `channel center wavelength` = round(
                            wl_mat_tot[col,]/1000, digits = 6),
                        `bandwidth` = round(fwhm_mat_tot[col,], digits = 6),
                        stringsAsFactors = FALSE)
                    names(out) <- paste(c("channel number",
                                          "channel center wavelength",
                                          "bandwidth"), col)
                    utils::write.table(out, file = out_file_wvl,
                                       row.names = FALSE, sep = "\t")

                    out_file_cal <- file.path(
                        ATCOR_fold, trimws(col),
                        paste0(tools::file_path_sans_ext(basename(out_file)),
                               "_atcor_cal.cal"))
                    out <- data.frame("wavelength" = round(
                        wl_mat_tot[col,]/1000, digits = 6),
                        `radiometric offset c0` = 0,
                        `radiometric offset c1` = 1, stringsAsFactors = FALSE)
                    names(out) <- c("wavelength",
                                    "radiometric offset c0 ",
                                    "radiometric offset c0")
                    utils::write.table(out, file = out_file_cal,
                                       row.names = FALSE, sep = "\t")

                    out_file_dat <- file.path(
                        ATCOR_fold, trimws(col),
                        paste0(tools::file_path_sans_ext(basename(out_file)),
                               "atcor_dat.dat"))
                    file.copy(system.file("extdata/atcor_dat.dat",
                                          package = "prismaread"),
                              out_file_dat)
                }
            } else {
                message("CW matrix dataset not existing - creation of ",
                        "additional ATCOR files ignored")
            }
        } else {
            message("Creation of ATCOR files related to specific columns is ",
                    "only useful for HRC datasets - creation of additional ",
                    "ATCOR files skipped ")
        }
    }
}

=#
end#fine make_atcor

end#fine modulo



