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


module Susu


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Susu Unit Tests" )

	suite << Susu::CoreExtend::TestSuite .suite
	suite << Susu::Fs::TestSuite         .suite
	suite << Susu::Options::TestSuite    .suite
	suite << Susu::Facts::TestSuite      .suite
	# suite << Susu::Sys::TestSuite       .suite


end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self )

end


end # TestSuite


end # Susu
