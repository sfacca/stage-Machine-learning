# Compute spectral indexes from a PRISMA he5 file (or a file converted with pr_convert)
#
# the function parses the index formula to identify the required
#   bands. On the basis of identified bands, it retrieves the reflectance bands
#   required, gets the data into R raster objects, performs the computation and
#   stores results in a GeoTiff or ENVI raster file
module compute_indexes

export compute_indexes

include("faux.jl")

using CSV

function compute_indexes(in_file, #  path of the file to be used for computing indexes
    out_file,#  output path - filenames are created adding a
    out_format = "GTiff",#["GTiff" | "ENVI"], Output format, Default:
    indexes,#=array of names of indexes to be computed. You can
          see a list of available indexes using command `pr_listindexes()`, 
          or see'  the corresponding table at:
        https://lbusett.github.io/prismaread/articles/Computing-Spectral-Indexes.html=#
    cust_indexes = NULL,#=named list containing names and formulas of
      custom indexes to be computed. The indexes formulas must be computable R
      formulas, where bands are referred to by the prefix "b", followed by the
      wavelength (e.g., `cust_indexes = list(myindex1 = "R500 / R600",
                                      myindex2 = "(R800 - R680) / (R800 + R680)")
    =#
    overwrite    = FALSE)#if TRUE, existing files are overwritten,

    out_format = "GTiff"#non ci interessano i file envi

    if !isfile(in_file)
        println("Input file not found. Aborting!")
        return nothing
    end
    out_folder = faux.dirname(out_file)
    if !isfile(out_folder)
        println("folder $out_folder does not exist. Please create it beforehand!")
        return nothing
    end   

    out_file_txt = string(in_file, ".wvl")

    if !isfile(out_file_txt)
        println("Unable to find the wavelengths txt file. Aborting!")
        return nothing
    end
    
    rast_wls = CSV.read(out_file_txt, header = TRUE).wl

    # create folder for index
    mkpath(out_folder)

    #in_rast <- raster::brick(in_file)

    index_list = faux.getIndexList()

    av_indexes = index_list[Formula]

    rename!(av_indexes, index_list[Name])

    sel_indexes = filter(x->x in indexes, av_indexes)
    bad_indexes = filter(x->x ∉ names(av_indexes), indexes)

    if length(bad_indexes) > 0
        @warn string("index(es) ", indexes[bad_indexes]," are not in the current list of ","available indexes and will not be computed!")
    end


    tot_indexes = [av_indexes[sel_indexes], cust_indexes]
    indstrings = []

    for ind in faux.seq_along(tot_indexes)

        println("Computing ", names(tot_indexes)[[ind]], " Index")

        if names(tot_indexes)[[ind]] in names(av_indexes)

            # create index filename
            out_indfile = string(out_file, "_" , names(tot_indexes)[[ind]], ".tif")
            # get index formula
            indform = tot_indexes[[ind]]
            # compute index
            if !isfile(out_indfile) || overwrite
                req_wls  = faux.extractWvl(indform)

                which_bands = faux.closestDistanceFunction(req_wls).(rast_wls)
                diffs = faux.closestDistanceFunction(req_wls).(rast_wls)
                if maximum(diffs) > 9
                    @warn string("The bands in the input file do not allow to 2",
                            "compute index: ",
                            names(indexes)[[ind]])
                else
                    indstring    = indform
                    in_rast_comp = in_rast[[which_bands]]
                    rast_wls_comp  = rast_wls[which_bands]
                    which_bands = faux.closestDistanceFunction(req_wls).(rast_wls_comp)


                    for nn = 1:length(req_wls)
                        indform = replace(indform, req_wls[nn] => string("[,",which_bands[nn], "]"))
                        replace!(indstring,req_wls[nn]=>round(rast_wls_comp[nn],digits = 4))
                    end

                    replace!(indform,"R"=>"x")
                    indstrings[names(tot_indexes)[ind]] = indstring

#=
                    out <- raster::raster(in_rast)
                    bs <-  raster::blockSize(out)
                    out <- raster::writeStart(out,
                                              filename = out_indfile,
                                              overwrite = TRUE,
                                              options = c("COMPRESS=LZW"),
                                              datatype = "FLT4S")=#
                    for i = 1:bs.n
                        println("Writing Block: ", i, " of: ", bs.n)
                        #x <- raster::getValues(in_rast_comp, row = bs$row[i],nrows = bs$nrows[i])
                        if !isa(x, Number)
                            x = string(indform)#???????????
                        end
                        #out <- raster::writeValues(out, x, bs$row[i])
                    end
                    #out <- raster::writeStop(out)
                end
            else
                println("Output ", names(indexes)[[ind]],
                        " file already exists - use overwrite = TRUE or change
                    output file name to reprocess")
            end
        else
            @warn string("Index ", names(indexes)[[ind]],
                    " is not in the current list of available indexes and will",
                    " not be computed. ")
        end
    end

    indstrings_dt = CSV.read(indstrings)
    out_file_formulas = string(faux.fileSansExt(in_file),".formulas")
    CSV.write(indstrings_dt,out_file_formulas,writeheader = false); 
   



end#fine funzione

end#fine modulo
