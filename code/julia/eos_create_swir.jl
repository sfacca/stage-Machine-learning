module eos_create_swir


include("faux.jl")
include("eos_create.jl")
#fun aux crea e salva datacbue swir
#



export create_swir

function create_swir(
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

    create_cube(f,
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
        selbands_vnir,
        in_L2_file,type = "SWIR")

end #end funzione create swir


end #end module