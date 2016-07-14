require_relative 'TestHelper'

module TidBits
module Options

class TestConfigProfile < Test::Unit::TestCase

def self.startup

	TestHelper.reset
	@@config = ConfigProfile.new( :testing, 'data/default.yml'.relpath )
	@@config.setup TestHelper

end


def setup


end



def test00ClassProperties

	assert( TestHelper.settings.defaults.instance_of?( Settings ) )
	assert( TestHelper.settings.userset .instance_of?( Settings ) )
	assert( TestHelper.settings.runtime .instance_of?( Settings ) )
	assert( TestHelper.options          .instance_of?( Settings ) )

end



def test01ClassDefaults

	yml = YAML.load_file( 'data/default.yml'.relpath )
	yml.delete( 'include' )

	assert_equal( yml[ 'defaults' ], TestHelper.settings.defaults )

end



def test02ClassOptions

	defaults = YAML.load_file( 'data/default.yml'.relpath )
	yml      = YAML.load_file( 'data/user.yml'    .relpath )
	yml2     = YAML.load_file( 'data/user2.yml'   .relpath )

	defaults.deep_merge!( yml ).deep_merge!( yml2 )
	defaults.delete( 'include' )

	result = defaults[ 'defaults' ].deep_merge defaults[ 'testing' ]

	assert_equal( result, TestHelper.options )

end



def test03Overriding

	assert_equal( TestHelper.options.level1.level2testing.foo, 'chinchin' )

end



def test04Runtime


end


end # class  TestConfigProfile
end # module Options
end # module TidBits
