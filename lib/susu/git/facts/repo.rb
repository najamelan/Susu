using Susu.refines
module Susu
module Git
module Facts


# Options (* means mandatory)
#
# path*     : respond_to?(:path)  Path to the repository directory (workingDir with .git)
# head      : String              (the ref name head should point to, eg. a branch name)
# update    : Boolean             (whether the working dir is clean, fix commits so the repo is in sync with filesystem)
# remotes   : Array<Hash>         A list of settings for Fact::Git::Remote to depend on.
# branches  : Array<Hash>         A list of settings for Fact::Git::Branch to depend on.
# submodules: Array<Hash>         A list of settings for Fact::Git::Branch to depend on.
#
class Repo < Susu::Facts::Fact

include Susu::Facts::InstanceCount

attr_reader :repo



def self.configure( config )

	config.setup( self, :Git, :Facts, :Repo, sanitizer: method( :sanitize ) )

end


def initialize( path:, **opts )

	super( **opts, path: path.path )
	@repo = Git::Repo.new( @path )

end



# Make sure path is always a string for the address
#
def createAddress

	@indexKeys.map do |key|

		ret = options[ key ]

		key.to_sym == :path  and  ret = ret.expand_path.to_path

		ret

	end.unshift self.class.name

end




# Conditions
# Exist: Whether the path should point to a valid repository. When false, a .git file or directory inside path will be removed,
#        for a bare repository, the whole path will be removed. When true a git repository will be initialized.
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



# Define the ref head should point to. Could be a commit hash or a branch.
#
class Head < Susu::Facts::Condition


def analyze

	dependOn( :exist, true ) or return analyzeFailed

	super { @fact.repo.head }

end


def fix

	super do

		@fact.repo.checkout options.head

	end

end

end # class Head < Susu::Facts::Condition



# Verify whether the working directory is clean and commit everything if it isn't, so the
# git repository corresponds to the file system and the index is empty.
#
class Update < Susu::Facts::Condition


def analyze

	dependOn( :bare, false ) or return analyzeFailed

	super { @fact.repo.clean? }

end



def fix( msg = "Commit added by #{ self.class.name } to have a clean working dir" )

	super() do

		options.head       and dependOn( :head       )
		options.submodules and dependOn( :submodules )

		@fact.repo.addAll
		@fact.repo.commit msg

	end

end

end # class Update < Susu::Facts::Condition



# option: submodules: [ { name: 'sansa', path: 'ext/sansa', url: 'github.com/najamelan/sansa' } ]
#
class Submodules < Susu::Facts::Condition


def initialize **opts

	super

	@expect  = Array.eat( @expect )


	@modules = @expect.map do |opt|

		Facts::Submodule.new( repo: @fact.repo, **opt )

	end


	# Remove unwanted submodules
	#
	@fact.repo.submodules.each do |name, submodule|

		if @modules.none? { |mod| mod[ 'name' ] == name }

			@modules << Facts::Submodule.new( repo: @fact.repo, name: name, exist: false )

		end

	end

end



def analyze

	dependOn( :exist, true ) or return analyzeFailed

	super { @modules.all? :analyze }

end



def check

	super { @modules.all? :check }


end



def fix

	super { @modules.all? :fix }

end


end # class Submodules < Susu::Facts::Condition

end # class  Repo
end # module Facts
end # module Git
end # module Susu
