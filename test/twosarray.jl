import BinaryRegionTrees: TwosArray

@testset "twosarray" begin
    a1 = TwosArray(1,2)
    @test size(a1) == (2,)
    @test a1[1] == 1
    @test a1[2] == 2

    a2 = TwosArray("a", "b", "c", "d")
    @test size(a2) == (2,2)
    @test a2[1] == "a"
    @test a2[1,1] == "a"
    @test a2[2] == "b"
    @test a2[2,1] == "b"
    @test a2[3] == "c"
    @test a2[1,2] == "c"
    @test a2[4] == "d"
    @test a2[2,2] == "d"

    a3 = TwosArray(1:8...)
    @test size(a3) == (2,2,2)
    @test a3[1,1,1] == 1
    @test a3[2,1,1] == 2
    @test a3[1,2,2] == 7
end
