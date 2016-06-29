require          'test/unit'
require          'pp'
require_relative '../../../lib/tidbits'

module TidBits
module Options



class TestHelper

include Configurable

def initialize( defaults, userset )

	setupOptions( defaults, userset )

end



def change( key, value )

	setOpt( key, value )

end


end # class TestHelper



class TestConfigurable < Test::Unit::TestCase


def testSetupOptionsCreate

	a = { type: 'defaults' }
	b = { type2: 'userset' }
	c = { type: 'defaults', type2: 'userset' }

	t = TestHelper.new( a, b )

	assert_equal( a, t.defaults )
	assert_equal( b, t.userset  )
	assert_equal( c, t.options  )

end


def testSetupOptionsOverride

	a = { type: 'defaults' }
	b = { type: 'userset'  }

	t = TestHelper.new( a, b )

	assert_equal( a, t.defaults )
	assert_equal( b, t.userset  )
	assert_equal( b, t.options  )

end


def testgetOptsNestedOverride

	a = { group: { type: 'defaults' } }
	b = { group: { type: 'userset'  } }

	t = TestHelper.new( a, b )

	assert_equal( a, t.defaults )
	assert_equal( b, t.userset  )
	assert_equal( b, t.options  )

end


def testgetOptsNestedRead

	a = { group: { type: 'defaults' } }
	b = { group: { type: 'userset'  } }
	c = 'userset'

	t = TestHelper.new( a, b )

	assert_equal( a, t.defaults )
	assert_equal( b, t.userset  )
	assert_equal( c, t.options( :group, :type ) )

end


def testSetOpts

	a = { group: { type: 'defaults' } }
	b = { group: { type: 'userset'  } }
	c = { group: 'userset' }


	t = TestHelper.new( a, b )
	t.change( :group, 'userset' )

	assert_equal( a, t.defaults )
	assert_equal( c, t.userset  )
	assert_equal( c, t.options  )

end


end # class  TestConfigurable
end # module Options
end # module TidBits
