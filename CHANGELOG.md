# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/2.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Types of changes:

- Added
- Changed
- Deprecated
- Removed
- Fixed
- Security

## [Unreleased]

## [0.3.4] - 2026-07-16

### Removed

- unused `IterTools.jl` dependency ([#52])

## [0.3.3] - 2026-07-04

### Changed

- type unstable channels are now typed ([#43])

### Fixed

- CI ([#49])
- type instability of non-Float64 types ([#48])
- `adaptivesampling!` subsequent calls failing ([#45])

[unreleased]: https://github.com/JuliaGeometry/RegionTrees.jl/compare/v0.3.4..HEAD
[0.3.4]: https://github.com/JuliaGeometry/RegionTrees.jl/releases/tag/v0.3.4
[0.3.3]: https://github.com/JuliaGeometry/RegionTrees.jl/releases/tag/v0.3.3
[#52]: https://github.com/JuliaGeometry/RegionTrees.jl/pull/52
[#43]: https://github.com/JuliaGeometry/RegionTrees.jl/issues/43
[#45]: https://github.com/JuliaGeometry/RegionTrees.jl/pull/45
[#48]: https://github.com/JuliaGeometry/RegionTrees.jl/pull/48
[#49]: https://github.com/JuliaGeometry/RegionTrees.jl/pull/49
