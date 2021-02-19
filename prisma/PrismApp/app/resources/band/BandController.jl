module BandController
  # Build something great
  using Genie.Renderer, Genie.Router

  function statsBand()
    html(path"app/resources/band/views/stats.jl.md", layout = path"app/layouts/app.jl.html")
  end

end


# band è praticamente una matrice 2d presa dal cubo dal file h5 o un layer da raster