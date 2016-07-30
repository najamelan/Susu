
module TidBits
module Git
module Facts

# Options (* means mandatory)
#
# path*    : Path to the repository directory (workingDir with .git)
# name*    : string  (default=master)
#
class BranchExist < TidBits::Facts::Fact

attr_reader :repo



def initialize( path:, **opts )

	super( **opts, path: path.path )

	dependOn( RepoExist, { path: @path } )

	@repo     = TidBits::Git::Repo.new( @path )
	@branches = @repo.branches


end



def analyze( update = false )

	super == 'return'  and  return @analyzePassed

	@state[ :exist ][ :found ] = @branches.include?( @name )

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

	expect( key )  ?  warn( "#{@path} does not have a branch called: #{@name.ai}."        )\
	               :  warn( "#{@path} has a branch called: #{@name.ai} but it shouldn't." )

	@checkPassed

end



def fix()

	super == 'return'  and  return @fixPassed

	raise "Note implemented"

end


end # class  BranchExist



# Options (* means mandatory)
#
# path*     : Path to the repository directory (workingDir with .git)
# name*     : string  (default=master)
# ahead?    : bool    (will check for current branch)
# behind?   : bool    (will check for current branch)
# diverged? : bool    (will check for current branch)
#
class Branch < TidBits::Facts::Fact

attr_reader :repo



def initialize( path:, **opts )

	super( **opts, path: path.path )

	dependOn( BranchExist, { path: @path, name: name } )

	options.track and dependOn( BranchExist, { path: @path, name: options.track } )

	@repo   = TidBits::Git::Repo.new( @path )
	@branch = @repo.branches[ name ]

end



def analyze( update = false )

	super == 'return'  and  return @analyzePassed

	s = @state


	s[ :track ]  and  s[ :track ][ :found ] = @branch.upstreamName


	if s[ :track ][ :found ]

		s[ :ahead?    ]  and  s[ :ahead?    ][ :found ] = @branch.ahead?
		s[ :behind?   ]  and  s[ :behind?   ][ :found ] = @branch.behind?
		s[ :diverged? ]  and  s[ :diverged? ][ :found ] = @branch.diverged?

		s[ :ahead     ]  and  s[ :ahead     ][ :found ] = @branch.ahead
		s[ :behind    ]  and  s[ :behind    ][ :found ] = @branch.behind
		s[ :diverged  ]  and  s[ :diverged  ][ :found ] = @branch.diverged

	elsif s[ :ahead? ] || s[ :behind? ] || s[ :diverged? ] || s[ :ahead ] || s[ :behind ] || s[ :diverged ]

		warn "#{@path} branch #{@name} should have an upstream, but it's not tracking anything."
		@analyzePassed = false

	end


	@analyzePassed

end



def check( update = false )

	super == 'return'  and  return @checkPassed


	@state.each do | key, info |

		info[ :passed ] = true

		if found( key ) != expect( key )

			info[ :passed ] = false
			@checkPassed    = false

			track = @state[ :track ][ :found ].ai


			case key

			when :track

				expect( key ) and warn "#{@path} branch #{@name} should track upstream #{expect( key ).ai} but found #{found(key)}."
				expect( key ) or  warn "#{@path} branch #{@name} should not track upstream #{expect( key ).ai} but found #{found(key)}."

			when :ahead?

				expect( key ) and warn "#{@path} branch #{@name} should be ahead of #{    track}."
				expect( key ) or  warn "#{@path} branch #{@name} should not be ahead of #{track}."

			when :behind?

				expect( key ) and warn "#{@path} branch #{@name} should be behind of #{    track}."
				expect( key ) or  warn "#{@path} branch #{@name} should not be behind of #{track}."

			when :diverged?

				expect( key ) and warn "#{@path} branch #{@name} should be diverged of #{    track}."
				expect( key ) or  warn "#{@path} branch #{@name} should not be diverged of #{track}."

			when :ahead

				warn "#{@path} branch #{@name} should be #{key} of #{track} by #{expect(key)} but is #{found(key)}."

			when :behind

				warn "#{@path} branch #{@name} should be #{key} of #{track} by #{expect(key)} but is #{found(key)}."

			when :diverged

				warn "#{@path} branch #{@name} should be #{key} of #{track} by #{expect(key)} but is #{found(key)}."

			end


		else

			info[ :passed ] = true


		end

	end


	@checkPassed

end



def fix()

	super == 'return'  and  return @fixPassed

	raise "Note implemented"

end


end # class  Branch




end # module Facts
end # module Git
end # module TidBits
