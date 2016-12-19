import Iterators: chain

immutable HyperRectangle{N, T}
    origin::SVector{N, T}
    widths::SVector{N, T}
end

@generated function vertices{N}(rect::HyperRectangle{N})
    verts = Expr[]
    for I in CartesianRange(tuple([2 for i in 1:N]...))
        push!(verts,
        Expr(:call,
        :SVector,
        [I[i] == 1 ? :(rect.origin[$i]) : :(rect.origin[$i] + rect.widths[$i]) for i in 1:N]...))
    end
    Expr(:call, :TwosArray, verts...)
end

center(rect::HyperRectangle) = rect.origin + 0.5 * rect.widths

convert{N, T1, T2}(::Type{HyperRectangle{N, T2}}, r::HyperRectangle{N, T1}) =
    HyperRectangle{N, T2}(convert(SVector{N, T2}, r.origin),
                          convert(SVector{N, T2}, r.widths))

@generated function faces{N}(rect::HyperRectangle{N})
    quote
        verts = vertices(rect)
        SVector($(Expr(:tuple, [:(slicedim(verts, $d, $i)) for i in 1:2 for d in 1:N]...)))
    end
end

function body_and_face_centers(rect::HyperRectangle)
    chain((center(rect),), mean.(faces(rect)))
end
