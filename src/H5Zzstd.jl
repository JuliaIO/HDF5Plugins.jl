module H5Zzstd

using HDF5
using CodecZstd
import CodecZstd.LibZstd
import ..TestUtils: test_filter

const H5Z_FILTER_ZSTD = 32015
const API = HDF5
const zstd_name = "Zstandard compression: http://www.zstd.net"

export H5Z_filter_zstd, H5Z_FILTER_ZSTD, register_zstd

# Derived from https://github.com/aparamon/HDF5Plugin-Zstandard, zstd_h5plugin.c
# Originally licensed under Apache License Version 2.0
# See LICENSE

function H5Z_filter_zstd(flags::Cuint, cd_nelmts::Csize_t,
                        cd_values::Ptr{Cuint}, nbytes::Csize_t,
                        buf_size::Ptr{Csize_t}, buf::Ptr{Ptr{Cvoid}})
    inbuf = unsafe_load(buf)
    outbuf = C_NULL
    origSize = nbytes
    ret_value = Csize_t(0)

    try
    
    if flags & API.H5Z_FLAG_REVERSE != 0
        #decompresssion

        decompSize = LibZstd.ZSTD_getDecompressedSize(inbuf, origSize)
        outbuf = Libc.malloc(decompSize)
        if outbuf == C_NULL
            error("zstd_h5plugin: Cannot allocate memory for outbuf during decompression.")
        end
        decompSize = LibZstd.ZSTD_decompress(outbuf, decompSize, inbuf, origSize)
        Libc.free(inbuf)
        unsafe_store!(buf, outbuf)
        outbuf = C_NULL
        ret_value = Csize_t(decompSize)
    else
        # compression

        if cd_nelmts > 0
            aggression = Cint(unsafe_load(cd_values))
        else
            aggression = CodecZstd.LibZstd.ZSTD_CLEVEL_DEFAULT
        end

        if aggression < 1
            aggression = 1 # ZSTD_minCLevel()
        elseif aggression > LibZstd.ZSTD_maxCLevel()
            aggression = LibZstd.ZSTD_maxCLevel()
        end

        compSize = LibZstd.ZSTD_compressBound(origSize)
        outbuf = Libc.malloc(compSize)
        if outbuf == C_NULL
            error("zstd_h5plugin: Cannot allocate memory for outbuf during compression.")
        end

        compSize = LibZstd.ZSTD_compress(outbuf, compSize, inbuf, origSize, aggression)

        Libc.free(unsafe_load(buf))
        unsafe_store!(buf, outbuf)
        unsafe_store!(buf_size, compSize)
        outbuf = C_NULL
        ret_value = compSize
    end
    catch err
        rethrow(err)
    finally

    if outbuf != C_NULL
        free(outbuf)
    end

    end
    return ret_value

end

function test_zstd_filter()
    cd_values = Cuint[3] # aggression
    test_filter(H5Z_filter_zstd; cd_values = cd_values)
end

function register_zstd()
    c_zstd_filter = @cfunction(H5Z_filter_zstd, Csize_t,
                              (Cuint, Csize_t, Ptr{Cuint}, Csize_t,
                               Ptr{Csize_t}, Ptr{Ptr{Cvoid}}))
    API.h5z_register(API.H5Z_class_t(
        API.H5Z_CLASS_T_VERS,
        H5Z_FILTER_ZSTD,
        1,
        1,
        pointer(zstd_name),
        C_NULL,
        C_NULL,
        c_zstd_filter
    ))
    return nothing
end

end # module H5Zzstd