abstract AbstractRefinery

needs_refinement(refinery::AbstractRefinery, cell) = error("Your refinery should implement this function")
refine_data(refinery::AbstractRefinery, cell, indices) = error("Your refinery should implement this function")

function adaptivesampling!(root::Cell, refinery::AbstractRefinery)
    refinement_queue = [root]
    refine_function =
        (cell, indices) -> refine_data(refinery, cell, indices)
    while !isempty(refinement_queue)
        cell = pop!(refinement_queue)
        if needs_refinement(refinery, cell)
            split!(cell, refine_function)
            append!(refinement_queue, children(cell))
        end
    end
    root
end
