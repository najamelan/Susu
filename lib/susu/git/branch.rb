using Susu.refines

module Susu
module Git


class  Branch

include Options::Configurable


attr_reader :name, :repo



def self.configure( config )

	config.setup( self, :Git, :Branch )

end



def initialize( repo, rug, **opts )

	super opts

	@repo       = repo
	@rug        = rug
	@name       = @rug.name

end



def upstream

	@rug.upstream  or  return nil

	self.class.new( @repo, @rug.upstream, runtime )

end



def remoteName

	@rug.remote_name

end



def upstreamName

	@rug.upstream or return nil

	@rug.upstream.name

end



def diverged

	@name && upstream && remoteName  or  return nil

	@repo.cleanupAfterRubyGit { repo.git.fetch remoteName }

	result = @repo.rug.ahead_behind( @name, upstream.name )

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



def ahead?    ; ahead  or return nil; ahead   > 0 end
def behind?   ; behind or return nil; behind  > 0 end


def diverged?

	ahead && behind  or  return nil

	ahead  != 0 && behind != 0

end


end # class  Branch
end # module Git
end # module Susu
