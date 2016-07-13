require 'test/unit/testsuite'
require 'test/unit/ui/console/testrunner'


# Turn off test unit's auto runner for those using the gem
#
defined?( Test::Unit::AutoRunner ) and Test::Unit::AutoRunner.need_auto_run = false


Dir.entries( File.dirname( __FILE__ ) ).

	grep( /test.*\.rb/ ) { | file | require_relative file }



module TidBits
module CoreExtend


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "CoreExtend Unit Tests" )

	suite << TestHash.suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self )

end


end # TestSuite


end # CoreExtend
end # TidBits
