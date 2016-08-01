require 'test/unit'
require 'test/unit/ui/console/testrunner'


# Turn off test unit's auto runner for those using the gem
#
defined?( Test::Unit::AutoRunner ) and Test::Unit::AutoRunner.need_auto_run = false

require_relative 'TestRepoCase'

Dir.entries( File.dirname( __FILE__ ) ).sort.

	grep( /test.*\.rb/ ) { | file | require_relative file }



module TidBits
module Git


class TestSuite


def self.suite

	Config.new :testing, 'test.yml'.relpath

	suite =  Test::Unit::TestSuite.new( "Git Unit Tests" )

	suite << TestRepo     .suite
	suite << TestFactRepo .suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self )

end


end # TestSuite


end # Git
end # TidBits
