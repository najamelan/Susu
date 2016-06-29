require 'test/unit/testsuite'
require 'test/unit/ui/console/testrunner'


Dir.entries( File.dirname( __FILE__ ) ).

	grep( /test.*\.rb/ ) { | file | require_relative file }



module TidBits
module Options


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Options Unit Tests" )

	suite << TestConfigurable.suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self )

end


end # TestSuite


end # Options
end # TidBits
