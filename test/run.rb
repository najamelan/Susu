require 'test/unit'
require 'test/unit/ui/console/testrunner'


# Turn off test unit's auto runner for those using the gem
#
defined?( Test::Unit::AutoRunner ) and Test::Unit::AutoRunner.need_auto_run = false

require_relative 'TestFactCase'

Dir.entries( File.dirname( __FILE__ ) ).sort.

	grep( /test.*\.rb/ ) { | file | require_relative file }



module TidBits
module Facts


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Facts Unit Tests" )

	suite << TestStatus   .suite
	suite << TestFactPath .suite


end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self )

end


end # TestSuite


end # Facts
end # TidBits
