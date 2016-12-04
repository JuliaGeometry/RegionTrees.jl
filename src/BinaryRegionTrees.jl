module BinaryRegionTrees

using StaticArrays
import Base: show, size, getindex, parent, convert
export Cell, 
       split!, 
       isleaf,
       children,
       parent,
       child_boundary,
       map_children,
       HyperRectangle,
       center,
       vertices

include("twosarray.jl")
include("hyperrectangle.jl")
include("cell.jl")
include("asdfs.jl")

end
    