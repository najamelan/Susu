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



end # class  Submodule
end # module Git
end # module Susu
