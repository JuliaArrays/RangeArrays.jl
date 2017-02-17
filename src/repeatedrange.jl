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
Base.getindex(R::RepeatedRangeMatrix, i::Int, j::Int) = (checkbounds(R, i, j); Base.unsafe_getindex(R, i, j))
Base.unsafe_getindex(R::RepeatedRangeMatrix, i::Int, j::Int) = @inbounds return R.r[i] + R.at[j]

# For non-scalar indexing, only specialize with inner Ranges and Colons to
# return Ranges or RangeMatrixes. For everything else, we can use the fallbacks.
Base.getindex(R::RepeatedRangeMatrix, I::Union{Range, Colon}, J) = (checkbounds(R, I, J); Base.unsafe_getindex(R, I, J))
Base.unsafe_getindex(R::RepeatedRangeMatrix, I::Union{Range, Colon}, j::Real) = @inbounds return R.r[I] + R.at[j]
Base.unsafe_getindex(R::RepeatedRangeMatrix, I::Union{Range, Colon}, ::Colon) = @inbounds return RepeatedRangeMatrix(R.r[I], R.at[:])
Base.unsafe_getindex(R::RepeatedRangeMatrix, I::Union{Range, Colon}, J)       = @inbounds return RepeatedRangeMatrix(R.r[I], R.at[J])
