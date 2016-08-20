eval Susu::ALL_REFINES, binding

module Susu

# Autoload before reopen
#
Facts

module Facts

require_relative 'TestFactCase'

__dir__.path.children.sort.pgrep( /test.*\.rb/ ) { |file| require file }



class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Facts TestSuite" )

	suite << TestState    .suite
	suite << TestFact     .suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self, output_level: Test::Unit::UI::Console::OutputLevel::VERBOSE )

end


end # TestSuite


end # Facts
end # Susu
