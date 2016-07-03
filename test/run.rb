require 'test/unit/ui/console/testrunner'

require 'pp'

module TidBits
module Susu

def self.test

	suite = Test::Unit::TestSuite.new( "Susu Unit Tests" )
	files = Dir.entries( File.dirname( __FILE__ ) )

	files.grep( /test.*\.rb/ ) { | file | suite << file }

	Test::Unit::UI::Console::TestRunner::new( suite ).start

end

end
end
