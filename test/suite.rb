require 'test/unit'
require 'test/unit/ui/console/testrunner'

require 'simplecov'
require 'codecov'

SimpleCov.start
SimpleCov.formatter = SimpleCov::Formatter::Codecov

using Susu.refines


# Turn off test unit's auto runner
#
Test::Unit::AutoRunner.need_auto_run = false

Susu.configure profile: :testing, runtime: [ 'facts/test.yml'.relpath, 'git/test.yml'.relpath, 'defaults.yml'.relpath ]


__dir__.path.children.sort.pgrep( /suite\.rb/ ) { |file| require file }


module Susu


class TestSuite

include Options::Configurable


def self.configure( config ); config.setup( self, *name.split( '::' ) ) end
configure Susu.config


def self.suite

	suite =  Test::Unit::TestSuite.new( "Susu TestSuite" )

	suite << Susu::Facts::TestSuite       .suite
	suite << Susu::DataStruct::TestSuite  .suite
	suite << Susu::Refine::TestSuite      .suite
	suite << Susu::Fs::TestSuite          .suite
	suite << Susu::Options::TestSuite     .suite
	suite << Susu::Git::TestSuite         .suite
	# suite << Susu::Sys::TestSuite         .suite


end



def self.run

	Test::Unit::UI::Console::TestRunner.run( self, output_level: Test::Unit::UI::Console::OutputLevel::const_get( options.outputLevel ) )

end


end # TestSuite


end # Susu
