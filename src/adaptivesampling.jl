abstract AbstractRefinery

needs_refinement(refinery, cell) = error("Your refinery should implement this function")
get_data(refinery, boundary) = error("Your refinery should implement this function")

AdaptiveSampling(refinery::AbstractRefinery, origin::AbstractArray, widths::AbstractArray) = 
    AdaptiveSampling(refinery, HyperRectangle(origin, widths))

function AdaptiveSampling(refinery::AbstractRefinery, boundary::HyperRectangle)
    root = Cell(boundary, get_data(refinery, boundary))
    refinement_queue = [root]
    refine_function = (cell, indices) -> get_data(refinery, child_boundary(cell, indices))
    while !isempty(refinement_queue)
        cell = pop!(refinement_queue)
        if needs_refinement(refinery, cell)
            split!(cell, refine_function)
            append!(refinement_queue, children(cell))
        end
    end
    root
end
