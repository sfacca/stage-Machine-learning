module eos_demo

using ArchGDAL; const AG = ArchGDAL 

include("eos_geoloc.jl")
include("faux.jl")
include("HDF5filesDict.jl")

export demo

function writeSingleBand(band,bandnum,dataset)

end

function geoToGeoloc(geo)    
    ulpixel = (x=geo.xmin,y=geo.ymax)
    width = length(geo.lat[:,1])
    height = length(geo.lat[1,:])
    #calcoliamo risoluzione come distanza tra 
    res = (geo.xmin - geo.xmax)/width# \approx (geo.ymin - geo.ymax)/height

    #archgdal prende geoloc come array:
    gtf = [
        ulpixel.x,#distanza in mt sull asse delle x del pixel topleft dall origine
        res,
        0,#per rotazione
        ulpixel.y,#distanza in mt sull asse delle y del pixel topleft dall origine
        0,
        -res
    ]
    gtf = convert(Array{Float64,1}, gtf)
    # creiamo stringa crs
    crs = AG.toWKT(AG.importEPSG(geo.proj_epsg))

    gtf, crs
end

function demo(f::String, out::String, overwrite = false)
    if isfile(out) 
        println( "$out già esistente")
        if overwrite
            println("deleting $out")
            rm(out)
        end
    end

    openfiles = HDF5fd.filesDict()
    f = HDF5fd.open(openfiles,f,"r")
    proc_lev = faux.getAttr(f,"Processing_Level")

    if proc_lev != "2D"
        println("errore: file non è prodotto lvl 2d")
        return nothing
    end

    geo = eos_geoloc.get(f,"PAN")
    
    #prendo cubo

    cube = faux.getData(f,"HDFEOS/SWATHS/PRS_L2D_PCO/Data Fields/Cube")
    dims = size(cube)
    width = dims[1]
    if length(dims)==2
        height=dims[2]
    else
        height=dims[3]
    end
    AG.create(
            out,
            driver = AG.getdriver("GTiff"),
            width=width,
            height=height,
            nbands=1,
            dtype=UInt16
        ) do dataset
            println( "creato $out")
            AG.write!(dataset, cube, 1)
            AG.setgeotransform!(dataset, geo.gtf)
            AG.setproj!(dataset, geo.crs)
        end


    HDF5fd.closeall(openfiles)

    return 1
end


end