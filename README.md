# HDF5Plugins

This package formerly implemented compression, decompression plugins, and other filter plugins for [HDF5.jl](https://github.com/JuliaIO/HDF5.jl). bzip2, lz4, and zstd compression codecs were supported using [CodecBzip2.jl](https://github.com/JuliaIO/CodecBzip2.jl), [CodecLZ4.jl](https://github.com/JuliaIO/CodecLz4.jl), and [CodecZstd.jl](https://github.com/JuliaIO/CodecZstd.jl).

The plugins themselves, which implement glue code between HDF5 and the individual codecs, are implemented in Julia after having been ported from C.

Currently, the main contents of this package are now part of HDF5.jl as of version 0.16.0. This package now serves mainly as a convenience package to load all known HDF5 compression plugins implemented in Julia.

## Relationship to HDF5.jl

The contents of this package were merged into the 0.16 branch of HDF5.jl and released as independent subdirectory packages.

* [H5Zblosc.jl](https://github.com/JuliaIO/HDF5.jl/tree/master/filters/H5Zblosc)
* [H5Zbzip2.jl](https://github.com/JuliaIO/HDF5.jl/tree/master/filters/H5Zbzip2)
* [H5Zlz4.jl](https://github.com/JuliaIO/HDF5.jl/tree/master/filters/H5Zlz4)
* [H5Zzstd.jl](https://github.com/JuliaIO/HDF5.jl/tree/master/filters/H5Zzstd)

## See Also

* https://github.com/HDFGroup/hdf5_plugins
* https://github.com/nexusformat/HDF5-External-Filter-Plugins
* https://github.com/silx-kit/hdf5plugin