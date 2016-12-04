
"""
Represents a static array with N dimensions whose size is
exactly 2 along each dimension. This makes templating on 
the number of dimensions easier than with a regular
SArray. 
"""
immutable TwosArray{N, T, L} <: StaticArray{T, N}
    data::NTuple{L, T}
end

@generated function TwosArray{L, T}(x::NTuple{L, T})
    @assert log2(L) == round(log2(L)) "L must equal 2^N for integer N"
    N = Int(log2(L))
    :(TwosArray{$N, T, L}(x))
end

@generated size{N, T, L}(::Type{TwosArray{N, T, L}}) = Expr(:tuple, [2 for i in 1:N]...)
getindex(b::TwosArray, i::Integer) = b.data[i]