module TidBits
module Options

# Mixin module to allow a class or module to have a hash of options.
#
module Configurable

	def setupOptions runtime

		runtime = self.class.options.deep_merge( runtime )
		self.class.include runtime.to_module( 'options' )

	end

end # Configurable
end # Options
end # TidBits

