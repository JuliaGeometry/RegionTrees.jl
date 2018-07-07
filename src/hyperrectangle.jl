struct HyperRectangle{N, T}
    origin::SVector{N, T}
    widths::SVector{N, T}
end

@generated function vertices(rect::HyperRectangle{N}) where N
    verts = Expr[]
    for I in CartesianIndices(tuple([2 for i in 1:N]...))
        push!(verts,
        Expr(:call,
        :SVector,
        [I[i] == 1 ? :(rect.origin[$i]) : :(rect.origin[$i] + rect.widths[$i]) for i in 1:N]...))
    end
    Expr(:call, :TwosArray, verts...)
end

center(rect::HyperRectangle) = rect.origin + 0.5 * rect.widths

convert(::Type{HyperRectangle{N, T2}}, r::HyperRectangle{N, T1}) where {N, T1, T2} =
    HyperRectangle{N, T2}(convert(SVector{N, T2}, r.origin),
                          convert(SVector{N, T2}, r.widths))

@generated function faces(rect::HyperRectangle{N}) where N
    quote
        verts = vertices(rect)
        SVector($(Expr(:tuple, [:(slicedim(verts, $d, $i)) for i in 1:2 for d in 1:N]...)))
    end
end


struct BodyAndFaceCenters{N, T}
    rect::HyperRectangle{N, T}
end

function Base.iterate(b::BodyAndFaceCenters, i=0)
    if i > lastindex(faces(rect))
        return nothing
    elseif i == 0
        return center(b.rect), i + 1
    else
        @inbounds f = faces(b.rect)[i]
        return sum(f) ./ length(f), i + 1
    end
end

body_and_face_centers(rect::HyperRectangle) = BodyAndFaceCenters(rect)
