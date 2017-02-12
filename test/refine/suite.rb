using Susu.refines

__dir__.path.children.pgrep( /test.*\.rb/ ) { |file| require file }


module Susu
module Refine


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Refine TestSuite" )

	suite << TestArray   .suite
	suite << TestDate    .suite
	suite << TestHash    .suite
	suite << TestModule  .suite
	suite << TestNumeric .suite
	suite << TestString  .suite
	suite << TestTime    .suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run self

end


end # TestSuite


end # Refine
end # Susu
