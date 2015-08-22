# RangeArrays

[![Build Status](https://travis-ci.org/mbauman/RangeArrays.jl.svg?branch=master)](https://travis-ci.org/mbauman/RangeArrays.jl)

The goal of RangeArrays is to provide an efficient and convenient array data
structure where the columns of the array are generated (on the fly) by Ranges.

Currently supported are the `RangeMatrix`, where all ranges must be the same
length, and the `RaggedRangeMatrix`, which supports various-sized ranges as a
[RaggedArray](http://github.com/mbauman/RaggedArrays.jl).

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

julia> RR = RaggedRangeMatrix(1:3,3:6,7:12,-2:1)
6x4 RangeArrays.RaggedRangeMatrix{Int64,Array{UnitRange{Int64},1}}:
   1       3      7   -2
   2       4      8   -1
   3       5      9    0
 #undef    6     10    1
 #undef  #undef  11  #undef
 #undef  #undef  12  #undef

julia> RR[1:3,2:4]
3x3 RangeArrays.RangeMatrix{Int64,Array{UnitRange{Int64},1}}:
 3  7  -2
 4  8  -1
 5  9   0
```