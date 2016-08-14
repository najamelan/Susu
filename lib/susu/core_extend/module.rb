module Susu
module CoreExtend
module RefineModule

refine Module do

def lastname

	name.split( '::' ).last

end


end # refine Module

end # module RefineModule
end # module CoreExtend
end # module Susu
