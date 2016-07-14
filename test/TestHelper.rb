module TidBits
module Options

class TestHelper

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
