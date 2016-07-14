
module TidBits
module Options

class Settings < Hashie::Mash


# protect from overriding methods
#
include Hashie::Extensions::Mash::SafeAssignment


# Support loading from a string or a Pathname
#
def self.load path, options = {}

	options.has_key?( :reload ) && options.fetch( :reload ) and @_mashes.delete( path.to_s )

	super( path.to_s, options )

end


protected

# Make sure keys are always symbols
#
def convert_key( key )

  key.to_sym

end


end # Settings
end # Options
end # TidBits


class Hash

	def to_settings

		TidBits::Options::Settings.new self

	end

end





