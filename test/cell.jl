
@testset "parents and children" begin
    cell = Cell(SVector(-1., -2, -3), SVector(2., 4, 6), 0)
    @test cell.boundary.origin == SVector(-1., -2, -3)
    @test cell.boundary.widths == SVector(2., 4, 6)
    @test cell.children === nothing
    @test isleaf(cell)

    split!(cell, [i for i in 1:8])
    @test !isleaf(cell)
    @test cell[1,1,1].boundary.origin == cell.boundary.origin
    @test cell[2,2,2].boundary.origin + cell[2,2,2].boundary.widths == cell.boundary.origin + cell.boundary.widths
    @test cell[1,1,1].data == 1
    @test cell[2,1,1].data == 2
    for child in children(cell)
        @test parent(child) === cell
    end
end

@testset "type promotions" begin
    c1 = RegionTrees.Cell(SVector(0.0, 0.0), SVector(1.0, 1.0))
    @test typeof(c1.boundary.origin) == SVector{2, Float64}
    c2 = RegionTrees.Cell(SVector(0, 0), SVector(1, 1))
    @test typeof(c2.boundary.origin) == SVector{2, Float64}

    @inferred RegionTrees.Cell(SVector(0, 0), SVector(1, 1))
    @inferred RegionTrees.Cell(SVector(0.0, 0.0), SVector(1.0, 1.0))
end

@testset "find leaf" begin
    cell = Cell(SVector(-1., -2, -3), SVector(2., 4, 6), 0)
    @test findleaf(cell, SVector(-0.01, -0.01, -0.01)) === cell

    split!(cell, [0 for i in 1:8])
    @test findleaf(cell, SVector(-0.01, -0.01, -0.01)) === cell[1,1,1]
    @test findleaf(cell, SVector(0.01, -0.01, -0.01)) === cell[2,1,1]
end

@testset "find parents" begin
	cell2D = Cell(SVector(0., 0), SVector(1., 1))
	split!(cell2D)
	split!(cell2D[1,1])
	parents2D = [p for p in allparents(cell2D[1,1][1,2])]

	@test parents2D[1] === cell2D[1,1]
	@test parents2D[2] === cell2D

	cell3D = Cell(SVector(-1., -2, -3), SVector(2., 4, 6), 0)
	split!(cell3D)
	split!(cell3D[2,2,2])
	parents3D = [p for p in allparents(cell3D[2,2,2][1,1,1])]

	@test parents3D[1] === cell3D[2,2,2]
	@test parents3D[2] === cell3D

	noparents = [p for p in allparents(cell2D)]
	@test length(noparents) == 0
end

@testset "non-float64 types" begin
    # https://github.com/rdeits/RegionTrees.jl/pull/22
    root = Cell(SVector(0f0, 0f0, 0f0), SVector(1f0, 1f0, 1f0))
    split!(root)
    @test length(root.children) == 8
end

@testset "allcells, alleaves, allparents functions" begin
    struct MyRefinery <: RegionTrees.AbstractRefinery
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
    root = Cell(SVector(0., 0), SVector(1., 1), "root")
    adaptivesampling!(root, r)

    ac = allcells(root)
    @test typeof(ac) == Channel{Cell{String, 2, Float64, 4}}
    acv = collect(ac)
    @test typeof(acv) == Vector{Cell{String, 2, Float64, 4}}
    @test size(acv, 1) == 5

    al = allleaves(root)
    @test typeof(al) == Channel{Cell{String, 2, Float64, 4}}
    alv = collect(al)
    @test typeof(alv) == Vector{Cell{String, 2, Float64, 4}}
    @test size(alv, 1) == 4

    leaf = alv[1]
    ap = allparents(leaf)
    @test typeof(ap) == Channel{Cell{String, 2, Float64, 4}}
    apv = collect(ap)
    @test typeof(apv) == Vector{Cell{String, 2, Float64, 4}}
    @test size(apv, 1) == 1
end
