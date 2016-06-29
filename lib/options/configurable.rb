module TidBits
module Options

# Mixin module to allow a class or module to have a hash of options.
#
module Configurable

# Get the options in use for this class.
#
# @param  *args [Symbol] The key for which to take the value. Defaults to returning the entire options Hash. This function takes an arbitrary number of parameters representing nested hash keys.
# @return [Array] The default options.
#
# @example Usage
#   g = Git.new { repo: { name: 'test', attr: { bare: false, local: true } } }
#
#   g.options( :repo, :name        ) #=> string  'test'
#   g.options( :repo, :attr        ) #=> Hash    { bare: false, local: true }
#   g.options( :repo, :attr, :bare ) #=> Boolean false
#
def options( *args )

	getOpts @options, args

end



# Get the set of values that where the defaults for this class.
#
# @param  (see #options)
# @return [Array] The default options.
#
def defaults( *args )

	getOpts @defaults, args

end



# Get those values that have been userset or set by the client.
#
# @param  (see #options)
# @return [Array] The user set options.
#
def userset( *args )

	getOpts @userset, args

end



# Helper for constructors of classes that have options. Does basic merging of defaults
# with userset options. For subclasses you should call parent::__construct before calling
# this method, so your options will override those set by the parent class.
#
# @param defaults [Hash] The default options for this class.
# @param userset  [Hash] The options passed in to the constructor.
#
# @return self.
#
protected
def setupOptions( defaults, userset )

	@defaults = defaults.deep_symbolize_keys!
	@userset  = userset.deep_symbolize_keys!
	@options  = @defaults.recursiveMerge @userset

	self

end



# Allows setting an option, checking if the object is sealed.
# Currently only supports one level of depth.
#
# @param name  [Symbol] The key. Only supports one level depth.
# @param value [any] The key. Only supports one level depth.
# @return self [Object]
#
protected
def setOpt( key, value )

	h = { key => value }.deep_symbolize_keys!
	a = h.shift

	@options[ a[ 0 ] ] = a[ 1 ];
	@userset[ a[ 0 ] ] = a[ 1 ];

	self

end



# Provides a read only copy of the options object for this class.
#
# @param  pointer [Hash ]         The hash from which to extract values.
# @param  symbols [Array<Symbol>] The hierarchy of keys to get to the value.
# @return         [Array] The currently loaded configuration for this object.
#
private
def getOpts( pointer, symbols )

	symbols.each do |param|

		if pointer[ param ] != nil

			pointer = pointer[ param ]

		else

			return nil

		end

	end


	pointer.dup

end


end # TidBits
end # Options
end # Configurable

