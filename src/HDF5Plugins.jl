module HDF5Plugins
    include("TestUtils.jl")
    include("H5Zlz4.jl")
    include("H5Zbzip2.jl")
    include("H5Zzstd.jl")

    using .TestUtils

    function register()
        H5Zlz4.register_lz4()
        H5Zzstd.register_zstd()
        H5Zbzip2.register_bzip2()
    end

    function __init__()
        if get(ENV, "JULIA_HDF5PLUGINS_REGISTER", "1") != "0"
            register()
        end
    end
end