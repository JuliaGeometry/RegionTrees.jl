mutable struct Cell{Data, N, T, L}
    boundary::HyperRectangle{N, T}
    data::Data
    divisions::SVector{N, T}
    children::Union{TwosArray{N, Cell{Data, N, T, L}, L}, Nothing}
    parent::Union{Cell{Data, N, T, L}, Nothing}
end

function Cell(origin::SVector{N, T}, widths::SVector{N, T}, data::Data=nothing) where {Data, N, T}
    Cell(HyperRectangle(origin, widths), data)
end

@generated function Cell(boundary::HyperRectangle{N, T}, data::Data=nothing) where {Data, N, T}
    L = 2^N
    return quote
        T2 = Base.promote_op(/, T, Int)
        Cell{Data, N, T2, $L}(boundary,
             data,
             boundary.origin + boundary.widths / 2,
             nothing,
             nothing)
    end
end

@inline isleaf(cell::Cell) = cell.children === nothing
@inline children(cell::Cell) = cell.children
@inline parent(cell::Cell) = cell.parent
@inline center(cell::Cell) = center(cell.boundary)
@inline vertices(cell::Cell) = vertices(cell.boundary)

@inline size(::Type{C}) where {C <: Cell} = ()
@inline size(cell::Cell) = size(typeof(cell))

show(io::IO, cell::Cell) = print(io, "Cell: $(cell.boundary)")

@inline getindex(cell::Cell) = cell
@inline getindex(cell::Cell, ::CartesianIndex{0}) = cell
@inline getindex(cell::Cell, I) = getindex(cell.children, I)
@inline getindex(cell::Cell, I...) = getindex(cell.children, I...)

function child_boundary(cell::Cell, indices)
    HyperRectangle(cell.boundary.origin + 0.5 * (SVector(indices) - 1) .* cell.boundary.widths,
                   cell.boundary.widths / 2)
end

@generated function map_children(f::Function, cell::Cell{Data, N, T, L}) where {Data, N, T, L}
    Expr(:call, :TwosArray, Expr(:tuple,
        [:(f(cell, $(I.I))) for I in CartesianIndices(ntuple(_ -> 2, Val(N)))]...))
end


child_indices(cell::Cell{Data, N, T, L}) where {Data, N, T, L} = child_indices(Val(N))

@generated function child_indices(::Val{N}) where N
    Expr(:call, :TwosArray, Expr(:tuple,
        [I.I for I in CartesianIndices(ntuple(_ -> 2, Val(N)))]...))
end

function split!(cell::Cell{Data, N}) where {Data, N}
    split!(cell, (c, I) -> cell.data)
end

@generated function split!(cell::Cell{Data, N}, child_data::AbstractArray) where {Data, N}
    split!_impl(cell, child_data, Val(N))
end

split!(cell::Cell, child_data_function::Function) =
    split!(cell, map_children(child_data_function, cell))

function split!_impl(::Type{C}, child_data, ::Val{N}) where {C <: Cell, N}
    child_exprs = [:(Cell(child_boundary(cell, $(I.I)),
                          child_data[$i])) for (i, I) in enumerate(CartesianIndices(ntuple(_ -> 2, Val(N))))]
    quote
        @assert isleaf(cell)
        cell.children = $(Expr(:call, :TwosArray, Expr(:tuple, child_exprs...)))
        for child in cell.children
            child.parent = cell
        end
        cell
    end
end

@generated function findleaf(cell::Cell{Data, N}, point::AbstractVector) where {Data, N}
    quote
        while true
            if isleaf(cell)
                return cell
            end
            length(point) == $N || throw(DimensionMismatch("expected a point of length $N"))
            @inbounds cell = $(Expr(:ref, :cell, [:(ifelse(point[$i] >= cell.divisions[$i], 2, 1)) for i in 1:N]...))
        end
    end
end

function allcells(cell::Cell)
    Channel() do c
        queue = [cell]
        while !isempty(queue)
            current = pop!(queue)
            put!(c, current)
            if !isleaf(current)
                append!(queue, children(current))
            end
        end
    end
end

function allleaves(cell::Cell)
    Channel() do c
        for child in allcells(cell)
            if isleaf(child)
                put!(c, child)
            end
        end
    end
end
