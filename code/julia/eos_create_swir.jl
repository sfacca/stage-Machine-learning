module eos_create_swir


include("faux.jl")
include("eos_create.jl")
#fun aux crea e salva datacbue swir
#



export create_swir

function create_swir(
    f,
    proc_lev,
    source,#string ["HCO" | "HRC"], Considered Data Cub
    out_file_swir,
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

    

    eos_create.create_cube(
        f,proc_lev,source,out_file_swir,out_format,base_georef,fill_gaps,
        wl_vnir,order_vnir,fwhm_vnir,apply_errmatrix,ERR_MATRIX,selbands_vnir,in_L2_file,"VNIR"
    )

end #end funzione create swir

function create_swir(f)
    proc_lev = faux.getAttr(f,"Processing_Level")
    source = "HCO"
    out_file_swir = "out/SWIR"
    out_format = "GTiff"
    
end


end #end module