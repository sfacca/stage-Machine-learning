module eos_create_vnir


include("faux.jl")
include("eos_create.jl")
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
        in_L2_file,type = "VNIR")

end #end funzione create vnir


end #end module