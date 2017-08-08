using Susu.refines

__dir__.path.children.pgrep( /test.*\.rb/ ) { |file| require file }



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

