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
    cd(dirname(path)) do
        @nbinclude(path)
    end
end

execute_notebook(joinpath(notebooks_dir, "demo", "demo.ipynb"))
execute_notebook(joinpath(notebooks_dir, "adaptive_distance_fields", "adaptive_distances.ipynb"))
