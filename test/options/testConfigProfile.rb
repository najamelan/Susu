require_relative 'TestHelper'

module TidBits
module Options

class TestConfigProfile < Test::Unit::TestCase

def self.startup

	TestHelper.reset
	@@config = ConfigProfile.new( profile: :testing, default: 'data/default.yml' )
	@@config.setup TestHelper

end


def test00ClassProperties

	assert( TestHelper.settings.default.instance_of?( Settings ) )
	assert( TestHelper.settings.userset.instance_of?( Settings ) )
	assert( TestHelper.settings.runtime.instance_of?( Settings ) )
	assert( TestHelper.options         .instance_of?( Settings ) )

end



def test01ClassDefault

	yml = Settings.load( 'data/default.yml'.relpath )

	yml.delete( :include )

	assert_equal( yml[ :default ], TestHelper.settings.default )

end



def test02ClassOptions

	default = Settings.load( 'data/default.yml'.relpath )
	yml     = Settings.load( 'data/user.yml'   .relpath )
	yml2    = Settings.load( 'data/user2.yml'  .relpath )

	default.deep_merge!( yml ).deep_merge!( yml2 )
	default.delete( :include )

	result = default[ :default ].deep_merge default[ :testing ]

	assert_equal( result, TestHelper.options )

end



def test03Overriding

	assert_equal( TestHelper.options.level1.level2testing.foo, 'chinchin' )

end



def test04Overriding

	assert_raise( RuntimeError ) { ConfigProfile.new profile: :include }

end


end # class  TestConfigProfile
end # module Options
end # module TidBits
