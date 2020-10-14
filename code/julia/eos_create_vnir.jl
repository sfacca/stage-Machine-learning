


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
        fwhm;
        apply_errmatrix=false,
        ERR_MATRIX=nothing,
        selbands_swir = nothing,
        in_L2_file = nothing)
        create_cube(
            f,
            proc_lev,
            source,#string ["HC0" | "HRC"], Considered Data Cub
            out_file,
            wl,#NB: ORDERED wl = raw_wvl[order]
            order,
            fwhm;#NB: riordinate con ordine order
            type = "VNIR",
            ERR_MATRIX = ERR_MATRIX,
            apply_errmatrix = apply_errmatrix,
            selbands = selbands_vnir,
            in_L2_file = in_L2_file    )   
    

end #end funzione create vnir