# DictionaryIndexing

Dictionary indexing can be useful if, for instance, you don't remember the key for something but you know what place it is in.

Example:
```
d = OrderedDict(:Apl => "apple",
	 	:Brc => "birch",
	 	:Cnd => "candle",
	 	:Drn => "dragon",
	 	:Exp => "expensive",
		:Frg => "forage",
		:Gra => "grain",
		:Hlt => "health")

dxs = d(2, 4:5, [7,8])

OrderedDict{Symbol,String} with 5 entries:
  :Brc => "birch"
  :Drn => "dragon"
  :Exp => "expensive"
  :Grn => "grain"
  :Hlt => "health"
						 
```
