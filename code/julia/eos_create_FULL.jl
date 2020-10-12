using ArchGDAL
using CSV
using DataFrames
include("faux.jl")
include("eos_rastwrite_lines.jl")


function create_full(basename,priority="VNIR",overwrite=false, geo)

    problems = Array{String,1}(undef,0)
    error=false
    
    if !isfile(string(basename,"_VNIR.wvl"))
        println("manca file $(string(basename,"_VNIR.wvl"))")
        error=true
        push!("manca file $(string(basename,"_VNIR.wvl"))")
    else
        bandvnir = CSV.read(string(basename,"_VNIR.wvl"))
    end

    if !isfile(string(basename,"_SWIR.wvl"))
        println("manca file $(string(basename,"_SWIR.wvl"))")
        error=true
        push!("manca file $(string(basename,"_SWIR.wvl"))")
    else
        bandswir = CSV.read(string(basename,"_SWIR.wvl"))
    end

    if isfile(string(basename,"_FULL.tif")) && overwrite==false
        println("file $(string(basename,"_FULL.tif"))already exists and overwrite is false")
        error=true
        push!("file $(string(basename,"_FULL.tif"))already exists and overwrite is false")
    end


    

    if error
        @warn "errori in create_full!"
        println(problems)        
    else
        maxvnir = bandvnir[end,:]
        minswir = bandswir[1,:]
        swir_finish=size(bandswir)[1]
        vnir_start=1

        if priority=="VNIR"

            #if priority is vnir, prendo swir solo + alte di vnir più alto            
            swir_start=size(bandswir)[1]
            vnir_finish =size(bandvnir)[1]
            for i = 1:size(bandswir)[1]
                if bandswir[i,:].wl > maxvnir.wl
                    swir_start = i
                    break
                end
            end            

        else #priority not vnir
            #if priority is swir, prendo solo vnir minori di swir minore
            swir_start=1
            vnir_finish=1
            for i = 1:size(bandvnir)[1]
                if bandvnir[i,:].wl > minvnir.wl
                    vnir_finish = i-1
                    break
                end
            end

        end

        swir_copied = bandswir[index:end,:]
        vnir_copied = bandvnir        

        swir_copied[:type]="SWIR"
        vnir_copied[:type]="VNIR"
        total_wls = vcat(vnir_copied,swir_copied)
        total_wls[:band]=1:size(total_wls)[1]

        swir_cube = nothing
        gtf=nothing
        crs=nothing
        vnir_cube = nothing

        warnings = Array{String1,}(undef,0)        

        if isfile(string(basename,"_SWIR.tif"))
            ArchGDAL.read(string(basename,"_SWIR.tif")) do dataset
                global swir_cube = faux.getCube(dataset,swir_start,swir_finish)#prendo swir solo da index
            end
        else
            push!(warnings,"file $(string(basename,"_SWIR.tif")) is missing")
        end

        if isfile(string(basename,"_VNIR.tif"))
            ArchGDAL.read(string(basename,"_VNIR.tif")) do dataset
                global vnir_cube = faux.getCube(dataset,vnir_start,vnir_finish)#prendo tutto vnir
            end
        else
            push!(warnings,"file $(string(basename,"_VNIR.tif")) is missing")

        end

        
            
        if isnothing(vnir_cube)
            if isnothing(swir_cube)
                cube = nothing
            else
                cube = swir_cube
            end
        else if isnothing(swir_cube)
            cube = vnir_cube
        else
            cube = cat(vnir_cube,swir_cube,dims=3)
        end

        crs = geo.crs
        gtf = geo.gtf

        out_file_full = string(basename,"_FULL.tif")
        if !isnothing(cube)
            rastwrite_lines.write(cube,
                out_file_full,
                gtf,
                crs
                )
        else
            @warn "no cube, printing warnings"
            println(warnings)
        end

        CSV.write(string(basename,"_FULL.wvl"),total_wls)
    end#fine else di isfile(full file) && !overwrite
end