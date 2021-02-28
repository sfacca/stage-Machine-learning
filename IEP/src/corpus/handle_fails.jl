urls = filter((x)->(contains(x,".zip")),string.(replace.(split(read("fails.txt", String), "\n"), r"\r"=>"")))
mkpath("tmp")
for url in urls
    download(url,joinpath("tmp",string(split(replace(url, r"/archive/master.zip"=>""),"/")[end],".zip")))
end