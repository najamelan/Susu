using Susu.refines

require_relative '../facts/suite.rb'
__dir__.path.children.pgrep( /test.*\.rb/ ) { |file| require file }



module Susu
module Fs

class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Fs TestSuite" )

	suite << TestRefine   .suite
	suite << TestPath     .suite
	suite << TestFactPath .suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run self

end


end # TestSuite


end # Fs
end # Susu
