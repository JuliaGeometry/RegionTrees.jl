module BinaryRegionTrees

using StaticArrays
import Base: show, size, getindex, parent
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
include("treecell.jl")
include("asdfs.jl")

end
    