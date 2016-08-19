require 'test/unit'
require 'test/unit/ui/console/testrunner'

eval Susu::ALL_REFINES, binding

# Turn off test unit's auto runner
#
Test::Unit::AutoRunner.need_auto_run = false

Susu.configure profile: :testing, runtime: [ 'facts/test.yml'.relpath, 'git/test.yml'.relpath ]

'.'.relpath.children( recursive: true ).map( &:to_path ).grep( /suite\.rb/ ) do |file|

	require_relative file

end


module Susu


class TestSuite


def self.suite

	suite =  Test::Unit::TestSuite.new( "Susu TestSuite" )

	suite << Susu::Refine::TestSuite  .suite
	suite << Susu::Fs::TestSuite      .suite
	suite << Susu::Options::TestSuite .suite
	suite << Susu::Facts::TestSuite   .suite
	suite << Susu::Git::TestSuite     .suite
	# suite << Susu::Sys::TestSuite       .suite


end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self, output_level: Test::Unit::UI::Console::OutputLevel::VERBOSE )

end


end # TestSuite


end # Susu
