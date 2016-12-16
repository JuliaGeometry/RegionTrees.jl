# RegionTrees.jl: Quadtrees, Octrees, and their N-Dimensional Cousins

[![Build Status](https://travis-ci.org/rdeits/RegionTrees.jl.svg?branch=master)](https://travis-ci.org/rdeits/RegionTrees.jl)
[![codecov](https://codecov.io/gh/rdeits/RegionTrees.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/rdeits/RegionTrees.jl)

This package is a lightweight framework for defining N-Dimensional region trees. In 2D, these are called *region quadtrees*, and in 3D they are typically referred to as *octrees*. A region tree is a simple data structure used to describe some kind of spatial data with varying resolution. Each element in the tree can be a leaf, representing an N-dimensional rectangle of space, or a node which is divided exactly in half along each axis into 2^N children. In addition, each element in a `RegionTrees.jl` tree can carry an arbitrary data payload. This makes it easy to use `RegionTrees` to approximate functions or describe other interesting spatial data.

## Features

* Lightweight code with few dependencies (only `StaticArrays.jl` is required)
* Optimized for speed and for few memory allocations
    * Liberal use of `@generated` functions lets us unroll most loops and prevent allocating temporary arrays
* Built-in support for general adaptive sampling techniques

## Usage

See `examples/demo.ipynb` for a tour through the API. You can also check out:

* `examples/adaptive_distances.ipynb` for an adaptively-sampled distance field [1]
* `examples/adaptive_mpc.ipynb` for an adaptive approximation of a model-predictive controller

[1] Frisken et al. "Adaptively Sampled Distance Fields: A General Representation of Shape for Computer Graphics". SIGGRAPH 2000.
