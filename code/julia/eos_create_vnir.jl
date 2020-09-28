module create_vnir


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
        #=if(proc_lev == 1) {
        vnir_cube <- f[[paste0("HDFEOS/SWATHS/PRS_L1_", source,
                               "/Data Fields/VNIR_Cube")]][,,]
        vnir_scale  <- hdf5r::h5attr(f, "ScaleFactor_Vnir")
        vnir_offset <- hdf5r::h5attr(f, "Offset_Vnir")
        if (any(apply_errmatrix | ERR_MATRIX)) {
            err_cube <- f[[paste0("HDFEOS/SWATHS/PRS_L1_", source,
                                  "/Data Fields/VNIR_PIXEL_SAT_ERR_MATRIX/")]]
        }=#
    else

    end

end


end