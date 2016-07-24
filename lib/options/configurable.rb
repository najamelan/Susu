module TidBits
module Options

# Mixin module to allow a class or module to have a hash of options.
#
module Configurable


def initialize( *args, **opts, &block )

	super( *args, &block )

	setupOptions opts

end


def setupOptions runtime

	runtime = self.class.options.deep_merge( runtime )
	extend runtime.to_module( 'options' )

end

end # Configurable
end # Options
end # TidBits

