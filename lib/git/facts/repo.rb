
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
class Repo < TidBits::Facts::Fact

include TidBits::Facts::InstanceCount

attr_reader :repo


def initialize( path:, **opts )

	super( **opts, path: path.to_path.path )
	@repo = TidBits::Git::Repo.new( @path )


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


end # class  Repo


module Conditions
module Repo


class Exist < TidBits::Facts::Conditions::Condition


def analyze

	super @fact.repo.valid?

end


def fix

	super do

		# TODO: catch exceptions and report
		#
		if @expect

			bare = @sm.desire( @factAddr )[ :bare ]  ||  options.createBare
			@fact.repo.init( bare )

		else

			@fact.repo.deinit

		end

		true

	end

	@status

end

end # class Exist < Condition


end # module Conditions
end # module Repo



end # module Facts
end # module Git
end # module TidBits
