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

			type = @sm.desire( @factAddr )[ :type ]  ||  options.createType

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

		dependOn( @factAddr.dup.push( :exist ), true )  or  return analyzeFailed

		stat = options.followSymlinks  ?  options.path.stat  :  options.path.lstat
		@fact.statCalled = true

		@sm.actual.set( @factAddr.dup.push( :type  ), stat.ftype.to_sym                            )
		@sm.actual.set( @factAddr.dup.push( :mode  ), stat.mode                                    )
		@sm.actual.set( @factAddr.dup.push( :ctime ), stat.ctime                                   )
		@sm.actual.set( @factAddr.dup.push( :mtime ), stat.mtime                                   )
		@sm.actual.set( @factAddr.dup.push( :atime ), stat.atime                                   )
		@sm.actual.set( @factAddr.dup.push( :own   ), { uid: stat.uid, gid: stat.gid }.to_settings )

		analyzePassed

	end


	def reset

		super

		fresh? or raise

		@fact.statCalled = false

	end

end # class StatCondition < Condition



class Type < StatCondition

	def fix

		super do

			options.path.rm_secure

			exist = @sm.conditions @factAddr.dup.push(:exist )

			exist.reset
			exist.fix

			exist.fixPassed?

		end

	end

end # class Exist < Condition



class Own < StatCondition

	def check

		super

		@sm.actual( @address ).nil? and raise "Analyze for #{self.ai} returned nil"

		@status

	end

	def fix

		super { options.path.chown( @expect[ :uid ], @expect[ :gid ] ) }

	end

end # class Own < StatCondition



class Mode < StatCondition

	def check

		analyzed?     or analyze
		checkPassed? and return @status

		@sm.actual( @address ).nil? and raise

		if @sm.desire( @address ) == @sm.actual( @address )

			return checkPassed

		else

			@fact.debug "Check failed for #{@address.ai}, expect: #{@expect.to_s( 8 )}, found: #{@sm.actual( @address ).to_s( 8 )}"
			return checkFailed

		end

	end


	def fix

		super { options.path.chmod( @expect ) }

	end

end # class Mode < StatCondition


end # module Path
end # module Conditions

end # module Facts
end # module TidBits
