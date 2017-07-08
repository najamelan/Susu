using Susu.refines




module Susu

# Autoload before reopen
#
DataStruct

module DataStruct

__dir__.path.children.pgrep( /test.*\.rb/ ) { |file| require file }

class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "DataStruct TestSuite" )

	suite << TestGrid .suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run self

end


end # TestSuite


end # DataStruct
end # Susu
