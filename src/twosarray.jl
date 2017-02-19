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

"""
Highly specialized slicedim implementation for TwosArray (an array of size
2 along every dimension). Returns a TwosArray with N-1 dimensions. See
`test/twosarray.jl` for exhaustive testing of this function. This is about
100 times faster than Julia's base slicedim().
"""
@generated function Base.slicedim{N, T}(A::TwosArray{N, T}, d::Integer, i::Integer)
    quote
        x = 2^(d - 1)
        j = 1
        k = 1
        TwosArray($(Expr(:tuple, [quote
            z = j
            j += 1
            if k < x
                k += 1
            else
                j += x
                k = 1
            end
            A[z + (i - 1) * x]
        end for n in 1:(2^(N - 1))]...)))
    end
end

similar_type{N, T, L, T2}(::Type{TwosArray{N, T, L}}, ::Type{T2}) = TwosArray{N, T2, L}
