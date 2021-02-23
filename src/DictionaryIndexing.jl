module DictionaryIndexing

using OrderedCollections

(D::Dict)(i::Int) = Dict([keys(D)...][i] => [values(D)...][i])
(D::OrderedDict)(i::Int) = OrderedDict([keys(D)...][i] => [values(D)...][i])
(D::Dict)(is::AbstractVector{Int}) = Dict([([keys(D)...][i],[values(D)...][i]) for i in is])
(D::OrderedDict)(is::AbstractVector{Int}) = OrderedDict([([keys(D)...][i],[values(D)...][i]) for i in is])
(D::Dict)(is::Int...) = D([is...])
(D::OrderedDict)(is::Int...) = D([is...])
(D::Dict)(is::AbstractRange{Int}) = D([is...])
(D::OrderedDict)(is::AbstractRange{Int}) = D([is...])
(D::Dict)(is::AbstractRange{Int}...) = D([(is...)...])
(D::OrderedDict)(is::AbstractRange{Int}...) = D([(is...)...])

function (D::AbstractDict)(is...)
    indices = []
    for i in is
        if typeof(i) <: Union{AbstractRange{Int},AbstractArray{Int}}
            for j in i
                push!(indices, j)
            end
        elseif typeof(i) <: Int
            push!(indices, i)
        elseif typeof(i) <: AbstractArray
            return D(i...)
        else
            error("could not index this, arguments must be Ints, ranges of Ints, arrays of Ints, or a combo of those")
        end
    end
    return D(indices...)
end

end
