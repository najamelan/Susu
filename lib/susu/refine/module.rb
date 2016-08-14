module Susu
module Refine
module Module

refine ::Module do

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

end # module Module
end # module Refine
end # module Susu
