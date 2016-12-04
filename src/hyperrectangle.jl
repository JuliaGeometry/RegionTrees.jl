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
