module TidBits
module Options

class TestHelper

include Configurable

def initialize( **userset )

	setupOptions( self.class.defaults, userset )

end



def change( key, value )

	setOpt( key, value )

end


end # class TestHelper
end # module Options
end # module TidBits
