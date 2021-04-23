# DictionarySlicing

Enables slicing dictionaries with `slice`, or directly by using function syntax.

Example using slice:
```julia
using DictionarySlicing

dd = OrderedDict(:Apl => "apple",
		 :Brc => "birch",
		 :Cnd => "candle",
		 :Drn => "dragon",
		 :Exp => "expensive",
		 :Frg => "forage",
		 :Gra => "grain",
		 :Hlt => "health",
		 :Irn => "irony",
		 :Jak => "jackal" )     # length is 10

dxs = slice(dd, 4)

	OrderedDict{Symbol, String} with 1 entry:
	  :Drn => "dragon"

dxs = slice(dd, 2, 4:5, [7,8], 5:length(dd), [8,5])  # instead of `end` we get the last index with `length`

	OrderedDict{Symbol, String} with 8 entries:
	  :Brc => "birch"           		 #  2
	  :Drn => "dragon"			 #  4
	  :Exp => "expensive"		 	 #  5
	  :Gra => "grain"  			 #  7
	  :Hlt => "health"			 #  8
	  :Frg => "forage"			 #  6
	  :Irn => "irony"			 #  9
	  :Jak => "jackal"			 #  10
```
Overlaps are handled such that same `key => value` pairs are not added again. If you want to change this to keep the last occurrence, use the keyword argument `keep = :last` (or `keep = "last"`).
```julia
dxs = slice(dd, 2, 4:5, [7,8], 5:length(dd), [8,5]; keep = :last)

	OrderedDict{Symbol, String} with 8 entries:
	  :Brc => "birch"		    	 #  2
	  :Drn => "dragon"			 #  4
	  :Frg => "forage"			 #  6
	  :Gra => "grain"			 #  7
	  :Irn => "irony"			 #  9
	  :Jak => "jackal"			 #  10
	  :Hlt => "health"			 #  8
	  :Exp => "expensive"			 #  5
```
If you want to do more complicated things like filtering the collected indices you can use the `filter` keyword with any filtering function.
```julia
dxs = slice(dd, 2, 4:5, [7,8], 5:length(dd), [8,5]; filter = x->in(x,5:6))

	OrderedDict{Symbol, String} with 2 entries:
	  :Exp => "expensive"			 #  5
	  :Frg => "forage"			 #  6

dxs = slice(dd, 2, 4:5, [7,8], 5:length(dd), [8,5]; keep = :last, filter = x->in(x,5:6))

	OrderedDict{Symbol, String} with 2 entries:
	  :Frg => "forage"			 #  6
	  :Exp => "expensive"		 	 #  5
```
Ordinarily `keep = :last` occurs after filtering, but if for some reason you want it to happen before the filter use `keep = :lastbefore`. Likewise, if you want it to keep the first instance before filtering, do `keep = :firstbefore`. This is possibly desirable if your filter function involves the number of occurrences.


The function syntax version only works with OrderedDict, so convert your dict to an OrderedDict to use this.
Usually this just means using the constructor like `newdict = OrderedDict(olddict)`.

Example using function syntax:
```julia
using DictionarySlicing

directslicing()		# need to call this function to activate it.

dd = OrderedDict(:Apl => "apple",
		 :Brc => "birch",
		 :Cnd => "candle",
		 :Drn => "dragon",
		 :Exp => "expensive",
		 :Frg => "forage",
		 :Gra => "grain",
		 :Hlt => "health",
		 :Irn => "irony",
		 :Jak => "jackal" )

dxs = dd(4)

	OrderedDict{Symbol, String} with 1 entry:
	  :Drn => "dragon"

dxs = dd(2, 4:5, [7,8], 5:length(dd), [8,5])

	OrderedDict{Symbol, String} with 8 entries:
	  :Brc => "birch"           		 #  2
	  :Drn => "dragon"			 #  4
	  :Exp => "expensive"		 	 #  5
	  :Gra => "grain"  			 #  7
	  :Hlt => "health"			 #  8
	  :Frg => "forage"			 #  6
	  :Irn => "irony"			 #  9
	  :Jak => "jackal"			 #  10

dxs = [2, 4:5] |> dd	# easy piping. throw numbers at it

	OrderedDict{Symbol, String} with 3 entries:
	  :Brc => "birch"           		 #  2
	  :Drn => "dragon"			 #  4
	  :Exp => "expensive"		 	 #  5

dxs = dd(2, 4:5, [7,8], 5:length(dd), [8,5]; keep = :last)

	OrderedDict{Symbol, String} with 8 entries:
	  :Brc => "birch"		    	 #  2
	  :Drn => "dragon"			 #  4
	  :Frg => "forage"			 #  6
	  :Gra => "grain"			 #  7
	  :Irn => "irony"			 #  9
	  :Jak => "jackal"			 #  10
	  :Hlt => "health"			 #  8
	  :Exp => "expensive"			 #  5

dxs = dd(2, 4:5, [7,8], 5:length(dd), [8,5]; filter = x->in(x,5:6))

	OrderedDict{Symbol, String} with 2 entries:
	  :Exp => "expensive"			 #  5
	  :Frg => "forage"			 #  6

dxs = dd(2, 4:5, [7,8], 5:length(dd), [8,5]; keep = :last, filter = x->in(x,5:6))

	OrderedDict{Symbol, String} with 2 entries:
	  :Frg => "forage"			 #  6
	  :Exp => "expensive"		 	 #  5
```
