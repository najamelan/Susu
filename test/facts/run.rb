require 'test/unit'
require 'test/unit/ui/console/testrunner'

eval Susu::ALL_REFINES, binding

# Turn off test unit's auto runner for those using the gem
#
Test::Unit::AutoRunner.need_auto_run = false



module Susu

# Autoload before reopen
#
Facts

module Facts

require_relative 'TestFactCase'

Dir.entries( File.dirname( __FILE__ ) ).sort.

	grep( /test.*\.rb/ ) { | file | require_relative file }


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Facts TestSuite" )

	suite << TestState    .suite
	suite << TestFact     .suite
	suite << TestFactPath .suite


end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self, output_level: Test::Unit::UI::Console::OutputLevel::VERBOSE )

end


end # TestSuite


end # Facts
end # Susu
