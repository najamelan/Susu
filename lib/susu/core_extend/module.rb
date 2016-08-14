module Susu
module CoreExtend
module RefineModule

refine Module do

def lastname

	name.split( '::' ).last

end



def respond_to? name, include_all = false

  super and return true

  [

    :lastname

  ].include? name.to_sym

end


end # refine Module

end # module RefineModule
end # module CoreExtend
end # module Susu
