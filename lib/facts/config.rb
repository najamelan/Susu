module TidBits
module Facts


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

	@cfg.setup( Fact                 , :Fact         , sanitizer: Fact.method( :sanitize ) )
	@cfg.setup( Path                 , :Path         , sanitizer: Path.method( :sanitize ) )

	@cfg.setup( Conditions::Condition, :Conditions, :Condition )

	profile == :testing or return

	@cfg.setup( TestFactPath, :TestFactPath )

end


end # class  Config



end # module Facts
end # module TidBits
