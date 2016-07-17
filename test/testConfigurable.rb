require_relative 'TestHelper'

module TidBits
module Options

class TestConfigurable < Test::Unit::TestCase

def self.startup

end


def setup

	TestHelper.reset
	@@config = Config.new 'data/default.yml'.relpath
	@@config.setup TestHelper

end


def test00InstanceProperties

	assert_instance_of( Settings, TestHelper.new.class.settings.defaults )
	assert_instance_of( Settings, TestHelper.new.class.settings.userset  )
	assert_instance_of( Settings, TestHelper.new.class.settings.runtime  )
	assert_instance_of( Settings, TestHelper.new.class.options           )
	assert_instance_of( Settings, TestHelper.new      .options           )

end


def test01Profiles

	TestHelper.reset
	@@config = ConfigProfile.new :testing, 'data/default.yml'.relpath, 'data/runtime.yml'.relpath
	@@config.setup TestHelper

	t = TestHelper.new( bollywood: 'cool' )

	assert_equal( 'cool'    , t.options.bollywood                )
	assert_equal( 'chinchin', t.options.level1.level2testing.foo )

	assert_false( t.options.has_key? :runit  )
	assert_false( t.options.has_key? 'runit' )

end




end # class  TestConfigurable
end # module Options
end # module TidBits
