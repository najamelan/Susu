using Susu.refines

module Susu
module Options

# Mixin module to allow a class or module to have a hash of options.
#
module Configurable


def initialize( *args, **opts, &block )

	super( *args, &block )

	setupOptions opts.to_settings

end


def setupOptions runtime

	opts = self.class.options.deep_merge( runtime )

	extend runtime.to_module( 'runtime' )
	extend opts   .to_module( 'options' )

end

end # Configurable
end # Options
end # Susu

