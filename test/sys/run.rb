require 'test/unit/ui/console/testrunner'
require_relative '../../core_extend/lib/core_extend'
require 'pp'


# Turn off test unit's auto runner for those using the gem
#
defined?( Test::Unit::AutoRunner ) and Test::Unit::AutoRunner.need_auto_run = false


Dir[ File.join( File.dirname( __FILE__ ), '*.rb' ) ].each do | file |

	require_relative file

end



module Susu
module Sys
class  TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Susu::Sys Unit Tests" )

	# suite << TestThorfile.suite
	suite << TestSys.suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self )

end


end # TestSuite
end # Sys
end # Susu

