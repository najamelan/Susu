Susu.refine binding

module Susu
module Git

# Preload classes
#
Remote
Branch

class Repo

include Options::Configurable



def self.configure( config )

	config.setup( self, :Git, :Repo )

end



def self.clone src, dst, **opts

	src.respond_to?( :to_path ) and src = src.to_path
	dst.respond_to?( :to_path ) and dst = dst.to_path

	Rugged::Repository.clone_at( src, dst, opts )
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

	# reset

	@rug.branches.each_with_object( {} ) { |branch, memo| memo[ branch.name ] = Branch.new( self, branch, @rug, @git ) }

end



def remotes

	# reset

	@rug.remotes.each_with_object( {} ) { |remote, memo| memo[ remote.name ] = Remote.new( remote, @git ) }

end



def submodules

	# reset

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

	@rug  or reset

	@rug and return @rug.bare?

	# TODO: warn for trying to call bare? on non-existing repo

	nil

end



def head

	@rug  or reset

	@rug and return @rug.head.name.remove( /refs\/heads\// )

	# TODO: warn for trying to call head on non-existing repo

	nil

end



def init( bare = false )

	@rug and reset
	@rug and raise 'Trying to init existing repository.'

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

	Fs::Path.pushd( @path ) do

		ret = `git status -s`.lines.count == 0
		$CHILD_STATUS == 0 or raise "Git returned an error, Results are not reliable."

		ret

		# Does not work
		# @rug.diff_workdir( @rug.head.name ).size == 0

	end

end



def add pathspec

	valid? or raise 'Trying to add on a non-existing git repo.'

	cleanupAfterRubyGit { @git.add pathspec }

end



def addAll

	valid? or raise 'Trying to add on a non-existing git repo.'

	cleanupAfterRubyGit { @git.add( all: true ) }

end



def commit( message, **opts )

	valid? or raise 'Trying to commit a non-existing git repo.'

	# Rugged doesn't seem to have commit
	#
	cleanupAfterRubyGit { @git.commit( message, opts ) }

end



def pollute

	valid? or raise 'Trying to pollute a non-existing git repo.'

	@path.touch 'polluteWorkingDir'
	@path.touch 'polluteIndex'

	cleanupAfterRubyGit { @git.add 'polluteIndex' }

end



def addSubmodule sub, subpath = nil, **opts

	valid? or raise 'Trying to add a submodule to a non-existing git repo.'

	subpath.nil? and subpath = sub.path.basename

	@rug.submodules.add( sub.to_path, subpath.to_path, opts )

	self.class.new @path[ subpath ]

end



# Keep ruby-git from messing with the environment variables
# ruby-git already seems to have code to prevent this, but apparently it doesn't work.
# Bug not reported.
#
def cleanupAfterRubyGit

	env = ENV.to_h

	yield

ensure

	ENV.replace env

end



end # class  Repo
end # module Git
end # module Susu
