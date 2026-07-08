@testset "adaptive sampling" begin
    r = MyRefinery(0.5)
    root = Cell(SVector(0.0, 0), SVector(1.0, 1), "root")

    adaptivesampling!(root, r)
    @test length(collect(allleaves(root))) == 4
    adaptivesampling!(root, r)
    @test length(collect(allleaves(root))) == 4
end
