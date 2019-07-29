module CtagsTest

using Test
using Base.Sort.QuickSort
using Base.Sort: MergeSort, InsertionSort

#=
using Documenter
=#

import Distributed
import Base.show
import DelimitedFiles: readdlm, writedlm

struct ImmutablePoint{T}
    x::T
    y::T
end

mutable struct MutablePoint{T}
    x::T
    y::T
end

"""
    Names(first, last)

Contains the first and last name of a person.
Can be called with keywords.

# Example

```julia-repl
julia> Names(last="Bond", first="James") # Bond
Names("James", "Bond")
```
"""
Base.@kwdef struct Names
    first::AbstractString
    last::AbstractString
end

"""
    Names(first, last)

Contains the first and last name of a person.
Can be called with keywords.

# Examples
```jldoctest
julia> Names(last="Bond", first="James") # Bond
Names("James", "Bond")
```
"""
Base.@kwdef mutable struct VariableNames
    first::AbstractString
    last::AbstractString
end

# Lambda function
"""
    returnsquarepower()

Return the power used to square numbers.

# Examples
```jldoctest; output = false
mysquarepower = returnsquarepower()
# or
const myconstsquarepower = returnsquarepower()

# output

2
```
"""
returnsquarepower = () -> 2

#=
deprecated_returnsquarepower() = 2.0
const deprecated_squarepower = deprecated_returnsquarepower()
=#

"Number used to square – not cube – numbers."
squarepower = returnsquarepower
"A universally accepted greeting."
const greeting = "Hello"

function square(x)
    x ^ squarepower
end

function addone!(x::T) where {T <: Number}
    x += one(T)
end

addtwo!(x::T) where {T <: Number} = (x += one(T) + one(T))

addcoment(string::AbstractString, comment, spaces=1) = begin  # Maybe write without `begin`?
    string * " "^spaces * "# " * comment
end

multiply(x, y) = x * y
multiply(x, y...) = begin
    multiply(y...) * x
end

"""
    greet(x)

Generate different greeting strings depending on who you are talking to.

# Examples
```@meta
DocTestSetup = quote
    function printgreeting(x)
        println(greet(x))
    end
end
```

```jldoctest
julia> greet("Julia")
Hello Julia!

julia> greet(3141)
Hello Robot 3141!

julia> greet(0x1f)
Hello Robot 0x1f!

julia> greet(BitVector([1, 0, 1]))
Hello binary data 101!
```
"""
@generated function greet(x)
    if x <: Union{AbstractString, AbstractChar}
        :("$greeting $x!")
    elseif x <: Unsigned
        :("$greeting Robot 0x$(string(x, base=16))!")
    elseif x <: Number
        :("$greeting Robot $(string(x))!")
    else
        :("$greeting binary data $(bitstring(x))!")
    end
end

# TODO add `greet` for aliens

greet("Julia")

end # module

