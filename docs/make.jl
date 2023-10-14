using NCPlots
using Documenter

# DocMeta.setdocmeta!(NCPlots, :DocTestSetup, :(using NCPlots); recursive=true)

makedocs(;
#     modules=[NCPlots],
    authors="Roel Stappers <roels@met.no> and contributors",
    repo="https://github.com/roelstappers/NCPlots.jl/blob/{commit}{path}#{line}",
    sitename="NCPlots.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://roelstappers.github.io/NCPlots.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Animations" => "animations.md",
        "ERA5 data" => "cds.md",
        # "References" => "references.md"
    ],
)

deploydocs(;
    repo="github.com/roelstappers/NCPlots.jl",
    devbranch="main",
)
