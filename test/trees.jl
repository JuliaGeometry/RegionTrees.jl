module trees_tests

using Base.Test
using BinaryRegionTrees
using StaticArrays

@testset "parents and children" begin
    cell = Cell(SVector(-1., -2, -3), SVector(2., 4, 6))
    @test cell.boundary.origin == SVector(-1., -2, -3)
    @test cell.boundary.widths == SVector(2., 4, 6)
    @test isnull(cell.children)
    @test isleaf(cell)

    split!(cell, [nothing for i in 1:8])
    @test !isleaf(cell)
    @test cell[1,1,1].boundary.origin == cell.boundary.origin
    @test cell[2,2,2].boundary.origin + cell[2,2,2].boundary.widths == cell.boundary.origin + cell.boundary.widths
    for child in children(cell)
        @test parent(child) === cell
    end
end

@testset "geometry" begin
    boundary = HyperRectangle(SVector(-1., -2, -3), SVector(2., 4, 6))
    v = vertices(boundary)
    @test v[1,1,1] == [-1, -2, -3]
    @test v[2,1,1] == [1, -2, -3]
    @test v[1,2,1] == [-1, 2, -3]
    @test v[2,2,1] == [1, 2, -3]
    @test v[1,1,2] == [-1, -2, 3]
    @test v[2,1,2] == [1, -2, 3]
    @test v[1,2,2] == [-1, 2, 3]
    @test v[2,2,2] == [1, 2, 3]
end


end