

Dir[ File.join( File.dirname( __FILE__ ), '*.rb' ) ].each do | file |

	require_relative file

end



module Susu
module Sys
class  TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Sys TestSuite" )

	# suite << TestThorfile.suite
	suite << TestSys.suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self )

end


end # TestSuite
end # Sys
end # Susu

