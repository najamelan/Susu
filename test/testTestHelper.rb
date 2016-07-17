require_relative 'TestHelper'

module TidBits
module Options

class TestTestHelper < Test::Unit::TestCase

def self.startup


end


def setup



end



def test00Reset

	@@config = Config.new 'data/default.yml'.relpath
	@@config.setup TestHelper

	assert_respond_to( TestHelper, :settings )
	assert_respond_to( TestHelper, :options  )

	TestHelper.reset

	assert_not_respond_to( TestHelper, :settings )
	assert_not_respond_to( TestHelper, :options  )

end


end # class  TestTestHelper
end # module Options
end # module TidBits
