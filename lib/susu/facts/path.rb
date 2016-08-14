require_relative 'fact'

module Susu
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
class Path < Fact

include InstanceCount


# Yaml can't have symbols as rvalues
#
def self.sanitize key, value

	key, value = super

	if [ :type ].include? key

		value = value.to_sym

	end

	return key, value

end


def initialize( path:, **opts )

	super( **opts, path: path.to_path.path )

end



# Conditions
#
class Exist < Condition


	def analyze; super { options.path.exist? } end


	def fix

		super do

			if ! @expect

				options.path.rm_secure( options.force )

			else

				options.has_key? :type  or

					raise "In order to create a path, you must specify :type on Facts::Path."


				case options.type

					when :file     ; options.path.touch
					when :directory; options.path.mkpath

					else

						raise "Creating path of type: #{type}, not implemented"

				end

			end

		end

	end

end # class Exist < Condition



class StatCondition < Condition

	def analyze

		@sm.actual( @factAddr.dup << :statCalled  )  and  return analyzePassed

		dependOn( :exist, true )  or  return analyzeFailed

		stat = options.followSymlinks  ?  options.path.stat  :  options.path.lstat

		@sm.actual.set( @factAddr.dup.push( :statCalled  ), true                                         )

		@sm.actual.set( @factAddr.dup.push( :type        ), stat.ftype.to_sym                            )
		@sm.actual.set( @factAddr.dup.push( :mode        ), stat.mode                                    )
		@sm.actual.set( @factAddr.dup.push( :ctime       ), stat.ctime                                   )
		@sm.actual.set( @factAddr.dup.push( :mtime       ), stat.mtime                                   )
		@sm.actual.set( @factAddr.dup.push( :atime       ), stat.atime                                   )
		@sm.actual.set( @factAddr.dup.push( :own         ), { uid: stat.uid, gid: stat.gid }.to_settings )

		analyzePassed

	end


	def reset

		super

		@sm.actual.set( @factAddr.dup.push( :statCalled  ), false )

	end

end # class StatCondition < Condition



class Type < StatCondition

	def fix

		super do

			if !options.force

				@fact.info "Did not change type on #{options.path} to #{@expect} because the file exists and force is not set. Current type: #{@sm.actual( @address )}"

				return false

			end

			options.path.rm_secure

			@fact.reset
			@fact.fix

		end

	end

end # class Exist < Condition



class Own < StatCondition

	def fix

		super { options.path.chown( @expect[ :uid ], @expect[ :gid ] ) }

	end

end # class Own < StatCondition



class Mode < StatCondition

	def fix

		super { options.path.chmod( @expect ) }

	end

end # class Mode < StatCondition



end # class  Path
end # module Facts
end # module Susu
