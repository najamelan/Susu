require 'awesome_print'
require_relative 'fact'

module TidBits
module Facts

# Options (* means mandatory)
#
# path*      : string
# type       : "file", "directory", "characterSpecial", "blockSpecial", "fifo", "link", "socket", or "unknown"
#              (default=file)
# symlink    : boolean
# mode       : integer
# owner      : 'owner'
# group      : 'group'
# mtime      :
# hashAlgo   : :SHA512
# hash       : string   the hash of the content
#
# TODO: currently we won't check anything if the exist option doesn't correspond with reality.
#       However, we don't do input validation to keep people from asking us to test properties
#       on a file that they claim should not exist, which might be confusing when they check the
#       results.
#
class Path < Fact

include InstanceCount



def self.class_configured cfgObj

	self.fixSymbols

end


def self.fixSymbols

	super

	# Yaml can't have symbols as rvalues
	#
	[ :type, :createType ].each do |key|

		settings.default.has_key?( key ) and settings.default[ key ] = settings.default[ key ].to_sym
		settings.userset.has_key?( key ) and settings.userset[ key ] = settings.userset[ key ].to_sym
		settings.runtime.has_key?( key ) and settings.runtime[ key ] = settings.runtime[ key ].to_sym
		         options.has_key?( key ) and          options[ key ] =          options[ key ].to_sym

	end

end



def initialize( path:, **opts )

	# Yaml doesn't really support symbol values, so garuantee it are symbols for
	# consistency.
	# TODO: have a config option for type guarantees and let Facts::Fact deal with it.
	#
	[ :type, :createType ].each { |key| opts.has_key?( key ) and opts[ key ] = opts[key ].to_sym }

	# opts.has_key?( :type       ) and opts[ :type       ] = opts[ :type       ].to_sym
	# opts.has_key?( :createType ) and opts[ :createType ] = opts[ :createType ].to_sym

	super( **opts, path: path.to_path.path )

end


def createAddress

	@indexKeys.map do |key|

		ret = options[ key ]

		# We make sure path is always a string for the address
		#
		key.to_sym == :path and  ret = ret.expand_path.to_path

		ret

	end.unshift self.class.name

end


end # class  Path



module Conditions
module Path


class Exist < Condition


def analyze

	super options.path.exist?

end


def fix

	super do

		if ! @expect

			options.path.rm_secure( options.force )

		else

			type = @sm.desire( @factAddress )[ :type ]  ||  options.createType

			type == :file ? options.path.touch : options.path.mkdir

		end

		true

	end

	@status

end

end # class Exist < Condition



class Type < Condition

def initialize( **opts )

	super

end



def analyze

	dependOn( @factAddress.dup.push( :exist ), true )  or  return analyzeFailed

	stat = options.followSymlinks  ?  options.path.stat  :  options.path.lstat

	super stat.ftype.to_sym

end


def fix

	super do

		options.path.rm_secure

		exist = @sm.conditions( @factAddress.dup << :exist )

		exist.reset
		exist.fix

		exist.fixPassed?

	end

	@status

end

end # class Exist < Condition


end # module Path
end # module Conditions



end # module Facts
end # module TidBits
