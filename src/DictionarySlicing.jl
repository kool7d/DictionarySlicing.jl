module DictionarySlicing

using OrderedCollections

function collectall(args...)
	ff = []
	f1 = collect([args...])
	f2 = collect([Base.Iterators.flatten(f1)...])
	for x in f2
		if typeof(x) <: Union{AbstractArray,AbstractRange}
			xx = collect([Base.Iterators.flatten(x)...])
			push!(ff,collectall(xx)...)
		else
			push!(ff,x)
		end
	end
	return ff
end

function slice(D::T, idxs...; keep = :first, filter = nothing) where {T<:AbstractDict}
	indices = collectall(idxs...)

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
		indices = collectall(idxs...)

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
