# DictionaryIndexing

Dictionary indexing imports only 1 package (OrderedCollections) and has 1 function that enables indexing/slicing ordered dictionaries using function syntax. 
If you want to use it for another dict type you can convert it to an OrderedDict first.

Example:
```
using DictionaryIndexing

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
dxs = dd(4)

	OrderedDict{Symbol, String} with 1 entry:
	  :Drn => "dragon"

dxs = dd(2, 4:5, [7,8], 5:length(dd), [8,5])    # instead of `end` we get the last index with `length`

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
```
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
```
If you want to do more complicated things like filtering the collected indices you can use the `filter` keyword with any filtering function.
```
dxs = dd(2, 4:5, [7,8], 5:length(dd), [8,5]; filter = x->in(x,5:6))

	OrderedDict{Symbol, String} with 2 entries:
	  :Exp => "expensive"			 #  5
	  :Frg => "forage"			 #  6

dxs = dd(2, 4:5, [7,8], 5:length(dd), [8,5]; keep = :last, filter = x->in(x,5:6))

	OrderedDict{Symbol, String} with 2 entries:
	  :Frg => "forage"			 #  6
	  :Exp => "expensive"		 	 #  5
```
Ordinarily `keep = :last` occurs after filtering, but if for some reason you want it to happen before the filter use `keep = :lastbefore`. Likewise, if you want it to keep the first instance before filtering, do `keep = :firstbefore`. This is possibly desirable if your filter function involves the number of occurrences.
