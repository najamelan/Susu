
module TidBits
module Options

class Settings < Hashie::Mash


# Support loading from a string or a Pathname
#
def self.load path, options = { reload: false }

	options[ :reload ] && @_mashes and @_mashes.delete( path.to_s )

	super( path.to_s, options )

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





