# RangeArrays

[![Build Status](https://travis-ci.org/mbauman/RangeArrays.jl.svg?branch=master)](https://travis-ci.org/mbauman/RangeArrays.jl) [![Coverage Status](https://coveralls.io/repos/mbauman/RangeArrays.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/mbauman/RangeArrays.jl?branch=master)

The goal of RangeArrays is to provide an efficient and convenient array data
structure where the columns of the array are generated (on the fly) by Ranges.

Three different types of range matrices are currently supported:
* `RangeMatrix`: makes a vector of ranges behave as a matrix; all ranges must be the same length.
* `RepeatedRangeMatrix`: one range is repeated multiple times at offsets specified in a vector.

In all cases, indexing is specialized such that it will return an appropriate RangeArray if it can.

```jl
julia> R = RangeMatrix(1:5,11:15,-2:2)
5x3 RangeArrays.RangeMatrix{Int64,Array{UnitRange{Int64},1}}:
 1  11  -2
 2  12  -1
 3  13   0
 4  14   1
 5  15   2

julia> R[2:3,:]
2x3 RangeArrays.RangeMatrix{Int64,Array{UnitRange{Int64},1}}:
 2  12  -1
 3  13   0

julia> RepeatedRangeMatrix(.1:.1:1.0, [5.,-20.2,3.3])
10x3 RangeArrays.RepeatedRangeMatrix{Float64,FloatRange{Float64},Array{Float64,1}}:
 5.1  -20.1  3.4
 5.2  -20.0  3.5
 5.3  -19.9  3.6
 5.4  -19.8  3.7
 5.5  -19.7  3.8
 5.6  -19.6  3.9
 5.7  -19.5  4.0
 5.8  -19.4  4.1
 5.9  -19.3  4.2
 6.0  -19.2  4.3
```

There is a similar structure available in
[RaggedArrays.jl](http://github.com/mbauman/RaggedArrays.jl), which allows for
ranges of varying lengths.
