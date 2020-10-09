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
        out_file,
        wl,#NB: ORDERED wl = raw_wvl[order]
        order,
        fwhm,#NB: riordinate con ordine order       
        )
    eos_create.create_cube(
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
        selbands_vnir = NULL,
        in_L2_file = NULL)

        eos_create.create_cube(
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

        #=function create_cube(
        f,
        proc_lev,
        source,#string ["HC0" | "HRC"], Considered Data Cub
        out_file,
        wl,#NB: ORDERED wl = raw_wvl[order]
        order,
        fwhm,#NB: riordinate con ordine order
        type="VNIR",
        ERR_MATRIX=nothing,        
        apply_errmatrix=false,
        selbands = nothing,
        in_L2_file = nothing
        )#string = [ VNIR , SWIR ]=#
    
    

end #end funzione create vnir


end #end module