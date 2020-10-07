module eos_get_geoloc

include("faux.jl")

using HDF5

export get_geoloc
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



function get_geoloc(f,
    proc_lev,
    source,#vedi sopra
    wvl        = nothing,#VNIR,SWIR,PAN
    in_L2_file = nothing)

    if isnothing(wvl)
        wvl = "VNIR"
    end
    if proc_lev == "1" && wvl in ["SWIR","VNIR"]
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

    

    lat = faux.getData(file,string(geopath,"Latitude",wvl))
    lon = faux.getData(file,string(geopath,"Longitude",wvl))

    if proc_lev == "2D"          
        # If plev = L2D, get also the corners and projection ----

        proj_code = faux.getAttr(f, "Projection_Id")
        proj_name = faux.getAttr(f, "Projection_Name")
        proj_epsg = faux.getAttr(f, "Epsg_Code")
        xmin = minimum(
            faux.getAttr(f, "Product_ULcorner_easting"),
            faux.getAttr(f, "Product_LLcorner_easting")
            )           
        xmax  = maximum(
            faux.getAttr(f, "Product_LRcorner_easting"),
            faux.getAttr(f, "Product_URcorner_easting")
        )            
        ymin = minimum(
            faux.getAttr(f, "Product_LLcorner_northing"),
            faux.getAttr(f, "Product_LRcorner_northing")
            )
        ymax = maximum(
            faux.getAttr(f, "Product_ULcorner_northing"),
            faux.getAttr(f, "Product_URcorner_northing")
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

end#end modulo