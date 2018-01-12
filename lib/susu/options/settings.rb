using Susu.refines

module Susu
module Options

class Settings < Hashie::Mash


attr_reader :_validator_, :_sanitizer_


def initialize( * )

	super

	# Avoid warnings when run with ruby -w
	#
	@_sanitizer_ = nil
	@_validator_ = nil

end


# Support loading from a string or a Pathname
#
def self.load path, options = { reload: false }

	options[ :reload ] && @_mashes and @_mashes.delete( path.to_path )


	begin
	
		super( path.to_path, options ).dup

	rescue Psych::SyntaxError => e

		puts "\nError parsing yaml for: #{ path }. Psych error: #{ e }\n"
		raise e

	end

end



# I want to be able to create a key :default, so override the inherited method
# :default.
#
def default arg = nil

	if has_key?( :default )

		arg == :default || arg == 'default' || arg == nil and return self[ :default ]

	end

	nil

end


def default= value

	self[ :default ] = value

end


def to_module( method_name = :settings )

	mash = self

	Module.new do |m|

		send :define_singleton_method, :extended do |base|

			base.send :define_singleton_method, method_name.to_sym do

				mash

			end

		end

	end

end


# Set a sanitizer for keys and values added to this Settings. Since setting keys are
# coerced to symbols, returning something else from your block will result in undefined
# behaviour.
#
# When the new key is different than the old one, the old one will be deleted.
# Within your block you should not make changes to the hash being sanitized.
#
# The will be called with key, value and should return an array of 2 elements. When setting
# the sanitizer with this method, it will be called on all existing keys in the hash. Consequently
# it will be called on all new elements that are inserted. This is non-recursive.
#
# Can take any object that responds to `call`, but beware that shouldn't call
# `return` if you pass a Proc.
#
# @example Usage:
#
#   # Enforce uppercase values
#   #
#   h = Susu::Options::Settings[ { bla: 'kaboom' } ]
#
#   h._sanitizer_ = lambda { |key, value| [ key, value.upcase! ] }
#
#   h[ :bli ] = 'haha'
#
#   puts h # => #<Susu::Options::Settings bla="KABOOM" bli="HAHA">
#
# @example Recursive:
#
#  san = lambda do |key, value|
#
#     if value.kind_of?( Settings )
#
#        value._sanitizer_ = san
#        return key, value
#
#     end
#
#     return key, value.to_s
#
#  end
#
def _sanitizer_= block

	@_sanitizer_ = block

	dup.each do |key, val|

		newKey, newVal = block.call( key, val )
		key != newKey  and  delete( key )

		regular_writer( newKey, newVal )

	end

end



# Like _sanitizer_ but return value is ignored. Allows you to throw an exception
# if the key or value does not comply. When adding a new value to the Settings,
# sanitize will be run before validation, giving you an oportunity to try to salvage
# the input, but throw if that failed.
#
def _validator_= block

	@_validator_ = block

	each { |key, val| block.call( key, val ) }

end




# Sets an attribute in the Settings. Key will be converted to
# a symbol before it is set, and Hashes will be converted
# into Settings for nesting purposes.
#
def custom_writer( key, value, convert = true ) #:nodoc:

	key = convert_key( key )
	val = convert ? convert_value( value ) : value


	if @_sanitizer_

		key, val = @_sanitizer_.call( key, val )

	end


	if @_validator_

		key, val = @_validator_.call( key, val )

	end


	regular_writer( key, val )

end

alias_method :[]=, :custom_writer



protected

# Make sure keys are always symbols
#
def convert_key( key )

  key.to_sym

end


end # Settings
end # Options
end # Susu







