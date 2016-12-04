@testset "vertices" begin
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

    @test center(boundary) == [0, 0, 0]
end