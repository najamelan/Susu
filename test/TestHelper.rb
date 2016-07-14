module TidBits
module Options

class TestHelper

include Configurable

def initialize( **userset )

	setupOptions( userset )

end


def self.reset

	@settings = nil
	@options  = nil

end


end # class TestHelper
end # module Options
end # module TidBits
