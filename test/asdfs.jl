@testset "adaptively sampled distance fields" begin
    include("../examples/adaptive_distance_fields.jl")
    import AdaptivelySampledDistanceFields: ASDF, evaluate
    import StaticArrays: SVector

    signed_distance = x -> norm(x - SVector(0, 0))
    origin = SVector(-1, -1)
    widths = SVector(2, 2)
    root = ASDF(signed_distance, origin, widths, 1e-2, 1e-2)
    @test evaluate(root, [0, 0]) == 0
    @test evaluate(root, SVector(0, 0)) == 0
    @test findleaf(root, [0.01, -0.01]).boundary.origin == [0.0, -0.0625]
    @test findleaf(root, [0.01, -0.01]).boundary.widths == [0.0625, 0.0625]

    for leaf in allleaves(root)
        @test isleaf(leaf)
    end
    @test length(collect(allleaves(root))) == 112
    @test length(collect(allcells(root))) = 149
end
