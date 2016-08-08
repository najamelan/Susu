
module TidBits
module Git
module Facts


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

end # class Exist < TidBits::Facts::Conditions::Condition


class Bare < TidBits::Facts::Conditions::Condition


def analyze

	dependOn( @factAddr.dup.push( :exist ), true )

	super @fact.repo.bare?

end


def fix

	super do

		old = options.path.mv( options.path.to_path + '.bak' )

		Git::Repo.clone( old, options.path, bare: @expect )

		old.rm_secure

	end

end

end # class Bare < TidBits::Facts::Conditions::Condition


# Verify whether the working directory is clean
#
class Clean < TidBits::Facts::Conditions::Condition


def analyze

	dependOn( @factAddr.dup.push( :bare ), false, :check, options.dup )

	super @fact.repo.clean?

end


def fix

	super do

		if @expect


		else


		end

	end

end

end # class Clean < TidBits::Facts::Conditions::Condition


end # module Conditions
end # module Repo



end # module Facts
end # module Git
end # module TidBits
