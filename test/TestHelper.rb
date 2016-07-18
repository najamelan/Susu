module TidBits
module Options

class TestHelper

def initialize( **userset )

	setupOptions( userset )

end


def self.reset

	singleton_class.method_defined? :settings and singleton_class.send :remove_method, :settings
	singleton_class.method_defined? :options  and singleton_class.send :remove_method, :options

end

end # class TestHelper



class TestHelperChild < TestHelper

def initialize( **userset )

	setupOptions( userset )

end

end # class TestHelper

end # module Options
end # module TidBits
