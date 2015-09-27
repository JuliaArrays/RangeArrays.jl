using RaggedArrays

"""
    RaggedRangeMatrix{T<:Range}(rs::AbstractVector{T})

A RaggedRangeMatrix is a simple matrix representation of a vector of ranges,
with each range representing one column. Make a vector of ranges behave like a
ragged matrix by passing it to the constructor. The ranges may have different
lengths and the vector of ranges is not copied.

Similar to RangeMatrix, it is only efficient when the vector of ranges is
concretely typed.
"""
immutable RaggedRangeMatrix{T,A} <: AbstractRaggedArray{T,2,1,1}
    rs::A # A <: AbstractVector{_<:Range{T}}
    # TODO: maybe cache the maximum extents (maxlengths(rs), length(rs))?
end
RaggedRangeMatrix(rs::Range...) = RaggedRangeMatrix(collect(rs)) # TODO: use tuple storage?
RaggedRangeMatrix{T<:Range}(rs::AbstractVector{T}) = RaggedRangeMatrix{eltype(T), typeof(rs)}(rs)

# Simple devectorization helper functions
function maxlengths(xs::AbstractVector)
    m = 0
    for x in xs
        m = max(length(x), m)
    end
    m
end
function sumlengths(xs::AbstractVector)
    s = 0
    for x in xs
        s += length(x)
    end
    s
end

Base.length(R::RaggedRangeMatrix) = sumlengths(R.rs)
Base.size(R::RaggedRangeMatrix) = (maxlengths(R.rs), length(R.rs))
function Base.size(R::RaggedRangeMatrix, d)
    d == 1 && return RaggedDimension([length(x) for x in R.rs])
    d == 2 && return length(R.rs)
    d > 2 && return 1
    throw(ArgumentError("dimension must be > 0"))
end

# Scalar indexing
Base.getindex(R::RaggedRangeMatrix, i::Int, j::Int) = (checkbounds(R, i, j); ragged_unsafe_getindex(R, i, j))
import RaggedArrays: ragged_unsafe_getindex
ragged_unsafe_getindex(R::RaggedRangeMatrix, i::Int, j::Int) = @inbounds return R.rs[j][i]

# For non-scalar indexing, only specialize with inner Ranges and Colons to
# return Ranges or RangeMatrixes. For everything else, we can use the fallbacks.
Base.getindex(R::RaggedRangeMatrix, I::Union{Range, Colon}, J) = (checkbounds(R, I, J); ragged_unsafe_getindex(R, I, J))
# This is intentionally not spelled Base.unsafe_getindex!
ragged_unsafe_getindex(R::RaggedRangeMatrix, I::Range, j::Number) = @inbounds return R.rs[j][I]
ragged_unsafe_getindex(R::RaggedRangeMatrix, ::Colon,  j::Number) = @inbounds return R.rs[j]
ragged_unsafe_getindex(R::RaggedRangeMatrix, I::Range, ::Colon)   = @inbounds return RangeMatrix([R.rs[j][I] for j=1:length(R.rs)])
ragged_unsafe_getindex(R::RaggedRangeMatrix, I::Range, J)         = @inbounds return RangeMatrix([R.rs[j][I] for j in J])
ragged_unsafe_getindex(R::RaggedRangeMatrix, ::Colon,  ::Colon)   = @inbounds return RaggedRangeMatrix([R.rs[j] for j=1:length(R.rs)])
ragged_unsafe_getindex(R::RaggedRangeMatrix, ::Colon,  J)         = @inbounds return RaggedRangeMatrix([R.rs[j] for j in J])
