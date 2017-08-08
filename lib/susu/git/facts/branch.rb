using Susu.refines

module Susu
module Git
module Facts




# Options (* means mandatory)
#
# path*    : Path to the repository directory (workingDir with .git)
# name*    : string  (default=master)
#

# Options (* means mandatory)
#
# path*  : Path to the repository directory (workingDir with .git)
# head   : String      (the ref name head should point to, eg. a branch name)
# clean  : Boolean     (whether the working dir is clean)
# remotes: Array<Hash> A list of settings for Fact::Git::Remote to depend on.
# remotes: Array<Hash> A list of settings for Fact::Git::Branch to depend on.
#
class Branch < Susu::Facts::Fact

include Susu::Facts::InstanceCount


attr_reader :repo


def self.configure( config )

	config.setup( self, :Git, :Facts, :Branch )

end


def initialize( path:, **opts )

	super( **opts, path: path.to_path.path )
	@repo = Susu::Git::Repo.new( @path )


	# if options.exist

	# 	dependOn( Path, { path: @path }, type: 'directory' )

	# elsif options.bare

	# 	 dependOn( PathExist, { path: @path }, exist: false )

	# end


	# Having them depend on exist explicitly means they will respect the bare option
	#
	# remotes .each {|remote| dependOn( Remote, remote.merge( path: @path, dependOn: exist ) ) }
	# branches.each {|branch| dependOn( Branch, branch.merge( path: @path, dependOn: exist ) ) }

end



# Make sure path is always a string for the address
#
def createAddress

	@indexKeys.map do |key|

		ret = options[ key ]

		key.to_sym == :path and  ret = ret.expand_path.to_path

		ret

	end.unshift self.class.name

end




# Conditions
#
class Exist < Susu::Facts::Condition


def analyze

	super { @fact.repo.valid? }

end


def fix

	super do

		if @expect

			options.has_key? :bare  or

				raise "In order to create a git repository, you must specify :bare on Git::Facts::Repo."

			# TODO: catch exceptions from init or deinit and report
			#
			@fact.repo.init( options.bare )

		else

			@fact.repo.deinit

		end

	end

end

end # class Exist < Susu::Facts::Condition


class Bare < Susu::Facts::Condition


def analyze

	dependOn( :exist, true ) or return analyzeFailed

	super { @fact.repo.bare? }

end


def fix

	super do

		old = options.path.mv( options.path.to_path + '.bak' )

		Git::Repo.clone( old, options.path, bare: @expect )

		old.rm_secure

	end

end

end # class Bare < Susu::Facts::Condition


# Verify whether the working directory is clean
#
class Clean < Susu::Facts::Condition


def analyze

	dependOn( :bare, false ) or return analyzeFailed

	super { @fact.repo.clean? }

end


def fix( msg = "Commit added by #{self.class.name} in order to have clean working dir" )

	super() do

		if @expect

			@fact.repo.addAll
			@fact.repo.commit msg

		else

			@fact.repo.pollute

		end

	end

end

end # class Clean < Susu::Facts::Condition
end # class Brach < Susu::Facts::Fact



class BranchExist < Susu::Facts::Fact

attr_reader :repo



def initialize( path:, **opts )

	super( **opts, path: path.path )

	dependOn( RepoExist, { path: @path } )

	@repo     = Git::Repo.new( @path )
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
class Branch < Susu::Facts::Fact




def initialize( path:, **opts )

	super( **opts, path: path.path )

	dependOn( BranchExist, { path: @path, name: name } )

	options.track and dependOn( BranchExist, { path: @path, name: options.track } )

	@repo   = Git::Repo.new( @path )
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
end # module Susu
