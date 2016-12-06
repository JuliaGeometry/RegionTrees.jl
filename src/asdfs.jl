module ASDFs

using StaticArrays
using RegionTrees
import RegionTrees: needs_refinement, get_data
using Interpolations

@generated function evaluate{N}(itp::AbstractInterpolation, point::SVector{N})
    Expr(:ref, :itp, [:(point[$i]) for i in 1:N]...)
end

function evaluate{D <: AbstractInterpolation}(cell::Cell{D}, point::SVector)
    coords = (point - cell.boundary.origin) ./ cell.boundary.widths + 1
    evaluate(cell.data, coords)
end

type SignedDistanceRefinery{F <: Function} <: AbstractRefinery
    signed_distance_func::F
    atol::Float64
    rtol::Float64
end

function needs_refinement(refinery::SignedDistanceRefinery, cell::Cell)
    needs_refinement(cell, refinery.signed_distance_func, refinery.atol, refinery.rtol)
end

function needs_refinement(cell::Cell, signed_distance_func, atol, rtol)
    c = center(cell.boundary)
    value_interp = evaluate(cell, c)
    value_true = signed_distance_func(c)
    !isapprox(value_interp, value_true, rtol=rtol, atol=atol)
end

function get_data(refinery::SignedDistanceRefinery, boundary)
    interpolate!(refinery.signed_distance_func.(vertices(boundary)),
                 BSpline(Linear()),
                 OnGrid())
end

function ASDF(signed_distance::Function, origin::AbstractArray, 
              widths::AbstractArray,
              rtol=1e-2,
              atol=1e-2)
    refinery = SignedDistanceRefinery(signed_distance, atol, rtol)
    AdaptiveSampling(refinery, origin, widths)
end 


end