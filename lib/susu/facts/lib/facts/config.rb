module Susu
module Facts


class Config


def initialize( profile = :default, runtime = [], **opts )

	@profile = profile.to_sym

	# get options from <installDir>/conf into defaults
	#
	@cfg = Susu::Options::ConfigProfile.new( profile: @profile, default: 'config.yml'.relpath, runtime: runtime )

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

	@cfg.setup( Condition, :Condition )

	profile == :testing or return

	@cfg.setup( TestFactPath, :TestFactPath )

	@cfg.setup( DummyFact   , :DummyFact, sanitizer: Fact.method( :sanitize ))
	@cfg.setup( MockFact    , :MockFact , sanitizer: Fact.method( :sanitize ))

end


end # class  Config



end # module Facts
end # module Susu
