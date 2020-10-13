


include("faux.jl")
include("eos_create.jl")
#fun aux crea e salva datacbue swir
#


function create_swir(
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
        "SWIR"       
        )    
end

function create_swir(
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
        "SWIR",
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


end #end funzione create swir

