module DictionarySlicing

using OrderedCollections

function slice(D::T, idxs...; keep = :first, filter = nothing) where {T<:AbstractDict}
    indices = []

    for i in idxs
        if typeof(i) <: Union{AbstractRange{Int},AbstractArray{Int}}
            for j in i
                push!(indices,j)
            end
        elseif typeof(i) <: Integer
            push!(indices,i)
        else
            error("could not index this, arguments must be Ints, ranges of Ints, or arrays of Ints")
        end
    end
	if filter != nothing
		try
			if keep == :lastbefore || keep == "lastbefore"
				revindices = reverse(indices)
				revindices = Base.filter(filter,revindices)
				dd = OrderedDict([([keys(D)...][i],[values(D)...][i]) for i in revindices])
				rv = length(dd):-1:1
				return slice(dd,rv...)
			elseif keep == :firstbefore || keep == "firstbefore"
				indices = unique(indices)
				return slice(D,indices...; filter = filter)
			else
				indices = Base.filter(filter,indices)
			end
		catch
			error("could not filter")
		end
	end
	if keep == :last || keep == "last"
		revindices = reverse(indices)
		dd = OrderedDict([([keys(D)...][i],[values(D)...][i]) for i in revindices])
		rv = length(dd):-1:1
		return slice(dd,rv...)
	end
	ks = [[keys(D)...][i] for i in indices]
	vs = [[values(D)...][i] for i in indices]

    return T(ks.=>vs)
end

function directslicing()
	@eval(function (D::OrderedDict)(idxs...; keep = :first, filter = nothing)
	    indices = []

	    for i in idxs
	        if typeof(i) <: Union{AbstractRange{Int},AbstractArray{Int}}
	            for j in i
	                push!(indices,j)
	            end
	        elseif typeof(i) <: Integer
	            push!(indices,i)
	        else
	            error("could not index this, arguments must be Ints, ranges of Ints, or arrays of Ints")
	        end
	    end
		if filter != nothing
			try
				if keep == :lastbefore || keep == "lastbefore"
					revindices = reverse(indices)
					revindices = Base.filter(filter,revindices)
					dd = OrderedDict([([keys(D)...][i],[values(D)...][i]) for i in revindices])
					rv = length(dd):-1:1
					return dd(rv...)
				elseif keep == :firstbefore || keep == "firstbefore"
					indices = unique(indices)
					return D(indices...; filter = filter)
				else
					indices = Base.filter(filter,indices)
				end
			catch
				error("could not filter")
			end
		end
		if keep == :last || keep == "last"
			revindices = reverse(indices)
			dd = OrderedDict([([keys(D)...][i],[values(D)...][i]) for i in revindices])
			rv = length(dd):-1:1
			return dd(rv...)
		end

	    return OrderedDict([([keys(D)...][i],[values(D)...][i]) for i in indices])
	end)
end

end
