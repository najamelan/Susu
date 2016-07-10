require          'test/unit'
require          'awesome_print'
require          'byebug'
require_relative '../../../lib/tidbits'

module TidBits
module Options

class TestConfigurable < Test::Unit::TestCase


def setup

	load File.expand_path( 'TestHelper.rb', File.dirname( __FILE__ ) )

end


def teardown

	TidBits::Options.class_eval do

		remove_const :TestHelper if const_defined? :TestHelper

	end

end


def testSetupOptionsCreate

	a = { type: 'defaults' }
	b = { type2: 'userset' }
	c = { type: 'defaults', type2: 'userset' }

	TestHelper.defaults = a
	t = TestHelper.new( b )

	assert_equal( a, t.defaults )
	assert_equal( b, t.userset  )
	assert_equal( c, t.options  )

end


def testSetupOptionsOverride

	a = { type: 'defaults' }
	b = { type: 'userset'  }

	TestHelper.defaults = a
	t = TestHelper.new( b )

	assert_equal( a, t.defaults )
	assert_equal( b, t.userset  )
	assert_equal( b, t.options  )

end


def testgetOptsNestedOverride

	a = { group: { type: 'defaults' } }
	b = { group: { type: 'userset'  } }

	TestHelper.defaults = a
	t = TestHelper.new( b )

	assert_equal( a, t.defaults )
	assert_equal( b, t.userset  )
	assert_equal( b, t.options  )

end


def testgetOptsNestedRead

	a = { group: { type: 'defaults' } }
	b = { group: { type: 'userset'  } }
	c = 'userset'

	TestHelper.defaults = a
	t = TestHelper.new( b )

	assert_equal( a, t.defaults )
	assert_equal( b, t.userset  )
	assert_equal( c, t.options( :group, :type ) )

end


def testgetOptsFixnum

	a = { group: { type: 'defaults' } }
	b = { group: { type: 3          } }
	c = 3

	TestHelper.defaults = a
	t = TestHelper.new( b )

	assert_equal( a, t.defaults )
	assert_equal( b, t.userset  )
	assert_equal( c, t.options( :group, :type ) )

end


def testgetOptsNil

	a = { group: { type: 'defaults' } }
	b = { group: { type: nil        } }
	c = nil

	TestHelper.defaults = a
	t = TestHelper.new( b )

	assert_equal( a, t.defaults )
	assert_equal( b, t.userset  )
	assert_equal( c, t.options( :group, :type ) )

end


def testgetOptsEmptyHash

	a = { group: { type: 'defaults' } }
	b = { group: { type: {}         } }
	c = {}

	TestHelper.defaults = a
	t = TestHelper.new( b )

	assert_equal( a, t.defaults )
	assert_equal( b, t.userset  )
	assert_equal( c, t.options( :group, :type ) )

end


def testSetOpts

	a = { group: { type: 'defaults' } }
	b = { group: { type: 'userset'  } }
	c = { group: 'userset' }


	TestHelper.defaults = a
	t = TestHelper.new( b )

	t.change( :group, 'userset' )

	assert_equal( a, t.defaults )
	assert_equal( c, t.userset  )
	assert_equal( c, t.options  )

end


def testSymbolizeKeysSetupOptions

	a = { group: { type:     'defaults' } }
	b = { group: { 'type' => 'userset'  } }
	c = { group: { type:     'userset'  } }


	TestHelper.defaults = a
	t = TestHelper.new( b )

	assert_equal( a, t.defaults )
	assert_equal( c, t.userset  )
	assert_equal( c, t.options  )

end


def testSymbolizeKeysSetOpts

	a = { group: { type:     'defaults' } }
	b = { group: { 'type' => 'userset'  } }
	c = { group: { type:     'userset'  } }


	TestHelper.defaults = a
	t = TestHelper.new( b )

	t.change( :group, { 'type': 'userset'  } )

	assert_equal( a, t.defaults )
	assert_equal( c, t.userset  )
	assert_equal( c, t.options  )


	# Send in the main key as string
	#
	t = TestHelper.new( b )
	t.change( 'group', { 'type' => 'userset' } )

	assert_equal( c, t.options  )

end


def testClassDefaults

	assert_equal( {}, TestHelper.defaults )

end


def testClassDefaultsValidation

	assert_raise( ArgumentError ){ TestHelper.defaults = nil }
	assert_raise( ArgumentError ){ TestHelper.defaults = []  }

end


def testClassDefaultsAutodestruct

	TestHelper.defaults = { a: 1 }

	assert_raise( RuntimeError ){ TestHelper.defaults = {} }
	assert_raise( RuntimeError ){ TestHelper.defaults = []  }

end


end # class  TestConfigurable
end # module Options
end # module TidBits
