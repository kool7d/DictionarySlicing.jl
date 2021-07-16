using DictionarySlicing
using Test

@testset "DictionarySlicing.jl" begin
    od = OrderedDict(
             :Apl => "apple",
     		 :Brc => "birch",
     		 :Cnd => "candle",
     		 :Drn => "dragon",
     		 :Exp => "expensive",
     		 :Frg => "forage",
     		 :Gra => "grain",
     		 :Hlt => "health",
     		 :Irn => "irony",
     		 :Jak => "jackal" 
    )
    @test sliced(od,4:6) == OrderedDict{Symbol,String}( :Drn => "dragon",
          		                                        :Exp => "expensive",
          		                                        :Frg => "forage")
end
