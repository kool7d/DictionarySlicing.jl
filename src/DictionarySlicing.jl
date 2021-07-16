module DictionarySlicing

using OrderedCollections

export collectall, slice, directslicing

"""
    collectall(sets...; maxdepth=5)

Recursively collects elements from `sets`.

Keyword arguments:
maxdepth --------- determines maximum recursion level
currentdepth ----- current recursion level
"""
function collectall(sets...; maxdepth = 5, currentdepth = 1)
	ff = []
	f1 = collect([sets...])
	f2 = collect([Base.Iterators.flatten(f1)...])

    for x in f2
		if typeof(x) <: Union{AbstractArray,AbstractRange} && currentdepth < maxdepth
			xx = try
                collect([Base.Iterators.flatten(x)...])
            catch
                collect(x)
            end
			push!(ff,collectall(xx; maxdepth, currentdepth = currentdepth+1)...)
		else
			push!(ff,x)
		end
	end
    
	typ = typeof(ff[1])
    try
        ff = Vector{typ}(ff)
    catch

    end
    
	return ff
end

"""
    sliced(D::T, idxs...; keep = :first, filter = nothing) where {T<:AbstractDict}

Returns the slices from dict `D`.

Keyword args:
keep --------- either keep the :first or :last instance of a slice
filter ------- true/false-returning function to apply to collected indices
"""
function sliced(D::T, idxs...; keep = :first, filter = nothing) where {T<:AbstractDict}
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
"""
    directslicing()

Activates indexing/slicing for OrderedDict with function indexing.
"""
function directslicing()
	@eval(function (D::OrderedDict)(idxs...; keep = :first, filter = nothing)
		indices = collectall(idxs...)

		if filter != nothing
			try
				if keep == :lastbefore || keep == "lastbefore"
					revindices = reverse(indices)
					revindices = Base.filter(filter,revindices)
					od = OrderedDict([([keys(D)...][i],[values(D)...][i]) for i in revindices])
					rv = length(od):-1:1
					return od(rv...)
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
			od = OrderedDict([([keys(D)...][i],[values(D)...][i]) for i in revindices])
			rv = length(od):-1:1
			return od(rv...)
		end

	    return OrderedDict([([keys(D)...][i],[values(D)...][i]) for i in indices])
	end)
end

end
