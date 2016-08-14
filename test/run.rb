require 'test/unit'
require 'test/unit/ui/console/testrunner'


# Turn off test unit's auto runner
#
defined?( Test::Unit::AutoRunner ) and Test::Unit::AutoRunner.need_auto_run = false

require_relative 'refine/run'
require_relative 'fs/run'
require_relative 'options/run'
require_relative 'facts/run'
require_relative 'git/run'
# require_relative 'sys/run'


module Susu


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Susu TestSuite" )

	suite << Susu::Refine::TestSuite  .suite
	suite << Susu::Fs::TestSuite      .suite
	suite << Susu::Options::TestSuite .suite
	suite << Susu::Facts::TestSuite   .suite
	suite << Susu::Git::TestSuite     .suite
	# suite << Susu::Sys::TestSuite       .suite


end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self, output_level: Test::Unit::UI::Console::OutputLevel::VERBOSE )

end


end # TestSuite


end # Susu
