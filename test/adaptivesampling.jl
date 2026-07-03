@testset "adaptive sampling" begin
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

    r = MyRefinery(0.5)
    root = Cell(SVector(0.0, 0), SVector(1.0, 1), "root")

    adaptivesampling!(root, r)
    @test length(collect(allleaves(root))) == 4
    adaptivesampling!(root, r)
    @test length(collect(allleaves(root))) == 4
end
