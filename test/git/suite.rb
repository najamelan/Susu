Susu.refine binding

module Susu

Git # Autoload before reopen

module Git


require_relative 'TestRepoCase'

__dir__.path.children.pgrep( /test.*\.rb/ ) { |file| require file }


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Git TestSuite" )

	suite << TestRepo      .suite
	suite << TestBranch    .suite
	suite << TestSubmodule .suite
	suite << TestFactRepo  .suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self, output_level: Test::Unit::UI::Console::OutputLevel::VERBOSE )

end


end # TestSuite


end # Git
end # Susu
