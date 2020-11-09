### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ f91d4340-1f63-11eb-21ac-45e37920805f
using ZipFile

# ╔═╡ 8a966eb0-1f63-11eb-09d4-8189dc291746
include("out/cmdimdata/CMDimData.jl-master/src/CMDimData.jl")

# ╔═╡ 0f552102-1f64-11eb-0e7d-97b25703b10f
md"scarica e include cmdimdata da github"

# ╔═╡ 2c46cc00-1f64-11eb-0a82-9f396b6c6175
md"funzione ausiliare copiata da : https://discourse.julialang.org/t/how-to-extract-a-file-in-a-zip-archive-without-using-os-specific-tools/34585/5"

# ╔═╡ 79e116b0-1f63-11eb-26f6-13b8eddfc57e
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

# ╔═╡ 86b00cc0-1f63-11eb-2c62-e955909e757e
function _downloadStuff()
	mkpath("out/cmdimdata/")
	download("https://github.com/ma-laforge/CMDimData.jl/raw/master/sample/parametric_sin.jl","out/parametric_sin_2.jl")
	download("https://github.com/ma-laforge/CMDimData.jl/archive/master.zip", "out/master.zip")
	
	unzip("out/master.zip","out/cmdimdata/")	
end

# ╔═╡ 94af1e5e-1f63-11eb-29e1-9be0c6e20560
_downloadStuff()	

# ╔═╡ Cell order:
# ╟─0f552102-1f64-11eb-0e7d-97b25703b10f
# ╠═f91d4340-1f63-11eb-21ac-45e37920805f
# ╟─2c46cc00-1f64-11eb-0a82-9f396b6c6175
# ╠═79e116b0-1f63-11eb-26f6-13b8eddfc57e
# ╠═86b00cc0-1f63-11eb-2c62-e955909e757e
# ╠═94af1e5e-1f63-11eb-29e1-9be0c6e20560
# ╠═8a966eb0-1f63-11eb-09d4-8189dc291746
