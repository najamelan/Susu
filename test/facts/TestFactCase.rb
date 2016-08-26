require 'etc'

Susu.refine binding

module Susu
module Facts

class TestFactCase < Test::Unit::TestCase


def self.startup

	@@tmp  = Dir.mktmpdir( [ '', self.lastname ] ).path

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

	assert_equal  state.to_set, fact.state

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



def assert_analyze fact, msg = ''

	assert(   fact.analyze       , msg.ai )
	assert(   fact.analyzed?     , msg.ai )
	assert(   fact.analyzePassed?, msg.ai )
	assert( ! fact.analyzeFailed?, msg.ai )
	assert( ! fact.fresh?        , msg.ai )

end



def assert_analyze_fail fact, msg = ''

	assert( ! fact.analyze       , msg.ai )
	assert(   fact.analyzed?     , msg.ai )
	assert( ! fact.analyzePassed?, msg.ai )
	assert(   fact.analyzeFailed?, msg.ai )
	assert( ! fact.fresh?        , msg.ai )

end



def assert_check fact, msg = ''

	assert(   fact.check         , msg.ai )
	assert(   fact.checked?      , msg.ai )
	assert(   fact.checkPassed?  , msg.ai )
	assert( ! fact.checkFailed?  , msg.ai )
	assert( ! fact.fresh?        , msg.ai )

end



def assert_check_fail fact, msg = ''

	assert( ! fact.check         , msg.ai )
	assert(   fact.checked?      , msg.ai )
	assert( ! fact.checkPassed?  , msg.ai )
	assert(   fact.checkFailed?  , msg.ai )
	assert( ! fact.fresh?        , msg.ai )

end



def assert_fix fact, msg = ''

	assert(   fact.fix           , msg.ai )
	assert(   fact.checked?      , msg.ai )
	assert(   fact.checkPassed?  , msg.ai )
	assert( ! fact.fixFailed?    , msg.ai )
	assert( ! fact.fresh?        , msg.ai )

end



def assert_fix_fail fact, msg = ''

	assert( ! fact.fix           , msg.ai )
	assert(   fact.fixed?        , msg.ai )
	assert( ! fact.fixPassed?    , msg.ai )
	assert(   fact.fixFailed?    , msg.ai )
	assert( ! fact.fresh?        , msg.ai )

end



end # class  TestFactCase
end # module Facts
end # module Susu
