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

def initialize( path:, **opts )

	# Yaml doesn't really support symbol values, so garuantee it are symbols for
	# consistency.
	# TODO: have a config option for type guarantees and let Facts::Fact deal with it.
	#
	opts.has_key?( :type ) and opts[ :type ] = opts[ :type ].to_sym

	super( **opts, path: path.to_path.path )

end


def createAddress

	@indexKeys.map do |key|

		ret = options[ key ]

		key.to_sym == :path and  ret = ret.realpath.to_path

		ret

	end.unshift self.class.name

end


end # class  Path



module Conditions
module Path

class Exist < Condition


def initialize( **opts )

	super

end



def analyze

	super options.path.exist?

end


def fix


end

end


end # module Path
end # module Conditions



end # module Facts
end # module TidBits
