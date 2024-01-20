using Documenter, StanPathfinder

makedocs(
    modules = [StanPathfinder],
    format = Documenter.HTML(),
    checkdocs = :exports,
    sitename = "StanPathfinder.jl",
    pages = Any["index.md"]
)

deploydocs(
    repo = "github.com/StanJulia/StanVPathfinder.jl.git",
)
