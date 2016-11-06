Susu.refine binding

module Susu
module Git


class  Branch

include Options::Configurable


attr_reader :name, :upstream



def self.configure( config )

	config.setup( self, :Git, :Branch )

end


def initialize( repo, rug, rugRepo, git, **opts )

	super( opts )

	@repo       = repo
	@git        = git
	@rug        = rug
	@rugRepo    = rugRepo
	@name       = @rug.name

end



def upstream

	@rug.upstream  or return nil
	@upstream     and return @upstream

	@upstream = self.class.new( @repo, @rug.upstream, @rugRepo, @git, runtime )

end



def remoteName

	@rug.remote_name

end



def upstreamName

	@rug.upstream or return nil

	@rug.upstream.name

end



def diverged

	@name      or return nil
	upstream   or return nil
	remoteName or return nil

	@repo.cleanupAfterRubyGit { @git.fetch remoteName }

	result = @rugRepo.ahead_behind( @name, upstream.name )

	result

end



def ahead

	diverged.nil? and return nil

	diverged.first

end



def behind

	diverged.nil? and return nil

	diverged.last

end



def ahead?    ; ahead or return nil; ahead   > 0 end
def behind?   ; ahead or return nil; behind  > 0 end


def diverged?

	ahead && behind  or  return nil

	ahead  != 0 && behind != 0

end


end # class  Repo
end # module Git
end # module Susu
