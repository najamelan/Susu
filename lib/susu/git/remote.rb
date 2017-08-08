using Susu.refines

module Susu
module Git


class  Remote

include Options::Configurable

attr_reader :name, :url



def self.configure( config )

	config.setup( self, :Git, :Remote )

end



def initialize( rug, git, **opts )

	super( opts )

	@git  = git
	@rug  = rug
	@url  = @rug.url
	@name = @rug.name


end

end # class  Repo
end # module Git
end # module Susu
