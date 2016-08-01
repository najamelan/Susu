module TidBits
module Git

class Repo

include Options::Configurable



# The string path for the repo
#
attr_reader :path

# An array of TidBits::Remote objects for the repository.
#
attr_reader :remotes

# An array of TidBits::Branch objects for the repository.
#
attr_reader :branches


def initialize( path, **opts )

	setupOptions( opts )

	@path     = path.path
	@remotes  = {}
	@branches = {}

	createBackend

end



def createBackend

	# Create a backend if the repo path exist and is a repo
	#
	begin

		@rug ||= Rugged::Repository.new( @path.to_path )

		@git ||=  @rug.bare?  ?  ::Git::Base.bare( @path.to_path )
		                      :  ::Git::Base.open( @path.to_path )


		@rug.remotes.each do |remote|

			@remotes[ remote.name ] = Remote.new( remote, @git )

		end


		@rug.branches.each do |branch|

			@branches[ branch.name ] = Branch.new( branch, @rug, @git )

		end

	# ruby-git throws ArgumentError
	#
	rescue Rugged::RepositoryError, Rugged::OSError, ArgumentError => e

		@rug = @git = @remotes = @branches = nil

	end

end



def pathExists?() File.exist? @path end



def valid?

	# It's a bit silly to call this everytime, but it seems the only way to avoid stale data.
	#
	@rug = nil
	createBackend

	!!@rug

end



def bare?

	!@rug and createBackend

	@rug and return @rug.bare?

	nil

end



def head

	@rug.head.name.remove( /refs\/heads\// )

end



def init( bare = false )

	@rug = Rugged::Repository.init_at( @path.to_path, bare )

	createBackend

end



def deinit

	bare = bare?

	@rug = @git = @remotes = @branches = nil

	bare and @path.rm_secure
	bare or  @path.join( '.git' ).rm_secure

end



def workingDirClean?()

	pwd = Dir.pwd
	Dir.chdir @path

	clean = `git status -s`.lines.length == 0

	# Does not work
	# @rug.diff_workdir( @rug.head.name ).size == 0

	Dir.chdir pwd

	clean

end


end # class  Repo
end # module Git
end # module TidBits
