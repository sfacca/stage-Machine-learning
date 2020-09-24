
######## porting in julia di https://github.com/lbusett/prismaread/blob/master/R/pr_convert.R
module hdfeos

  export convert, getAttr

  using HDF5
  using CSV# per leggere tabella indexes_list.txt
  using DataFrames
  using DataFramesMeta
  using ArchGDAL
  
  

  function getAttr(file, name::String)
      # name è attributo globale del file(aperto) hdf5 file
      # ritorna campo valore name
      atts = attrs(file)
      content = read(atts, name)
      content
  end

  
  include("eos_convert.jl")
  
  convert = eos_convert.convert    

end