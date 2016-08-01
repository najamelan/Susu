require 'etc'

module TidBits
module Facts

class TestFactCase < Test::Unit::TestCase


def self.startup

	@@tmp  = Dir.mktmpdir( self.class.lastname ).path

end


def self.shutdown

	@@tmp.rm_secure

end


def setup

	@@tmpdir  = @@tmp.path.mkdir method_name

end


def teardown

	@@tmpdir.rm_secure

end



def assert_state state, fact

	state.kind_of?( Set )  or  state = Array.eat( state )

	assert_equal  state.to_set, fact.status

end



def assert_option value, fact, name

	assert_equal  value, fact.options[ name ]

end



def assert_param value, fact, name

	assert_equal  value, fact.params[ name ]

end



def assert_meta value, fact, name

	assert_equal  value, fact.metas[ name ]

end



def assert_analyze fact

	assert   fact.analyze
	assert   fact.analyzed?
	assert   fact.analyzePassed?
	assert ! fact.analyzeFailed?
	assert ! fact.fresh?

end



def assert_analyze_fail fact

	assert ! fact.analyze
	assert   fact.analyzed?
	assert ! fact.analyzePassed?
	assert   fact.analyzeFailed?
	assert ! fact.fresh?

end



def assert_check fact

	assert   fact.check
	assert   fact.checked?
	assert   fact.checkPassed?
	assert ! fact.checkFailed?
	assert ! fact.fresh?

end



def assert_check_fail fact

	assert ! fact.check
	assert   fact.checked?
	assert ! fact.checkPassed?
	assert   fact.checkFailed?
	assert ! fact.fresh?

end



def assert_fix fact

	assert   fact.fix
	assert   fact.fixed?
	assert   fact.fixPassed?
	assert ! fact.fixFailed?
	assert ! fact.fresh?

end



def assert_fix_fail fact

	assert ! fact.fix
	assert   fact.fixed?
	assert ! fact.fixPassed?
	assert   fact.fixFailed?
	assert ! fact.fresh?

end



end # class  TestFactCase
end # module Facts
end # module TidBits
