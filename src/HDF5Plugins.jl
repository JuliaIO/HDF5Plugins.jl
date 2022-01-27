module HDF5Plugins
    include("TestUtils.jl")

    using .TestUtils

    function register()
    end

    function __init__()
        if get(ENV, "JULIA_HDF5PLUGINS_REGISTER", "1") != "0"
            register()
        end
    end
end