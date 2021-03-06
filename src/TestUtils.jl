module TestUtils

using HDF5
const API = HDF5
#const API = HDF5.API

export test_filter

function test_filter_init(; cd_values = Cuint[], data = ones(UInt8, 1024))
    flags = Cuint(0)
    nbytes = sizeof(data)
    buf_size = Ref(Csize_t(sizeof(data)))
    databuf = Libc.malloc(sizeof(data))
    data = reinterpret(UInt8, data)
    unsafe_copyto!(Ptr{UInt8}(databuf), pointer(data), sizeof(data))
    buf = Ref(Ptr{Cvoid}(databuf))
    return flags, cd_values, nbytes, buf_size, buf
end

function test_filter_compress!(filter_func, flags::Cuint, cd_values::Vector{Cuint}, nbytes::Integer, buf_size::Ref{Csize_t}, buf::Ref{Ptr{Cvoid}})
    nbytes = Csize_t(nbytes)
    cd_nelmts = Csize_t(length(cd_values))
    GC.@preserve flags cd_nelmts cd_values nbytes buf_size buf begin
        ret_code = filter_func(
            flags,
            cd_nelmts,
            pointer(cd_values),
            Csize_t(nbytes),
            Base.unsafe_convert(Ptr{Csize_t}, buf_size),
            Base.unsafe_convert(Ptr{Ptr{Cvoid}}, buf)
        )
        @info "Compression:" ret_code buf_size[]
        if ret_code <= 0
            error("Test compression failed: $ret_code.")
        end
    end
    return ret_code
end

function test_filter_decompress!(filter_func, flags::Cuint, cd_values::Vector{Cuint}, nbytes::Integer, buf_size::Ref{Csize_t}, buf::Ref{Ptr{Cvoid}})
    nbytes = Csize_t(nbytes)
    cd_nelmts = Csize_t(length(cd_values))
    flags |= UInt32(API.H5Z_FLAG_REVERSE)
    GC.@preserve flags cd_nelmts cd_values nbytes buf_size buf begin
        ret_code = filter_func(
            flags,
            cd_nelmts,
            pointer(cd_values),
            Csize_t(nbytes),
            Base.unsafe_convert(Ptr{Csize_t},buf_size),
            Base.unsafe_convert(Ptr{Ptr{Cvoid}}, buf)
        )
        @info "Decompression:" ret_code buf_size[]
    end
    return ret_code
end

function test_filter_cleanup!(buf::Ref{Ptr{Cvoid}})
    Libc.free(buf[])
end

function test_filter(filter_func; cd_values::Vector{Cuint} = Cuint[], data = ones(UInt8, 1024))
    flags, cd_values, nbytes, buf_size, buf = test_filter_init(; cd_values = cd_values, data = data)
    nbytes_compressed, nbytes_decompressed = 0, 0
    try
        nbytes_compressed = test_filter_compress!(filter_func, flags, cd_values, nbytes, buf_size, buf)
        nbytes_decompressed = test_filter_decompress!(filter_func, flags, cd_values, nbytes_compressed, buf_size, buf)
        if nbytes_decompressed > 0
            # ret_code is the number of bytes out
            round_trip_data = unsafe_wrap(Array,Ptr{UInt8}(buf[]), nbytes_decompressed)
            @info "Is the data the same after a roundtrip?" data == round_trip_data
        end
    catch err
        rethrow(err)
    finally
        test_filter_cleanup!(buf)
    end
    @info "Compression Ratio" nbytes_compressed / nbytes_decompressed
    return nbytes_compressed, nbytes_decompressed
end

end