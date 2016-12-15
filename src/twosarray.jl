
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

@generated function Base.slicedim{N, T}(a::TwosArray{N, T}, d::Integer, i::Integer)
    quote
        x = 2^(d - 1)
        y = 2 * x  # == 2^d
        TwosArray($(Expr(:tuple, [quote
            fm = fldmod($n - 1, x)
            a[y * fm[1] + fm[2] + 1 + (i - 1) * x]
        end for n in 1:(2^(N - 1))]...)))
    end
end
