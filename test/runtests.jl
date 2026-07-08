using Test
using RegionTrees
using StaticArrays
using LinearAlgebra

struct MyRefinery <: AbstractRefinery
    tolerance::Float64
end

function RegionTrees.needs_refinement(r::MyRefinery, cell)
    maximum(cell.boundary.widths) > r.tolerance
end

function RegionTrees.refine_data(r::MyRefinery, cell::Cell, indices)
    boundary = child_boundary(cell, indices)
    "child with widths: $(boundary.widths)"
end

include("hyperrectangle.jl")
include("cell.jl")
include("twosarray.jl")
include("adaptivesampling.jl")
include("asdfs.jl")
