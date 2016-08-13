require 'etc'

module TidBits
module Facts


class StateTest

	include State

	attr_accessor :state

	public :analyzePassed, :checkPassed, :fixPassed, :analyzeFailed, :checkFailed, :fixFailed, :reset

end # class StateTest


class TestState < Test::Unit::TestCase


def setup

	@s = StateTest.new

end


def test00Constructor

	assert_equal  [ :fresh ].to_set, @s.state

end


def test01Fresh

	assert   @s.fresh?

	assert ! @s.analyzePassed?
	assert ! @s.checkPassed?
	assert ! @s.fixPassed?
	assert ! @s.analyzeFailed?
	assert ! @s.checkFailed?
	assert ! @s.fixFailed?

	assert ! @s.analyzed?
	assert ! @s.checked?
	assert ! @s.fixed?

end


def test02AnalyzePassed

	@s.analyzePassed

	assert_equal  [ :analyzePassed ].to_set, @s.state

	assert ! @s.fresh?

	assert   @s.analyzed?
	assert   @s.analyzePassed?
	assert ! @s.analyzeFailed?

	assert ! @s.checked?
	assert ! @s.checkPassed?
	assert ! @s.checkFailed?

	assert ! @s.fixed?
	assert ! @s.fixPassed?
	assert ! @s.fixFailed?


end


def test03AnalyzeFailed

	@s.analyzeFailed

	assert_equal  [ :analyzeFailed ].to_set, @s.state

	assert ! @s.fresh?

	assert   @s.analyzed?
	assert ! @s.analyzePassed?
	assert   @s.analyzeFailed?

	assert ! @s.checked?
	assert ! @s.checkPassed?
	assert ! @s.checkFailed?

	assert ! @s.fixed?
	assert ! @s.fixPassed?
	assert ! @s.fixFailed?

end


def test03CheckPassed

	@s.checkPassed

	assert_equal  [ :checkPassed ].to_set, @s.state

	assert ! @s.fresh?

	assert ! @s.analyzed?
	assert ! @s.analyzePassed?
	assert ! @s.analyzeFailed?

	assert   @s.checked?
	assert   @s.checkPassed?
	assert ! @s.checkFailed?

	assert ! @s.fixed?
	assert ! @s.fixPassed?
	assert ! @s.fixFailed?

end


def test04CheckFailed

	@s.checkFailed

	assert_equal  [ :checkFailed ].to_set, @s.state

	assert ! @s.fresh?

	assert ! @s.analyzed?
	assert ! @s.analyzePassed?
	assert ! @s.analyzeFailed?

	assert   @s.checked?
	assert ! @s.checkPassed?
	assert   @s.checkFailed?

	assert ! @s.fixed?
	assert ! @s.fixPassed?
	assert ! @s.fixFailed?

end


def test05FixPassed

	@s.fixPassed

	assert_equal  [ :fixPassed ].to_set, @s.state

	assert ! @s.fresh?

	assert ! @s.analyzed?
	assert ! @s.analyzePassed?
	assert ! @s.analyzeFailed?

	assert ! @s.checked?
	assert ! @s.checkPassed?
	assert ! @s.checkFailed?

	assert   @s.fixed?
	assert   @s.fixPassed?
	assert ! @s.fixFailed?

end


def test06FixFailed

	@s.fixFailed

	assert_equal  [ :fixFailed ].to_set, @s.state

	assert ! @s.fresh?

	assert ! @s.analyzed?
	assert ! @s.analyzePassed?
	assert ! @s.analyzeFailed?

	assert ! @s.checked?
	assert ! @s.checkPassed?
	assert ! @s.checkFailed?

	assert   @s.fixed?
	assert ! @s.fixPassed?
	assert   @s.fixFailed?

end


def test07CombinePassed

	@s.analyzePassed
	@s  .checkPassed
	@s    .fixPassed

	assert_equal  [ :analyzePassed, :checkPassed, :fixPassed ].to_set, @s.state

	assert ! @s.fresh?

	assert   @s.analyzed?
	assert   @s.analyzePassed?
	assert ! @s.analyzeFailed?

	assert   @s.checked?
	assert   @s.checkPassed?
	assert ! @s.checkFailed?

	assert   @s.fixed?
	assert   @s.fixPassed?
	assert ! @s.fixFailed?

end


def test07CombineFailed

	@s.analyzeFailed
	@s  .checkFailed
	@s    .fixFailed

	assert_equal  [ :analyzeFailed, :checkFailed, :fixFailed ].to_set, @s.state

	assert ! @s.fresh?

	assert   @s.analyzed?
	assert ! @s.analyzePassed?
	assert   @s.analyzeFailed?

	assert   @s.checked?
	assert ! @s.checkPassed?
	assert   @s.checkFailed?

	assert   @s.fixed?
	assert ! @s.fixPassed?
	assert   @s.fixFailed?

end


def test08CombineMixed

	@s.analyzePassed
	@s  .checkFailed
	@s    .fixFailed

	assert_equal  [ :analyzePassed, :checkFailed, :fixFailed ].to_set, @s.state

	assert ! @s.fresh?

	assert   @s.analyzed?
	assert   @s.analyzePassed?
	assert ! @s.analyzeFailed?

	assert   @s.checked?
	assert ! @s.checkPassed?
	assert   @s.checkFailed?

	assert   @s.fixed?
	assert ! @s.fixPassed?
	assert   @s.fixFailed?

end


def test09Reset

	@s.analyzePassed
	@s  .checkFailed
	@s    .fixFailed
	@s        .reset

	assert_equal  [ :fresh ].to_set, @s.state

	assert   @s.fresh?

	assert ! @s.operating?

	assert ! @s.analyzed?
	assert ! @s.analyzePassed?
	assert ! @s.analyzeFailed?
	assert ! @s.analyzing?

	assert ! @s.checked?
	assert ! @s.checkPassed?
	assert ! @s.checkFailed?
	assert ! @s.checking?

	assert ! @s.fixed?
	assert ! @s.fixPassed?
	assert ! @s.fixFailed?
	assert ! @s.fixing?

end


end # class  TestState
end # module Facts
end # module TidBits
