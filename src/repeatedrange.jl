"""
    RepeatedRangeMatrix{T}(r::Range{T}, at::AbstractVector{T})

A RepeatedRange is like a RangeMatrix, except that it only stores one range and
a vector of offsets, at which the range repeats. For now, both the range and
vector of offsets must have the same element type.
"""
immutable RepeatedRangeMatrix{T,R,A} <: AbstractMatrix{T}
    r::R # <: Range{T}
    at::A #<: AbstractVector{T}
end
RepeatedRangeMatrix{T}(r::Range{T}, at::AbstractVector{T}) = RepeatedRangeMatrix{T, typeof(r), typeof(at)}(r, at)

Base.size(R::RepeatedRangeMatrix) = (length(R.r), length(R.at))
@compat Base.IndexStyle(::Type{<:RepeatedRangeMatrix}) = IndexCartesian()

# Scalar indexing
@inline function Base.getindex(R::RepeatedRangeMatrix, i::Int, j::Int)
    @boundscheck checkbounds(R, i, j)
    @inbounds return R.r[i] + R.at[j]
end

# For non-scalar indexing, only specialize with inner Ranges and Colons to
# return Ranges or RangeMatrixes. For everything else, we can use the fallbacks.
@inline function Base.getindex(R::RepeatedRangeMatrix, I::Union{Range, Colon}, j::Real)
    @boundscheck checkbounds(R, I, j)
    @inbounds return R.r[I] + R.at[j]
end
@inline function Base.getindex(R::RepeatedRangeMatrix, I::Union{Range, Colon}, J)
    @boundscheck checkbounds(R, I, J)
    @inbounds return RepeatedRangeMatrix(R.r[I], R.at[J])
end

# We can also optimize bounds checks to only look at the range's endpoints
function Base.checkindex(::Type{Bool}, inds::AbstractUnitRange, R::RepeatedRangeMatrix)
    b = true
    @inbounds for a in R.at
        b &= checkindex(Bool, inds, R.r[1] + a)
        b &= checkindex(Bool, inds, R.r[end] + a)
    end
    b
end
