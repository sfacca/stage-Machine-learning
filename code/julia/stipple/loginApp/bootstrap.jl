  cd(@__DIR__)
  import Pkg
  Pkg.activate(".")

  function main()
    include(joinpath("src", "LoginApp.jl"))
    include(joinpath("app","resources","authentication","AuthenticationController.jl"))
    include(joinpath("plugins","genie_authentication"))
  end; main()
