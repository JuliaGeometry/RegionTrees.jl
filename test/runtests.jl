using Test
using RegionTrees
using StaticArrays
using IJulia
using LinearAlgebra

include("hyperrectangle.jl")
include("cell.jl")
include("twosarray.jl")
include("asdfs.jl")

const notebooks_dir = joinpath(dirname(@__FILE__), "..", "examples")

function execute_notebook(path)
    mktempdir() do dir
        run(`$(IJulia.jupyter) nbconvert --execute $path --output-dir=$dir`)
    end
end

execute_notebook(joinpath(notebooks_dir, "demo", "demo.ipynb"))
execute_notebook(joinpath(notebooks_dir, "adaptive_distance_fields", "adaptive_distances.ipynb"))
