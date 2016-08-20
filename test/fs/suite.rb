eval Susu::ALL_REFINES, binding

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

	Test::Unit::UI::Console::TestRunner.run( self, output_level: Test::Unit::UI::Console::OutputLevel::VERBOSE )

end


end # TestSuite


end # Fs
end # Susu
