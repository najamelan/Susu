require 'test/unit'
require 'test/unit/ui/console/testrunner'


# Turn off test unit's auto runner for those using the gem
#
defined?( Test::Unit::AutoRunner ) and Test::Unit::AutoRunner.need_auto_run = false

require_relative 'TestRepoCase'

Dir.entries( File.dirname( __FILE__ ) ).sort.

	grep( /test.*\.rb/ ) { | file | require_relative file }



module Susu
module Git


class TestSuite


def self.suite

	Config.new :testing, 'test.yml'.relpath

	suite =  Test::Unit::TestSuite.new( "Git TestSuite" )

	suite << TestRepo     .suite
	suite << TestFactRepo .suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self, output_level: Test::Unit::UI::Console::OutputLevel::VERBOSE )

end


end # TestSuite


end # Git
end # Susu
