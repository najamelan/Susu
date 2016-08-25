eval Susu::ALL_REFINES, binding

module Susu
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
class Repo < Susu::Facts::Fact

include Susu::Facts::InstanceCount

attr_reader :repo



def self.configure( config )

	config.setup( self, :Git, :Facts, :Repo, sanitizer: method( :sanitize ) )

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
			begin

				@fact.repo.init( options.bare )

			rescue Rugged::FilesystemError => e

				options.force or raise e

				Fs::Facts::Path.new( path: options.path, exist: false, force: options.force ).fix

				retry

			end

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

end # class  Repo
end # module Facts
end # module Git
end # module Susu
