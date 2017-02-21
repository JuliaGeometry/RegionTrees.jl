using Base.Test
using RegionTrees
using StaticArrays
using NBInclude

include("hyperrectangle.jl")
include("cell.jl")
include("twosarray.jl")
include("asdfs.jl")

const notebooks_dir = joinpath(dirname(@__FILE__), "..", "examples")
nbinclude(joinpath(notebooks_dir, "demo.ipynb"))
nbinclude(joinpath(notebooks_dir, "adaptive_distances.ipynb"))
