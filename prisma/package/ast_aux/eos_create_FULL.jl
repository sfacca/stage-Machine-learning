
using ArchGDAL, CSV, DataFrames

function create_full(basename,priority="VNIR",overwrite=false, geo = nothing)
    println("###### create_full start ######")

    problems = Array{String,1}(undef,0)
    error=false
    
    if !isfile(string(basename,"_VNIR.wvl"))
        println("manca file $(string(basename,"_VNIR.wvl"))")
        error=true
        push!(problems,"manca file $(string(basename,"_VNIR.wvl"))")
    else
        bandvnir = CSV.read(string(basename,"_VNIR.wvl"), DataFrame)
    end

    if !isfile(string(basename,"_SWIR.wvl"))
        println("manca file $(string(basename,"_SWIR.wvl"))")
        error=true
        push!(problems,"manca file $(string(basename,"_SWIR.wvl"))")
    else
        bandswir = CSV.read(string(basename,"_SWIR.wvl"), DataFrame)
    end

    if isfile(string(basename,"_FULL.tif")) && overwrite==false
        println("file $(string(basename,"_FULL.tif")) already exists and overwrite is false")
        error=true
        push!(problems,"file $(string(basename,"_FULL.tif")) already exists and overwrite is false")
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

        swir_copied = bandswir[swir_start:swir_finish,:]
        vnir_copied = bandvnir[vnir_start:vnir_finish,:]        

        swir_copied[!,:type] = ["SWIR" for _ in 1:size(swir_copied)[1]]
        vnir_copied[!,:type] = ["VNIR" for _ in 1:size(vnir_copied)[1]]
        total_wls = vcat(vnir_copied,swir_copied)
        total_wls[!,:band] = [i for i in 1:size(total_wls)[1]]

        swir_cube = nothing
        gtf=nothing
        crs=nothing
        vnir_cube = nothing

        warnings = Array{String,1}(undef,0)        

        if isfile(string(basename,"_SWIR.tif"))
            dataset = ArchGDAL.read(string(basename,"_SWIR.tif"))
            swir_cube = f_getCube(dataset,swir_start,swir_finish)#prendo swir solo da index
            
        else
            push!(warnings,"file $(string(basename,"_SWIR.tif")) is missing")
        end

        if isfile(string(basename,"_VNIR.tif"))
            dataset = ArchGDAL.read(string(basename,"_VNIR.tif"))
            vnir_cube = f_getCube(dataset,vnir_start,vnir_finish)#prendo tutto vnir
            
        else
            push!(warnings,"file $(string(basename,"_VNIR.tif")) is missing")

        end

        
            
        if isnothing(vnir_cube)
            if isnothing(swir_cube)
                push!(warnings,"swir_cube and vnir_cube are nothing")
                cube = nothing
            else
                push!(warnings,"vnir_cube is nothing")
                cube = swir_cube
            end
        elseif isnothing(swir_cube)
            push!(warnings,"swir_cube is nothing")
            cube = vnir_cube
        else
            cube = cat(vnir_cube,swir_cube,dims=3)
        end

        if !isnothing(geo)
            crs = geo.crs
            gtf = geo.gtf
        else
            crs = nothing
            gtf = nothing
        end
        


        out_file_full = string(basename,"_FULL")
        if !isnothing(cube)
            rastwrite_lines(cube,
                out_file_full;
                gtf=gtf,
                crs=crs,
                overwrite=overwrite
                )
        else
            @warn "no cube, printing warnings"
            println(warnings)
        end

        CSV.write(string(basename,"_FULL.wvl"),total_wls)

        println("###### create full end #######")
    end#fine else di isfile(full file) && !overwrite
end