Susu.refine binding

__dir__.path.children.pgrep( /test.*\.rb/ ) { |file| require file }


module Susu
module Refine


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Refine TestSuite" )

	suite << TestArray   .suite
	suite << TestHash    .suite
	suite << TestModule  .suite
	suite << TestNumeric .suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self, output_level: Test::Unit::UI::Console::OutputLevel::VERBOSE )

end


end # TestSuite


end # Refine
end # Susu
