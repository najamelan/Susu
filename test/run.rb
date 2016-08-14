require 'test/unit'
require 'test/unit/ui/console/testrunner'


# Turn off test unit's auto runner for those using the gem
#
defined?( Test::Unit::AutoRunner ) and Test::Unit::AutoRunner.need_auto_run = false


require_relative '../lib/core_extend/test/run'
require_relative '../lib/fs/test/run'
require_relative '../lib/options/test/run'
require_relative '../lib/facts/test/run'
require_relative '../lib/susu/test/run'


module TidBits


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "TidBits Unit Tests" )

	suite << TidBits::CoreExtend::TestSuite .suite
	suite << TidBits::Fs::TestSuite         .suite
	suite << TidBits::Options::TestSuite    .suite
	suite << TidBits::Facts::TestSuite      .suite
	# suite << TidBits::Sys::TestSuite       .suite


end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self )

end


end # TestSuite


end # TidBits
