__precompile__()

module RegionTrees

using StaticArrays
import Base: show, size, getindex, parent, convert
export Cell,
       split!,
       isleaf,
       findleaf,
       children,
       parent,
       child_boundary,
       HyperRectangle,
       center,
       vertices,
       faces,
       body_and_face_centers,
       AbstractRefinery,
       needs_refinement,
       refine_data,
       initial_data,
       allcells,
       allleaves,
       AdaptiveSampling

include("twosarray.jl")
include("hyperrectangle.jl")
include("cell.jl")
include("adaptivesampling.jl")

end
