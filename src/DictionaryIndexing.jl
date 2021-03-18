module DictionaryIndexing

using OrderedCollections

function (D::AbstractDict)(idxs...)
    indices = []
    for i in idxs
        if typeof(i) <: Union{AbstractRange,AbstractArray}
            for j in i
                push!(indices,j)
            end
        elseif typeof(i) <: Int
            push!(indices,i)
        else
            error("could not index this, arguments must be Ints, ranges of Ints, arrays of Ints, or a combo of those")
        end
    end
    return OrderedDict([([keys(D)...][i],[values(D)...][i]) for i in indices])
end

end
