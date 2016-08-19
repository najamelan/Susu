require 'test/unit'
require 'test/unit/ui/console/testrunner'


# Turn off test unit's auto runner for those using the gem
#
Test::Unit::AutoRunner.need_auto_run = false


Dir.entries( File.dirname( __FILE__ ) ).

	grep( /test.*\.rb/ ) { | file | require_relative file }



module Susu
module Refine


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Refine TestSuite" )

	suite << TestArray   .suite
	suite << TestHash    .suite
	suite << TestModule  .suite
	suite << TestNumeric .suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self )

end


end # TestSuite


end # Refine
end # Susu
