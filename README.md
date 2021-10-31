# HDF5Plugins

This package implements compression, decompression plugins, and other filter plugins for [HDF5.jl](https://github.com/JuliaIO/HDF5.jl). Currently bzip2, lz4, and zstd compression codecs are supported using [CodecBzip2.jl](https://github.com/JuliaIO/CodecBzip2.jl), [CodecLZ4.jl](https://github.com/JuliaIO/CodecLz4.jl), and [CodecZstd.jl](https://github.com/JuliaIO/CodecZstd.jl). Default filters as well as Blosc compression is currently implemented in HDF5.jl.

The plugins themselves, which implement glue code between HDF5 and the individual codecs, are implemented in Julia after having been ported from C.

## See Also

* https://github.com/HDFGroup/hdf5_plugins
* https://github.com/nexusformat/HDF5-External-Filter-Plugins
* https://github.com/silx-kit/hdf5plugin