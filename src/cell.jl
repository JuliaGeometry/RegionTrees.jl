type Cell{Data, N, T, L}
    boundary::HyperRectangle{N, T}
    data::Data
    divisions::SVector{N, T}
    children::Nullable{TwosArray{N, Cell{Data, N, T, L}, L}}
    parent::Nullable{Cell{Data, N, T, L}}
end

function Cell{Data, N, T}(origin::SVector{N, T}, widths::SVector{N, T}, data::Data=nothing)
    Cell(HyperRectangle(origin, widths), data)
end

@generated function Cell{Data, N, T}(boundary::HyperRectangle{N, T}, data::Data=nothing)
    L = 2^N
    return quote
        T2 = Base.promote_op(/, T, Int)
        Cell{Data, N, T2, $L}(boundary,
             data,
             boundary.origin + boundary.widths / 2,
             Nullable{}(),
             Nullable{}())
    end
end

@inline isleaf(cell::Cell) = isnull(cell.children)
@inline children(cell::Cell) = get(cell.children)
@inline parent(cell::Cell) = get(cell.parent)
@inline center(cell::Cell) = center(cell.boundary)
@inline vertices(cell::Cell) = vertices(cell.boundary)

@inline size{C <: Cell}(::Type{C}) = ()
@inline size(cell::Cell) = size(typeof(cell))

show(io::IO, cell::Cell) = print(io, "Cell: $(cell.boundary)")

@inline getindex(cell::Cell) = cell
@inline getindex(cell::Cell, ::CartesianIndex{0}) = cell
@inline getindex(cell::Cell, I) = getindex(get(cell.children), I)
@inline getindex(cell::Cell, I...) = getindex(get(cell.children), I...)

function child_boundary(cell::Cell, indices)
    HyperRectangle(cell.boundary.origin + 0.5 * (SVector(indices) - 1) .* cell.boundary.widths,
                   cell.boundary.widths / 2)
end

@generated function map_children{Data, N, T, L}(f::Function, cell::Cell{Data, N, T, L})
    Expr(:call, :TwosArray, Expr(:tuple,
        [:(f(cell, $(I.I))) for I in CartesianRange(ntuple(_ -> 2, Val{N}))]...))
end


child_indices{Data, N, T, L}(cell::Cell{Data, N, T, L}) = child_indices(Val{N})

@generated function child_indices{N}(::Type{Val{N}})
    Expr(:call, :TwosArray, Expr(:tuple,
        [I.I for I in CartesianRange(ntuple(_ -> 2, Val{N}))]...))
end

function split!{Data, N}(cell::Cell{Data, N})
    split!(cell, (c, I) -> cell.data)
end

@generated function split!{Data, N}(cell::Cell{Data, N}, child_data::AbstractArray)
    split!_impl(cell, child_data, Val{N})
end

split!(cell::Cell, child_data_function::Function) =
    split!(cell, map_children(child_data_function, cell))

function split!_impl{C <: Cell, N}(::Type{C}, child_data, ::Type{Val{N}})
    child_exprs = [:(Cell(child_boundary(cell, $(I.I)),
                          child_data[$i])) for (i, I) in enumerate(CartesianRange(ntuple(_ -> 2, Val{N})))]
    quote
        @assert isleaf(cell)
        cell.children = $(Expr(:call, :TwosArray, Expr(:tuple, child_exprs...)))
        for child in get(cell.children)
            child.parent = cell
        end
        cell
    end
end

@generated function findleaf{Data, N}(cell::Cell{Data, N}, point::AbstractVector)
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
    Task(() -> begin
        queue = [cell]
        while !isempty(queue)
            current = pop!(queue)
            produce(current)
            if !isleaf(current)
                append!(queue, children(current))
            end
        end
    end)
end

function allleaves(cell::Cell)
    Task(() -> begin
        for cell in allcells(cell)
            if isleaf(cell)
                produce(cell)
            end
        end
    end)
end
