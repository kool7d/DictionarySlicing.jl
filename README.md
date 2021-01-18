# DictionaryIndexing

Dictionary indexing can be useful if, for instance, you don't remember the key for something but you know what place it is in.

Example:
```
d = OrderedDict(:Apl => "apple",
	 	:Brc => "birch",
	 	:Cnd => "candle",
	 	:Drn => "dragon",
	 	:Exp => "expensive")

dxs = d(2, 3:4)

OrderedDict{Symbol,String} with 3 entries:
  :brc => "birch"
  :cnd => "candle"
  :drn => "dragon"
						 
```
