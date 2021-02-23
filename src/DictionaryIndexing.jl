module DictionaryIndexing

using OrderedCollections

macro idxdict()
    quote
        (D::AbstractDict)(i::Int) = OrderedDict([keys(D)...][i] => [values(D)...][i])
        (D::AbstractDict)(is::AbstractVector{Int}) = OrderedDict([([keys(D)...][i],[values(D)...][i]) for i in is])
        (D::AbstractDict)(is::Int...) = D([is...])
        (D::AbstractDict)(is::AbstractRange{Int}) = D([is...])
        (D::AbstractDict)(is::AbstractRange{Int}...) = D([(is...)...])

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
end

end
