Dir.entries( File.dirname( __FILE__ ) ).

	grep( /test.*\.rb/ ) { | file | require_relative file }



module Susu
module Fs

class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Fs TestSuite" )

	suite << TestRefine .suite
	suite << TestPath   .suite


end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self, output_level: Test::Unit::UI::Console::OutputLevel::VERBOSE )

end


end # TestSuite


end # Fs
end # Susu
