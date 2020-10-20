include("eos_geoloc.jl")
include("eos_rastwrite_lines.jl")
include("faux.jl")

using ArchGDAL
#   helper function used to process and save the PAN data cube

function create_pan(
        f,
        proc_lev,
        out_file;
        overwrite=false      
        )

    if proc_lev != "2D"
        println("errore: file non è prodotto lvl 2d")
        return nothing
    end

    geo = eos_geoloc.get(f, "PAN") 
    
    #prendo cubo

    cube = faux.getData(f, "HDFEOS/SWATHS/PRS_L$(proc_lev)_PCO/Data Fields/Cube")
    dims = size(cube)
    width = dims[1]
    if length(dims) == 2
        height = dims[2]
    else
        height = dims[3]
    end

    out_file = string(out_file, "_PAN")
    #scrivo cubo

    rastwrite_lines.write(
        cube,
        out_file;
        gtf=geo.gtf,
        crs=geo.crs,
        overwrite=overwrite
    )

end