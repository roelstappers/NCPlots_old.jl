using NCPlots
using Documenter

# DocMeta.setdocmeta!(NCPlots, :DocTestSetup, :(using NCPlots); recursive=true)

makedocs(;
#     modules=[NCPlots],
    authors="Roel Stappers <roels@met.no> and contributors",
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
        "Examples" => "example.md",
        "Getting data" => "cds.md",
        "API reference" => "references.md"
    ],
)

deploydocs(;
    repo="github.com/roelstappers/NCPlots.jl",
    devbranch="main",
)
