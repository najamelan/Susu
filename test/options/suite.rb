Susu.refine binding

__dir__.path.children.pgrep( /test.*\.rb/ ) { |file| require file }



module Susu
module Options


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Options TestSuite" )

	suite << TestTestHelper    .suite
	suite << TestSettings      .suite
	suite << TestConfig        .suite
	suite << TestConfigProfile .suite
	suite << TestConfigurable  .suite

end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self )

end


end # TestSuite


end # Options
end # Susu
