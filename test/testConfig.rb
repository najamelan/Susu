require_relative 'TestHelper'

module TidBits
module Options

class TestConfig < Test::Unit::TestCase

def self.startup


end


def setup

	TestHelper.reset
	@@config = Config.new 'data/default.yml'.relpath
	@@config.setup TestHelper

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

	Hashie.symbolize_keys! yml

	assert_equal( yml, TestHelper.settings.defaults )

end



def test02Overriding

	assert_equal( TestHelper.options.testing.level1.level2testing.foo, 'chinchin' )

end



def test03Runtime

	config = Config.new( 'data/default.yml'.relpath, 'data/runtime.yml'.relpath )
	config.setup TestHelper

	assert_equal( TestHelper.options          .runit.level1.level2testing.foo, 'chinchin' )
	assert_equal( TestHelper.settings.runtime .runit.level1.level2testing.foo, 'chinchin' )
	assert_equal( TestHelper.settings.userset .runit                         , nil        )
	assert_equal( TestHelper.settings.defaults.runit                         , nil        )

end



def test04AssignChildToClass

	@@config.setup( TestHelper, :testing, :level1  )

	assert_equal( 'chinchin', TestHelper.options.level2testing.foo )

end



def test05FilesAsString

	assert_nothing_thrown { Config.new 'data/default.yml'.relpath.to_s }

end


end # class  TestConfig
end # module Options
end # module TidBits
