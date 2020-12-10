module eos_geoloc

using HDF5
using ArchGDAL

export getGeoloc, getGtf, getCrs, get

include("faux.jl")
#=
produce tupla geo:
    lat: matrice latitudini
    lon: matrice longitudini
    se prodotto è l2d aggiunge altre info di geoloc
=#
#= source=
HRC = Radiometric Calibrated Hyperspectral Cube <= solo in l1
HCO = Co-registered Hyperspectral Cube
PRC = Radiometric Calibrated Panchromatic Cube <= solo in l1
PCO = Co-registered Panchromatic Cube
=#
function minimum(x::Number,y::Number)
    if x<y
        x
    else
        y
    end
end
function maximum(x::Number,y::Number)
    if x>y
        x
    else
        y
    end
end



function getGeoloc(f,
    proc_lev,
    source,#vedi sopra
    wvl        = nothing,#VNIR,SWIR,PAN
    in_L2_file = nothing)

    println("getting geoloc info")

    if isnothing(wvl)
        wvl = "VNIR"
    end
    if proc_lev == "1" && wvl in ["SWIR","VNIR","PAN"]
        wvl = string("_",wvl)
    else
        wvl=""#prodotti lvl>1 han solo una coppia di dataset Latitude/Longitude
    end  
    
    #ho file l2? 
    if proc_lev == "1" && !isnothing(in_L2_file)#se ho un file l2, prendo geoloc da quello
        try
            f2 = HDF5.h5open(in_L2_file,"r+")
        catch e
            println("Unable to open the input accessory L2 file as a hdf5 file. Verify your inputs. Aborting!")
            e
        end
        file = f2
    else#se no prendo da l1
        file = f
    end

    geopath = string("/HDFEOS/SWATHS/PRS_L$(proc_lev)_",source,"/Geolocation Fields/")

    

    lat = getData(file,string(geopath,"Latitude",wvl))
    lon = getData(file,string(geopath,"Longitude",wvl))

    if proc_lev == "2D"          
        # If plev = L2D, get also the corners and projection ----

        proj_code = getAttr(f, "Projection_Id")
        proj_name = getAttr(f, "Projection_Name")
        proj_epsg = getAttr(f, "Epsg_Code")
        xmin = minimum(
            getAttr(f, "Product_ULcorner_easting"),
            getAttr(f, "Product_LLcorner_easting")
            )           
        xmax  = maximum(
            getAttr(f, "Product_LRcorner_easting"),
            getAttr(f, "Product_URcorner_easting")
        )            
        ymin = minimum(
            getAttr(f, "Product_LLcorner_northing"),
            getAttr(f, "Product_LRcorner_northing")
            )
        ymax = maximum(
            getAttr(f, "Product_ULcorner_northing"),
            getAttr(f, "Product_URcorner_northing")
        ) 

        out = (xmin = xmin,
                    xmax = xmax,
                    ymin = ymin,
                    ymax = ymax,
                    proj_code = proj_code,
                    proj_name = proj_name,
                    proj_epsg = proj_epsg,
                    lat = lat,
                    lon = lon)
        
    else
        
        out = (lat = lat, lon = lon)
        
    end
    return out
end#end get geoloc

function getGtf(geo, proc_lev)
    println("building geotranform array")
    if proc_lev[1] != "2"
        ulpixel = (x=geo.xmin,y=geo.ymax)
        width = length(geo.lat[:,1])
        height = length(geo.lat[1,:])
        #calcoliamo risoluzione come distanza tra 
        res = (geo.xmax - geo.xmin)/width# \approx (geo.ymin - geo.ymax)/height

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
    else
        throw(error("processing level $proc_lev files not supported yet"))
    end
    gtf     
end

function getCrs(geo,proc_lev)
    println("building coordinate reference system string")
    if proc_lev == 1
        throw(error("processing level $proc_lev not supported yet"))
    else
        crs = ArchGDAL.toWKT(ArchGDAL.importEPSG(geo.proj_epsg))
        
    end    
    crs
end

function get(f,type)
    
    proc_lev = getAttr(f,"Processing_Level")
    if type == "PAN"
        source = "PCO"
    else
        source = "HCO"        
    end
    geo = getGeoloc(f,proc_lev,source,type)
    (gtf =getGtf(geo,proc_lev), crs = getCrs(geo,proc_lev))
end

end#end modulo