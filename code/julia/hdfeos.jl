
######## porting in julia di https://github.com/lbusett/prismaread/blob/master/R/pr_convert.R
module hdfeos

  export convert, getAttr

  include("faux.jl")

  using HDF5
  using CSV# per leggere tabella indexes_list.txt
  using DataFrames
  using DataFramesMeta
  using ArchGDAL

  #=
  include("eos_convert.jl")
  include("eos_make_atcor.jl")
  =#
  

  getAttr = faux.getAttr

  
  #include("eos_convert.jl")
  convert = 0
  #convert = eos_convert.convert    

end