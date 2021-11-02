# HDF5Plugins

This package implements compression, decompression plugins, and other filter plugins for [HDF5.jl](https://github.com/JuliaIO/HDF5.jl). Currently bzip2, lz4, and zstd compression codecs are supported using [CodecBzip2.jl](https://github.com/JuliaIO/CodecBzip2.jl), [CodecLZ4.jl](https://github.com/JuliaIO/CodecLz4.jl), and [CodecZstd.jl](https://github.com/JuliaIO/CodecZstd.jl). Default filters as well as Blosc compression is currently implemented in HDF5.jl.

The plugins themselves, which implement glue code between HDF5 and the individual codecs, are implemented in Julia after having been ported from C.

## Relationship to HDF5.jl

These filters are meant to be used with the 0.15 branch of HDF5.jl and was initially created and tested with HDF5.jl version 0.15.6.

The contents of this package will be adapted and merged into the 0.16 branch of HDF5.jl.

## See Also

* https://github.com/HDFGroup/hdf5_plugins
* https://github.com/nexusformat/HDF5-External-Filter-Plugins
* https://github.com/silx-kit/hdf5plugin