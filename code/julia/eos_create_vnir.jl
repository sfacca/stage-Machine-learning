


include("faux.jl")
include("eos_create.jl")

function create_vnir(
        f,
        proc_lev,
        source,#string ["HC0" | "HRC"], Considered Data Cub
        out_file,
        wl,#NB: ORDERED wl = raw_wvl[order]
        order,
        fwhm,#NB: riordinate con ordine order       
        )
    create_cube(
        f,
        proc_lev,
        source,#string ["HC0" | "HRC"], Considered Data Cub
        out_file,
        wl,#NB: ORDERED wl = raw_wvl[order]
        order,
        fwhm,#NB: riordinate con ordine order
        "VNIR"       
        )    
end

function create_vnir(
        f,
        proc_lev,
        source,#string ["HC0" | "HRC"], Considered Data Cub
        out_file,
        wl,
        order,
        fwhm,
        apply_errmatrix,
        ERR_MATRIX,
        selbands_vnir = nothing,
        in_L2_file = nothing)

        create_cube(
            f,
            proc_lev,
            source,#string ["HC0" | "HRC"], Considered Data Cub
            out_file,
            wl,#NB: ORDERED wl = raw_wvl[order]
            order,
            fwhm,#NB: riordinate con ordine order
            "VNIR",
            ERR_MATRIX,
            apply_errmatrix,
            selbands_vnir,
            in_L2_file       
            )#string = [ VNIR , SWIR ]   
    

end #end funzione create vnir