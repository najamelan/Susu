using Susu.refines

module Susu
module Git


class  Submodule

include Options::Configurable


attr_reader :name, :repo, :rug



def self.configure( config )

	config.setup( self, :Git, :Submodule )

end



def initialize( repo, rug, **opts )

	super( opts )

	@repo = repo
	@rug  = rug
	@name = @rug.name

end



def subRepo

	Repo.new( path, @repo.options )

end



def lpath

	@rug.path.path

end



def path

	@repo.path/lpath

end



def url

	@rug.url

end

# git version 2.10.2
#
# mkdir a
# mkdir b
# cd b
# git init
# touch file
# commit
# cd ../a
# git init
# git submodule add ../b
# - creates .gitmodules with info of submodule b
# - creates subdir b with contents
# - creates dir .git/modules/b with repo
# - writes submodules info into .git/config
# - cannot run deinit at this point before committing
# commit
# A---> git submodule deinit b
# - empties but doesn't remove submodule folder
# - removes submodule info from .git/config
# B---> gir rm b
# - removes b
# - removes submodule info from .gitmodules, but does not delete .gitmodules
# - does not remove submodules info from .git/config
# after B, A no longer possible and trace in .git/config stays
# after B, can only get back submodule by running git submodule add
# .git/modules/b stays in any case
# run deinit rm and commit
# git checkout HEAD^1
# - brings back b as empty directory
# - nothing in .git/config
# git submodule init b
# - recopies into .git/config but doesn't checkout
# git submodule update b
# - checkout contents
# git co master
# - .gitmodules is emptied, but b not removed, b is now untracked
# - git reset --hard does not remove b
# - git clean -ffd is needed for removing b
# - .git/config is not cleaned up
# We are now back at the point just after git rm b
# git submodule add b now requires --force in order to readd b because .git/modules/b still exists
# now git submodule add inits and checks out the repository just like before.
#
# Flags for the state of a submodule:
#
# - exists in ./git/modules/<name>
# - exists in ./git/config
# - exists in .gitmodules
# - directory exists
# - repo checked out
# - exists in index
# - exists in HEAD
#
# - submodule has modified files
# - submodule has untracked files
# - submodule has new commits (sub HEAD has changed from what's registered in superproject HEAD)
#
# Realistic Provisionning scenarios:
# - have it checked out with bottom up (fs is reference) or top down (superproject repo is reference)
# - deinit if we don't want to use it.
#
def init

	@rug.init

end



def deinit

	Fs::Path::pushd @repo.path do

		stdout, stderr, status = Open3.capture3( "git submodule deinit #{ lpath.shellescape }" )

		status == 0 or raise "Git returned an error, Results are not reliable:\n#{ stdout }\n#{ stderr }"

	end

end



def remove( msg = "Remove submodule #{ lpath }" )

	# TODO: Stash and pop, since we're committing.

	deinit

	Fs::Path::pushd @repo.path do

		stdout, stderr, status = Open3.capture3( "git rm #{ lpath.shellescape }" )

		status == 0 or raise "Git returned an error, Results are not reliable:\n#{ stdout }\n#{ stderr }"

	end

	repo.commit msg

end



end # class  Submodule
end # module Git
end # module Susu
