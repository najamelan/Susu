module TidBits
module Git


class Config


def initialize( profile = :default, runtime = [], **opts )

	@profile = profile.to_sym

	# get options from <installDir>/conf into defaults
	#
	@cfg = TidBits::Options::ConfigProfile.new( profile: @profile, default: 'config.yml'.relpath, runtime: runtime )

	@cfg.setup( self.class )
	setupOptions opts

	# Setup the defaults for all classes
	#
	setupDefaults @profile

end

protected

def setupDefaults profile

	@cfg.setup( Repo         , :Repo           )
	@cfg.setup( Remote       , :Remote         )
	@cfg.setup( Branch       , :Branch         )

	@cfg.setup( Facts::Repo  , :Facts, :Repo   , sanitizer: TidBits::Facts::Fact.method( :sanitize ) )
	@cfg.setup( Facts::Remote, :Facts, :Remote )
	@cfg.setup( Facts::Branch, :Facts, :Branch )

	profile == :testing or return

	@cfg.setup( TestRepo, :TestRepo )

end


end # class  Config



end # module Git
end # module TidBits
