import RegionTrees: TwosArray

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
    @test slicedim(a2, 1, 1) == a2[1,:]
    @test slicedim(a2, 1, 2) == a2[2,:]
    @test slicedim(a2, 2, 1) == a2[:,1]
    @test slicedim(a2, 2, 2) == a2[:,2]

    a3 = TwosArray(1:8...)
    @test size(a3) == (2,2,2)
    @test a3[1,1,1] == 1
    @test a3[2,1,1] == 2
    @test a3[1,2,2] == 7
    @test slicedim(a3, 1, 1) == a3[1,:,:]
    @test slicedim(a3, 1, 2) == a3[2,:,:]
    @test slicedim(a3, 2, 1) == a3[:,1,:]
    @test slicedim(a3, 2, 2) == a3[:,2,:]
    @test slicedim(a3, 3, 1) == a3[:,:,1]
    @test slicedim(a3, 3, 2) == a3[:,:,2]

    a4 = TwosArray(1:16...)
    @test size(a4) == (2,2,2,2)
    @test a4[1,1,1,1] == 1
    @test a4[2,1,1,1] == 2
    @test slicedim(a4, 1, 1) == a4[1,:,:,:]
    @test slicedim(a4, 1, 2) == a4[2,:,:,:]
    @test slicedim(a4, 2, 1) == a4[:,1,:,:]
    @test slicedim(a4, 2, 2) == a4[:,2,:,:]
    @test slicedim(a4, 3, 1) == a4[:,:,1,:]
    @test slicedim(a4, 3, 2) == a4[:,:,2,:]
    @test slicedim(a4, 4, 1) == a4[:,:,:,1]
    @test slicedim(a4, 4, 2) == a4[:,:,:,2]
end
