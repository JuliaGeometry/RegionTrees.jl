module ASDFs

using StaticArrays
using BinaryRegionTrees
using Interpolations

@generated function evaluate{N}(itp::AbstractInterpolation, point::SVector{N})
    Expr(:ref, :itp, [:(point[$i]) for i in 1:N]...)
end

function evaluate{D <: AbstractInterpolation}(cell::Cell{D}, point::SVector)
    coords = (point - cell.boundary.origin) ./ cell.boundary.widths + 1
    evaluate(cell.data, coords)
end

function needs_refinement(cell, signed_distance, atol=1e-3)
    c = center(cell.boundary)
    value_interp = evaluate(cell, c)
    value_true = signed_distance(c)
    
    abs(value_interp - value_true) > atol
end

function ASDF{N, T}(signed_distance, origin::SVector{N, T}, widths::SVector{N, T}, atol=1e-3)
    boundary = HyperRectangle(origin, widths)
    
    verts = vertices(boundary)
    corner_values = signed_distance.(verts)
    
    function refine(cell, offset)
        interpolate!(signed_distance.(vertices(child_boundary(cell, offset))), BSpline(Linear()), OnGrid())
    end
    
    root = Cell(boundary, interpolate!(corner_values, BSpline(Linear()), OnGrid()))
    refinement_queue = [root]
    
    while !isempty(refinement_queue)
        cell = pop!(refinement_queue)
        if needs_refinement(cell, signed_distance, atol)
            child_data = map_children(refine, cell)
            split!(cell, child_data)
            append!(refinement_queue, children(cell))
        end
    end
    root
end 


end