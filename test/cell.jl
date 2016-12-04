
@testset "parents and children" begin
    cell = Cell(SVector(-1., -2, -3), SVector(2., 4, 6), 0)
    @test cell.boundary.origin == SVector(-1., -2, -3)
    @test cell.boundary.widths == SVector(2., 4, 6)
    @test isnull(cell.children)
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
    c1 = BinaryRegionTrees.Cell(SVector(0.0, 0.0), SVector(1.0, 1.0))
    @test typeof(c1.boundary.origin) == SVector{2, Float64}
    c2 = BinaryRegionTrees.Cell(SVector(0, 0), SVector(1, 1))
    @test typeof(c2.boundary.origin) == SVector{2, Float64}

    @inferred BinaryRegionTrees.Cell(SVector(0, 0), SVector(1, 1))
    @inferred BinaryRegionTrees.Cell(SVector(0.0, 0.0), SVector(1.0, 1.0))
end

@testset "find leaf" begin
    cell = Cell(SVector(-1., -2, -3), SVector(2., 4, 6), 0)
    @test findleaf(cell, SVector(-0.01, -0.01, -0.01)) === cell

    split!(cell, [0 for i in 1:8])
    @test findleaf(cell, SVector(-0.01, -0.01, -0.01)) === cell[1,1,1]
    @test findleaf(cell, SVector(0.01, -0.01, -0.01)) === cell[2,1,1]
end

