
include("faux.jl")
using CSV
using DataFrames
using HDF5

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

    proc_level = faux.getAttr(f, "Processing_Level")
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

    if !isnothing(ATCOR_wls)
        if source != "HCO"
            if HDF5.exists(file,"//KDP_AUX/Cw_Vnir_Matrix")
                ##typecheck su ATCOR_wls è come definizione di tipo del parametro


                #ATTENZONE: questi parametri sono solo presenti in prodotti a lvl1!
                if proc_level==1#file è lvl 1
                    vnir_start = faux.getAttr(f, "Start_index_EO_VNIR")#sono numeri Uint8
                    vnir_stop   = faux.getAttr(f, "Stop_index_EO_VNIR")
                    swir_start  = faux.getAttr(f, "Start_index_EO_SWIR")
                    swir_stop   = faux.getAttr(f, "Stop_index_EO_SWIR")
                    vnir_wl_mat = faux.getData(file, "//KDP_AUX/Cw_Vnir_Matrix")#prendo matrice intera NB: molti 0, sparse?
                    vnir_wl_mat = vnir_wl_mat[vnir_start:vnir_stop,:]# solo righe vnir
                    vnir_wl_mat = vnir_wl_mat[:,order_vnir]#ordino colonne secondo order_vnir
                    vnir_wl_mat = vnir_wl_mat[:,(vnir_wl_mat[1,:].!=0)]#tolgo colonne che inzian con 0
                    #stessa cosa per vnir fwhm
                    vnir_fwhm_mat = faux.getData(file, "KDP_AUX/Fwhm_Vnir_Matrix")#prendo matrice intera NB: molti 0, sparse?
                    vnir_fwhm_mat = vnir_fwhm_mat[vnir_start:vnir_stop,:]# solo righe vnir
                    vnir_fwhm_mat = vnir_fwhm_mat[:,order_vnir]#ordino colonne secondo order_vnir
                    vnir_fwhm_mat = vnir_fwhm_mat[:,(vnir_fwhm_mat[1,:].!=0)]#tolgo colonne con i dove [1,i]==0
                    #stessa cosa per swir
                    swir_wl_mat = faux.getData(file, "//KDP_AUX/Cw_Swir_Matrix")
                    swir_wl_mat = swir_wl_mat[swir_start:swir_stop,:]
                    swir_wl_mat = swir_wl_mat[:,order_swir]
                    swir_wl_mat = swir_wl_mat[:,(swir_wl_mat[1,:].!=0)]
                    swir_fwhm_mat = faux.getData(file, "//KDP_AUX/Fwhm_Swir_Matrix")
                    swir_fwhm_mat = swir_fwhm_mat[swir_start:swir_stop,:]
                    swir_fwhm_mat = swir_fwhm_mat[:,order_swir]
                    swir_fwhm_mat = swir_fwhm_mat[:,(swir_fwhm_mat[1,:].!=0)]
                
                else #file NON è lvlk1
                    vnir_wl_mat = faux.getData(file, "//KDP_AUX/Cw_Vnir_Matrix")#prendo matrice intera NB: molti 0, sparse? 
                    # tolgo righe 0
                    vnir_wl_mat = faux.matCrop(vnir_wl_mat)
                    vnir_wl_mat = vnir_wl_mat[order_vnir,:]#ordino righe secondo order_vnir
                    v#nir_wl_mat = vnir_wl_mat[:,(vnir_wl_mat[1,:].!=0)]
                    #stessa cosa per vnir fwhm
                    vnir_fwhm_mat = faux.getData(file, "KDP_AUX/Fwhm_Vnir_Matrix")#prendo matrice intera NB: molti 0, sparse?
                    # tolgo righe 0
                    vnir_fwhm_mat = faux.matCrop(vnir_fwhm_mat)
                    vnir_fwhm_mat = vnir_fwhm_mat[order_vnir,:]#ordino colonne secondo order_vnir
                    #vnir_fwhm_mat = vnir_fwhm_mat[:,(vnir_fwhm_mat[1,:].!=0)]
                    #stessa cosa per swir
                    swir_wl_mat = faux.getData(file, "//KDP_AUX/Cw_Swir_Matrix")
                    # tolgo righe 0
                    swir_wl_mat = faux.matCrop(swir_wl_mat)
                    swir_wl_mat = swir_wl_mat[order_swir,:]
                    #swir_wl_mat = swir_wl_mat[:,(swir_wl_mat[1,:].!=0)]
                    swir_fwhm_mat = faux.getData(file, "//KDP_AUX/Fwhm_Swir_Matrix")
                    # tolgo righe 0
                    #swir_fwhm_mat = swir_fwhm_mat[:,(swir_fwhm_mat[1,:].!=0)] funzione è più veloce
                    swir_fwhm_mat = faux.matCrop(swir_fwhm_mat)
                    swir_fwhm_mat = swir_fwhm_mat[order_swir,:]
                    
                end#fine parte per file non lvl 1
                #parte comune
                if join_priority=="VNIR"
                    max_vnir_wl_col = maximum(vnir_wl_mat[:,1])
                    #toglie righe il cui primo elem è minuguale del primo elem righe vnir massimo
                    swir_fwhm_mat = swir_fwhm_mat[(swir_wl_mat[:,1] .>max_vnir_wl_col),:]
                    swir_wl_mat = swir_wl_mat[(swir_wl_mat[:,1].>max_vnir_wl_col),:]
                    
                else #se priority non è vnir sovrascrive vnir
                    min_swir_wl_col = minimum(swir_wl_mat[:,1])
                    vnir_fwhm_mat = vnir_fwhm_mat[(vnir_wl_mat[:,1].<min_swir_wl_col),:]
                    vnir_wl_mat = vnir_wl_mat[(vnir_wl_mat[:,1].<min_swir_wl_col),:]
                    

                end #fine parte per sovrascrivere con priorità

                #ingloba vnir swir in matrici uniche
                wl_mat_tot = vcat(vnir_wl_mat, swir_wl_mat)
                fwhm_mat_tot = vcat(vnir_fwhm_mat, swir_fwhm_mat)
                
                for col in ATCOR_wls
                    mkpath(string(ATCOR_fold,strip(col)))
                    out_file_wvl = string(ATCOR_fold, strip(col),out_file,"_atcor_wvl_",strip(col),".wvl")
                    out = DataFrame(
                        channel_number = 1:length(wl_mat_tot[:,:]),#numero righe wl mat tot
                        channel_center_wavelength = round(wl_mat_tot[col,:]/1000, digits=6),
                        bandwidth = round(fwhm_mat_tot[col,:], digits = 6)
                    )
                    rename!(out,["channel number $col","channel center wavelength $col","bandwidth $col"])
                    CSV.write(out,out_file_wvl)

                    out_file_cal = string(ATCOR_fold,strip(col),out_file,"_atcor_cal.cal")
                    out = DataFrame(
                        wavelength = round(wl_mat_tot[col,:]/1000,digits = 6),
                        radiometric_offset_c0 = 0,
                        radiometric_offset_c1 = 1
                    )
                    rename!(["wavelength","radiometric offset c0","radiometric offset c1"])
                    CSV.write(out,out_file_cal)

                    out_file_dat = string(ATCOR_fold,strip(col),out_file,"_atcor_dat.dat")
                    download("https://github.com/lbusett/prismaread/raw/master/inst/extdata/atcor_dat.dat",out_file_dat)#dati at cor prisma
                end
            else
                println("CW matrix dataset not existing - creation of additional ATCOR files ignored")                        
            end# fine if/else exists //KDP_AUX/Cw_Vnir_Matrix
        else#se source non è HCO
            println("Creation of ATCOR files related to specific columns 
            is only useful for HRC datasets - creation of additional 
            ATCOR files skipped ")
        end#fine if/else source != hco
    end#fine id atcor_wls != nothing

end#fine make_atcor



