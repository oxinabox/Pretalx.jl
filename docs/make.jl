using Documenter, Pretalx

makedocs(;
    modules=[Pretalx],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/oxinabox/Pretalx.jl/blob/{commit}{path}#L{line}",
    sitename="Pretalx.jl",
    authors="Lyndon White",
    assets=String[],
)

deploydocs(;
    repo="github.com/oxinabox/Pretalx.jl",
)
