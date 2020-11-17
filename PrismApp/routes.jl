using Genie, Genie.Router, Genie.Requests

#import controllers
using H5fileController, BandController, RasterController, UserController 

route("/") do
  serve_static_file("welcome.html")
end#=

# h5file routes
route("/h5file/:path") do 
  H5fileController.fileH5(payload(:path)) 
end
route("/h5open", H5fileController.openH5() )
route("/h5edit/:path") do
  H5fileController.editH5(payload(:path)) 
end=#

# raster routes

# band routes
route("/band/:path", BandController.statsBand)
# user routes

