module Susu
module Options

class TestHelper

@configured = false


def self.reset

	singleton_class.method_defined? :settings and singleton_class.send :remove_method, :settings
	singleton_class.method_defined? :options  and singleton_class.send :remove_method, :options
	@configured = false

end


def self.class_configured( cfgObj )

	@configured = true

end


def self.configured?

	@configured

end


end # class TestHelper



class TestHelperChild < TestHelper


end # class TestHelper

end # module Options
end # module Susu
