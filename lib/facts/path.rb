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

attr_accessor :statCalled



# Yaml can't have symbols as rvalues
#
def self.sanitize key, value

	key, value = super

	if [ :type, :createType ].include? key

		value = value.to_sym

	end

	return key, value

end


def initialize( path:, **opts )

	super( **opts, path: path.to_path.path )

	@statCalled = false

end



def reset

	@statCalled = false

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


class StatCondition < Condition

	def analyze

		analyzePassed?    and  return @status
		@fact.statCalled  and  return analyzePassed

		dependOn( @factAddress.dup.push( :exist ), true )  or  return analyzeFailed

		stat = options.followSymlinks  ?  options.path.stat  :  options.path.lstat
		@fact.statCalled = true

		owner = Etc.getpwuid( stat.uid ).name
		group = Etc.getgrgid( stat.gid ).name

		@sm.actual.set( @factAddress.dup.push( :type  ), stat.ftype.to_sym )
		@sm.actual.set( @factAddress.dup.push( :mode  ), stat.mode         )
		@sm.actual.set( @factAddress.dup.push( :owner ), owner             )
		@sm.actual.set( @factAddress.dup.push( :group ), group             )
		@sm.actual.set( @factAddress.dup.push( :uid   ), stat.uid          )
		@sm.actual.set( @factAddress.dup.push( :gid   ), stat.gid          )
		@sm.actual.set( @factAddress.dup.push( :ctime ), stat.ctime        )
		@sm.actual.set( @factAddress.dup.push( :mtime ), stat.mtime        )
		@sm.actual.set( @factAddress.dup.push( :atime ), stat.atime        )

		analyzePassed

	end


	def reset

		super

		@fact.statCalled = false

	end

end # class StatCondition < Condition



class Type < StatCondition

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
