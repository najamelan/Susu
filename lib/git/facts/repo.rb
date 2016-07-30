
module TidBits
module Git
module Facts


# Options (* means mandatory)
#
# path*       : Path to the repository directory (workingDir with .git)
# exist : bool   (default=true)
#
class RepoExist < TidBits::Facts::Fact

attr_reader :repo


def initialize( path:, bare: false, **opts )

	super( **opts, path: path.path, bare: bare )


	if options.exist

		dependOn( Path, { path: @path }, type: 'directory' )

	elsif options.bare

		 dependOn( PathExist, { path: @path }, exist: false )

	end


	@repo = TidBits::Git::Repo.new( @path )

end



def analyze( update = false )

	super == 'return'  and  return @analyzePassed

	@state[ :exist ][ :found ] = @repo.valid?

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

	expect( key )  and  warn "#{@path.inspect} is not a git repo."
	expect( key )  or   warn "#{@path.inspect} is a git repo but it shouldn't."

	@checkPassed

end



def fix( update = false )

	super == 'return'  and  return @fixPassed


	@state[ :exist ][ :fixed ] = true

	# TODO: catch exceptions and report
	#
	if expect( :exist )

		@repo.init params.bare

	else

		@repo.deinit

	end


	@fixPassed = check( true )


	_fixed( :exist ) and @state[ :exist ][ :fixed ] = @state[ :exist ][ :passed ]

	@fixPassed

end


end # class  RepoExist




# Options (* means mandatory)
#
# path*  : Path to the repository directory (workingDir with .git)
# head   : String      (the ref name head should point to, eg. a branch name)
# clean  : Boolean     (whether the working dir is clean)
# remotes: Array<Hash> A list of settings for Fact::Git::Remote to depend on.
# remotes: Array<Hash> A list of settings for Fact::Git::Branch to depend on.
#
# TODO: currently we won't check anything if the exist option doesn't correspond with reality.
#       However, we don't do input validation to keep people from asking us to test properties on a
#       repo that they claim should not exist, which might be confusing when they check the results.
#
#       In general we should have some sort of feedback mechanism to report the reason for failures to clients.
#
class Repo < TidBits::Facts::Fact

attr_reader :repo



def initialize( path:, **opts )

	super( **opts, path: path.path )

	@repo   = TidBits::Git::Repo.new( @path )

	exist = dependOn( RepoExist, { path: @path, bare: options.bare } )

	# Having them depend on exist explicitly means they will respect the bare option
	#
	remotes .each {|remote| dependOn( Remote, remote.merge( path: @path, dependOn: exist ) ) }
	branches.each {|branch| dependOn( Branch, branch.merge( path: @path, dependOn: exist ) ) }

end



def analyze( update = false )

	super == 'return'  and  return @analyzePassed

	@state[ :head  ]  and  @state[ :head  ][ :found ] = @repo.head
	@state[ :clean ]  and  @state[ :clean ][ :found ] = @repo.workingDirClean?

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

			when :head

				warn "#{@path} should be on branch #{expect( key )}, but is on #{@state[ key ][ :found ].ai}."

			when :clean

				expect( key ) and warn "#{@path} should have a clean working directory."
				expect( key ) or  warn "#{@path} should NOT have a clean working directory."

			end


		else

			info[ :passed ] = true


		end

	end


	@checkPassed

end



def fix( update = false, force: true )

	# super == 'return'  and  return @fixPassed


	# @state.each do |key, test|

	# 	test[ :fixed ] = true

	# 	case key

	# 	when :type

	# 		@path.rm_secure

	# 		fix true, force: force

	# 	end

	# end


	# @fixPassed = check( true )

	# @state.each do |key, test|

	# 	_fixed( key ) and test[ :fixed ] = test[ :passed ]

	# end

	# @fixPassed

end


end # class  Repo



end # module Facts
end # module Git
end # module TidBits
