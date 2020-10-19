using PrismaConvert
using Documenter

makedocs(;
    modules=[PrismaConvert],
    authors="sebastiano facca <46827183+sfacca@users.noreply.github.com> and contributors",
    repo="https://github.com/<sfacca>/PrismaConvert.jl/blob/{commit}{path}#L{line}",
    sitename="PrismaConvert.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://<sfacca>.github.io/PrismaConvert.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/<sfacca>/PrismaConvert.jl",
)
