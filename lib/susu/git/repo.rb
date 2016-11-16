require 'English'

Susu.refine binding

module Susu
module Git

# Preload classes
#
Remote
Branch

class Repo

include Options::Configurable


attr_reader :rug, :git


def self.configure( config )

	config.setup( self, :Git, :Repo )

end



#-------------------------------------------------------------------------------
# Clone a git repository.
#
# @param  src    [respond_to :to_path] The source repo
# @param  dst    [respond_to :to_path] The destination path
# @param  **opts [Hash               ] Options to be passed to Rugged::Repository.clone_at
#
# @return The new repository
#
def self.clone src, dst, **opts

	Rugged::Repository.clone_at( src.to_path, dst.to_path, opts )
	new( dst )

end



def initialize( path, **opts )

	super opts

	@path = path.path

	reset

end



def reset

	# It's a bit silly to call this everytime, but it seems the only way to avoid stale data.
	#
	@rug and @rug.close

	@rug = @git = nil

	createBackend

end



def createBackend

	# Create a backend if the repo path exist and is a repo
	#
	@rug ||= Rugged::Repository.new( @path.to_path )

	@git ||=  @rug.bare?  ?  ::Git::Base.bare( @path.to_path )
	                      :  ::Git::Base.open( @path.to_path )


	# ruby-git throws ArgumentError
	#
	rescue Rugged::RepositoryError, Rugged::OSError, ArgumentError # => e

		@rug = @git = nil

end



# TODO: optimize. We could cache branche objects after all and reuse them where nothing has changed.
#
def branches

	validate

	@rug.branches.each_with_object( {} ) { |branch, memo| memo[ branch.name ] = Branch.new( self, branch, @rug, @git ) }

end



def remotes

	validate

	@rug.remotes.each_with_object( {} ) { |remote, memo| memo[ remote.name ] = Remote.new( remote, @git ) }

end



def submodules

	validate

	@rug.submodules.each_with_object( {} ) { |sub, memo| memo[ sub.name ] = self.class.new( @path[ sub.path ] ) }

end



def to_path

	@path.to_path

end



def path

	@path.path

end



def valid?

	reset

	!!@rug

end



def bare?

	validate

	@rug.bare?

end



def head

	validate

	@rug and return @rug.head.name.gsub!( /refs\/heads\//, '' )

end



def init( bare = false )

	@rug and reset
	@rug and raise 'Trying to init an already existing repository.'

	@rug = Rugged::Repository.init_at( @path.to_path, bare )

	createBackend

end



def deinit

	bare? ?

		  @path.rm_secure
		: @path[ '.git' ].rm_secure

	@rug = @git = @remotes = nil

end



def clean?

	validate

	Fs::Path.pushd( @path ) do

		ret = `git status -s`.lines.count == 0
		$CHILD_STATUS == 0 or raise "Git returned an error, Results are not reliable."

		ret

		# Does not work
		# @rug.diff_workdir( @rug.head.name ).size == 0

	end

end



def add pathspec

	validate

	cleanupAfterRubyGit { @git.add pathspec }

end



def checkout target, **opts

	validate

	@rug.checkout target, opts

end



def addAll

	validate

	cleanupAfterRubyGit { @git.add( all: true ) }

end



def commit( message, **opts )

	validate

	cleanupAfterRubyGit { @git.commit( message, opts ) }

end



def graph

	validate

	Fs::Path.pushd( @path ) do

		ap Fs::Path::pwd
		ret = `git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit  --all`
		$CHILD_STATUS == 0 or raise "Git returned an error [exit:#{ $CHILD_STATUS }], Results are not reliable."

		ret

	end

end



def pollute

	validate

	@path.touch 'polluteWorkingDir'
	@path.touch 'polluteIndex'

	cleanupAfterRubyGit { @git.add 'polluteIndex' }

end



def addSubmodule sub, subpath = nil, **opts

	validate

	subpath.nil? and subpath = sub.path.basename

	@rug.submodules.add( sub.to_path, subpath.to_path, opts )

	self.class.new @path[ subpath ]

end



def addBranch name, target = 'HEAD'

	validate

	rugBranch = @rug.create_branch( name, target )

	Branch.new self, rugBranch, @rug, @git

end



# Keep ruby-git from messing with the environment variables
# ruby-git already seems to have code to prevent this, but apparently it doesn't work.
# TODO: Bug not reported.
#
def cleanupAfterRubyGit

	env = ENV.to_h

	yield

ensure

	ENV.replace env

end


private

def validate

	options.validate or return

	valid? or raise "#{ caller[0] } requires an initialized repository."

end



end # class  Repo
end # module Git
end # module Susu
