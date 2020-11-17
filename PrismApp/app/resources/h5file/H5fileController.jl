module H5fileController
  # Build something great
  using Genie.Renderer, Genie.Router



  

  function openH5()
    html(path"app/resources/h5file/views/open.jl.md", layout = path"app/layouts/app.jl.html")
  end

  function fileH5(filepath)
    html(path"app/resources/h5file/views/file.jl.md", path=filepath, layout = path"app/layouts/app.jl.html")
  end

  function editH5(filepath)
    html(path"app/resources/h5file/views/edit.jl.md", path=filepath, layout = path"app/layouts/app.jl.html")
  end
end
