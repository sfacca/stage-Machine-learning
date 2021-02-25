### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ bbe97d40-6581-11eb-3fa1-ed846d398822
using ZipFile

# ╔═╡ bff81d20-6580-11eb-0acd-01f20999c996
function unzip(file,exdir="")
    fileFullPath = isabspath(file) ?  file : joinpath(pwd(),file)
    basePath = dirname(fileFullPath)
    outPath = (exdir == "" ? basePath : (isabspath(exdir) ? exdir : joinpath(pwd(),exdir)))
    isdir(outPath) ? "" : mkpath(outPath)
    zarchive = ZipFile.Reader(fileFullPath)
    for f in zarchive.files
        fullFilePath = joinpath(outPath,f.name)
        if (endswith(f.name,"/") || endswith(f.name,"\\"))
            mkpath(fullFilePath)
        else
            write(fullFilePath, read(f))
        end
    end
    close(zarchive)
end

# ╔═╡ 42c3f160-6587-11eb-172a-6dbfaa4c3241


# ╔═╡ Cell order:
# ╠═bbe97d40-6581-11eb-3fa1-ed846d398822
# ╠═bff81d20-6580-11eb-0acd-01f20999c996
# ╠═42c3f160-6587-11eb-172a-6dbfaa4c3241
