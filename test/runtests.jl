using HDF5
using HDF5Plugins
using H5Zlz4
using H5Zzstd
using H5Zbzip2
using HDF5Plugins.TestUtils
using Test

function test_zstd_filter()
    cd_values = Cuint[3] # aggression
    test_filter(H5Z_filter_zstd; cd_values = cd_values)
end

function test_bzip2_filter(data = ones(UInt8, 1024))
    cd_values = Cuint[8]
    test_filter(H5Z_filter_bzip2; cd_values = cd_values, data = data)
end

function test_lz4_filter()
    cd_values = Cuint[1024]
    test_filter(H5Z_filter_lz4; cd_values = cd_values)
end

@testset "HDF5Plugins.jl" begin
    for filter_func in (H5Z_filter_lz4, H5Z_filter_zstd, H5Z_filter_bzip2)
        @info filter_func
        # Decompressed size should be 1024, size of default data
        @test test_filter(filter_func)[2] == 0x400
        # Test random data of different lengths
        @test test_filter(filter_func; data = rand(UInt8, 1024))[2] == 0x400
        @test test_filter(filter_func; data = rand(UInt8, 3583))[2] == 3583
        @test test_filter(filter_func; data = rand(UInt8, 389))[2] == 389
        println()
    end

    # Test specific cd_values for filters
    @test test_lz4_filter()[2] == 0x400
    @test test_zstd_filter()[2] == 0x400
    @test test_bzip2_filter()[2] == 0x400

    # To Do, do actual tests on HDF5 files
end
