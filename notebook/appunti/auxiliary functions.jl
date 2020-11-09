### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ 512a80a0-229a-11eb-0f3d-211bcd46c17a
using ZipFile

# ╔═╡ 642a0c30-2299-11eb-3c44-83f19dee070e
md"funzioni ausiliarie"

# ╔═╡ 6c2a8a40-2299-11eb-1451-114979ebb575
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

# ╔═╡ Cell order:
# ╟─642a0c30-2299-11eb-3c44-83f19dee070e
# ╠═512a80a0-229a-11eb-0f3d-211bcd46c17a
# ╠═6c2a8a40-2299-11eb-1451-114979ebb575
