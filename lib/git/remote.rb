
module TidBits
module Git


class  Remote

include Options::Configurable

attr_reader :name, :url

def initialize( rug, git, **opts )

	setupOptions( opts )

	@git  = git
	@rug  = rug
	@url  = @rug.url
	@name = @rug.name


end

end # class  Repo
end # module Git
end # module TidBits
