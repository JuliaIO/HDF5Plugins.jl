using HDF5
using HDF5Plugins
using HDF5Plugins.H5Zlz4
using HDF5Plugins.H5Zzstd
using HDF5Plugins.H5Zbzip2
using HDF5Plugins.TestUtils
using Test

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
    @test H5Zlz4.test_lz4_filter()[2] == 0x400
    @test H5Zzstd.test_zstd_filter()[2] == 0x400
    @test H5Zbzip2.test_bzip2_filter()[2] == 0x400

    # To Do, do actual tests on HDF5 files
end
