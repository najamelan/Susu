Susu.refine binding

module Susu
module Git
module Facts

# Options (* means mandatory)
#
# path*    : Path to the repository directory (workingDir with .git)
# name*    : string  (default=origin)
#
class RemoteExist < Susu::Facts::Fact

attr_reader :repo



def initialize( path:, **opts )

	super( **opts, path: path.path )

	dependOn( RepoExist, { path: @path } )

	@repo    = Susu::Git::Repo.new( @path )
	@remotes = @repo.remotes

end



def analyze( update = false )

	super == 'return'  and  return @analyzePassed

	@state[ :exist ][ :found ] = @remotes.include?( @name )

	@analyzePassed

end



def check( update = false )

	super == 'return'  and  return @checkPassed

	key = :exist

	@state[ key ][ :passed ] = found( key ) == expect( key )  and  return @checkPassed

	# Failure
	#
	@checkPassed             = false
	@state[ key ][ :passed ] = false

	expect( key )  and  warn "#{@path.ai} does not have a remote called: #{@name.ai}."
	expect( key )  or   warn "#{@path.ai} has a remote called: #{@name.ai} but it shouldn't."

	@checkPassed

end



def fix()

	super == 'return'  and  return @fixPassed

	raise "Note implemented"

end


end # class  RemoteExist



# Options (* means mandatory)
#
# path* : Path to the repository directory (workingDir with .git)
# name  : string  (default=origin)
# url   : bool    (whether the working dir is clean)
#
class Remote < Susu::Facts::Fact

attr_reader :repo



def self.configure( config )

	config.setup( self, :Git, :Facts, :Remote )

end



def initialize( path:, **opts )

	super( **opts, path: path.path )

	dependOn( RemoteExist, { path: @path, name: name } )

	@repo   = Susu::Git::Repo.new( @path )
	@remote = @repo.remotes[ name ]

end



def analyze( update = false )

	super == 'return'  and  return @analyzePassed

	@state[ :url ]  and  @state[ :url ][ :found ] = @remote.url

	@analyzePassed

end



def check( update = false )

	super == 'return'  and  return @checkPassed

	@state.each do | key, info |


		info[ :passed ] = true

		if found( key ) != expect( key )

			info[ :passed ] = false
			@checkPassed    = false


			case key

			when :url

				warn "Remote #{@name.ai} of repo #{@path} should have url #{expect( key )}, but has #{@state[ key ][ :found ].ai}."

			end


		end

	end


	@checkPassed

end



def fix()

	super == 'return'  and  return @fixPassed

	raise "Note implemented"

end


end # class  Remote




end # module Facts
end # module Git
end # module Susu
