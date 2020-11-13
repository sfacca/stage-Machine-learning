module H5fileController
  # Build something great
  using Genie.Renderer



  

  function openH5()
    html(path"app/resources/h5file/views/open.jl.md", layout = path"app/layouts/app.jl.html")
  end

  function fileH5(f)
    html(path"app/resources/h5file/views/file.jl.md", file=f, layout = path"app/layouts/app.jl.html")
  end

  function editH5(f)
    html(path"app/resources/h5file/views/edit.jl.md", file=f, layout = path"app/layouts/app.jl.html")
  end
end
