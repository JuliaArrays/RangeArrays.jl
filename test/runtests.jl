using RangeArrays
using Base.Test

# Regular RangeMatrix tests

R = RangeMatrix(UnitRange{Int}[1:10, 11:20, 21:30, 31:40])

@test vec(collect(R)) == collect(1:40)
@test R[1,1] == 1

for i=1:40
    @test R[i] == i
end
j = 0
for i in eachindex(R)
    j+=1
    @test R[i] == j
end

@test_throws BoundsError R[0]
@test_throws BoundsError R[41]

@test_throws BoundsError R[:, 0]
@test R[:, 1] == 1:10
@test R[:, 2] == 11:20
@test R[:, 3] == 21:30
@test R[:, 4] == 31:40
@test_throws BoundsError R[:, 5]

@test R[:, 1:2] == RangeMatrix(1:10, 11:20)
@test R[:, 1:4] == R[:,:] == RangeMatrix(1:10, 11:20, 21:30, 31:40)
@test R[:, 3:4] == RangeMatrix(21:30, 31:40)

# RepeatedRangeMatrix tests
R = RepeatedRangeMatrix(1:10, 0:10:30)

@test vec(collect(R)) == collect(1:40)
@test R[1,1] == 1

for i=1:40
    @test R[i] == i
end
j = 0
for i in eachindex(R)
    j+=1
    @test R[i] == j
end

@test_throws BoundsError R[0]
@test_throws BoundsError R[41]

@test_throws BoundsError R[:, 0]
@test R[:, 1] == 1:10
@test R[:, 2] == 11:20
@test R[:, 3] == 21:30
@test R[:, 4] == 31:40
@test_throws BoundsError R[:, 5]

@test R[:, 1:2] == RangeMatrix(1:10, 11:20)
@test R[:, 1:4] == R[:,:] == RangeMatrix(1:10, 11:20, 21:30, 31:40)
@test R[:, 3:4] == RangeMatrix(21:30, 31:40)
