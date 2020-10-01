module eos_setext_L2D

export setext_L2D

function setext_L2D(geo, band) 
    ex = [geo.xmin -15,geo.ymin -15, 
        geo.xmin - 15 + (30*length(band[1,:])),
        geo.ymin -15 + (30*length(band[1,:]))
    ]  
    ex = reshape(ex,2,2) 
    
    #ex   <- raster::extent(ex)
    #band <- raster::setExtent(band, ex, keepres = FALSE)
    band
end

end