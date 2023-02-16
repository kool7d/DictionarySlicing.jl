module DictionarySlicing

using Reexport
@reexport using OrderedCollections

export collectall, sliced, directslicing, reversekv, printkv

function collectkeys(args)
    return keys(args) |> collect
end

function collectvals(args)
    return values(args) |> collect
end

"""
    collectall(sets...; maxdepth=5)

Recursively collects elements from `sets`.

### Keyword Arguments:
- maxdepth = 5 --------- determines maximum recursion level
- currentdepth = 1 ----- current recursion level
"""
function collectall(sets...; maxdepth = 5, currentdepth = 1)
	ff = []
	f1 = collect([sets...])
	f2 = []
	for x in f1
		if typeof(x) <: Union{AbstractString,Symbol}
			push!(f2,x)
		else
			for y in collect([Base.Iterators.flatten(x)...])
				push!(f2,y)
			end
		end
	end

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
    
	return identity.(ff)
end

"""
    sliced(D::T, idxs...; keep = :first, filter = nothing, maxdepth = 5) where {T<:AbstractDict}

Returns the slices from dict `D`.

### Keyword Arguments:
- keep = :first ---------- either keep the :first or :last instance of a key
- filter = nothing ------- true/false-returning function to apply to collected inputs
- maxdepth = 5 ----------- determines maximum recursion level for collection of idxs
"""
function sliced(D::T, idxs...; keep = :first, filter = nothing, maxdepth = 5) where {T<:AbstractDict}
	inputs = collectall(idxs...; maxdepth = 5)
	
	if filter != nothing
		try
			if keep == :lastbefore || keep == "lastbefore"
				inputs = unique(inputs)
				revindices = reverse(inputs)
				revindices = Base.filter(filter,revindices)
				kvs = []
				ks = collectkeys(D)
				vs = collectvals(D)
				for inp in revindices
					if typeof(inp)<:Int
						push!(kvs,Pair(ks[inp],vs[inp]))
					else
						try
							push!(kvs,Pair(inp,D[inp]))
						catch
							inp = string(inp)
							push!(kvs,Pair(inp,D[inp]))
						end
					end
				end
				od = OrderedDict(kvs)
				rv = length(od):-1:1
				return sliced(od,rv...)
			elseif keep == :firstbefore || keep == "firstbefore"
				inputs = unique(inputs)
				return sliced(D,inputs...; filter = filter)
			else
				inputs = Base.filter(filter,inputs)
			end
		catch
			error("could not filter")
		end
	end
	if keep == :last || keep == "last"
		revindices = reverse(inputs)
		kvs = []
		ks = collectkeys(D)
		vs = collectvals(D)
		for inp in revindices
			if typeof(inp)<:Int
				push!(kvs,Pair(ks[inp],vs[inp]))
			else
				try
					push!(kvs,Pair(inp,D[inp]))
				catch
					inp = string(inp)
					push!(kvs,Pair(inp,D[inp]))
				end
			end
		end
		od = OrderedDict(kvs)
		rv = length(od):-1:1
		return sliced(od,rv...)
	end
	kvs = []
	ks = collectkeys(D)
	vs = collectvals(D)
	for inp in inputs
		if typeof(inp)<:Int
			push!(kvs,Pair(ks[inp],vs[inp]))
		else
			try
				push!(kvs,Pair(inp,D[inp]))
			catch
				inp = string(inp)
				push!(kvs,Pair(inp,D[inp]))
			end
		end
	end

    return OrderedDict(kvs)
end

"""
    directslicing()

Activates indexing/slicing for OrderedDict with function indexing.
`dict(2,3)` returns an OrderedDict of the 2nd and 3rd entry.

### Keyword Arguments:
- keep = :first ---------- either keep the :first or :last instance of a key
- filter = nothing ------- true/false-returning function to apply to collected inputs
- maxdepth = 5 ----------- determines maximum recursion level for collection of idxs
"""
function directslicing()
	@eval(function (D::OrderedDict)(idxs...; keep = :first, filter = nothing, maxdepth = 5)
		inputs = collectall(idxs...; maxdepth = 5)

		if filter != nothing
			try
				if keep == :lastbefore || keep == "lastbefore"
					inputs = unique(inputs)
					revindices = reverse(inputs)
					revindices = Base.filter(filter,revindices)
					kvs = []
					ks = collectkeys(D)
					vs = collectvals(D)
					for inp in revindices
						if typeof(inp)<:Int
							push!(kvs,Pair(ks[inp],vs[inp]))
						else
							try
								push!(kvs,Pair(inp,D[inp]))
							catch
								inp = string(inp)
								push!(kvs,Pair(inp,D[inp]))
							end
						end
					end
					od = OrderedDict(kvs)
					rv = length(od):-1:1
					return od(rv...)
				elseif keep == :firstbefore || keep == "firstbefore"
					inputs = unique(inputs)
					return D(inputs...; filter = filter)
				else
					inputs = Base.filter(filter,inputs)
				end
			catch
				error("could not filter")
			end
		end
		if keep == :last || keep == "last"
			revindices = reverse(inputs)
			kvs = []
			ks = collectkeys(D)
			vs = collectvals(D)
			for inp in revindices
				if typeof(inp)<:Int
					push!(kvs,Pair(ks[inp],vs[inp]))
				else
					try
						push!(kvs,Pair(inp,D[inp]))
					catch
						inp = string(inp)
						push!(kvs,Pair(inp,D[inp]))
					end
				end
			end
			od = OrderedDict(kvs)
			rv = length(od):-1:1
			return od(rv...)
		end
		kvs = []
		ks = collectkeys(D)
		vs = collectvals(D)
		for inp in inputs
			if typeof(inp)<:Int
				push!(kvs,Pair(ks[inp],vs[inp]))
			else
				try
					push!(kvs,Pair(inp,D[inp]))
				catch
					inp = string(inp)
					push!(kvs,Pair(inp,D[inp]))
				end
			end
		end

	    return OrderedDict(kvs)
	end)
end

function reversekv(dict::AbstractDict{K,V}) where {K,V}
	vkdict = [x[2].=>x[1] for x in dict]
    if typeof(dict) <: OrderedDict
        return OrderedDict{V,K}(vkdict)
    end
	return Dict{V,K}(vkdict)
end

function printkv(dict::AbstractDict)
	keys1 = collectkeys(dict)
	vals1 = collectvals(dict)
	println.(["$(keys1[i]) -> $(vals1[i])" for i in 1:size(keys1,1)])
	return nothing
end

typefields(thing) = typeof(thing) |> fieldnames

tyf(thing) = typefields(thing)

end
