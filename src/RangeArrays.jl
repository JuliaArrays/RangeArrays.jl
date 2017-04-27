__precompile__()
module RangeArrays

using Compat

include("matrix.jl")
include("repeatedrange.jl")

export RangeMatrix, RepeatedRangeMatrix

end # module
