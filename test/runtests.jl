using Test
using RegionTrees
using StaticArrays
using LinearAlgebra
using NBInclude

include("hyperrectangle.jl")
include("cell.jl")
include("twosarray.jl")
include("asdfs.jl")

const notebooks_dir = joinpath(@__DIR__, "..", "examples")

function execute_notebook(path)
    julia = joinpath(Sys.BINDIR, "julia")
    cd(dirname(path)) do
        run(`$julia --project=$(dirname(path)) -e "using NBInclude; @nbinclude(\"$path\")"`)
    end
end

execute_notebook(joinpath(notebooks_dir, "demo", "demo.ipynb"))
execute_notebook(joinpath(notebooks_dir, "adaptive_distance_fields", "adaptive_distances.ipynb"))
