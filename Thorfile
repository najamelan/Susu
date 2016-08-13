require          'thor'

require          'awesome_print'
require          'byebug'
require          'pry'

require_relative 'lib/tidbits'


class Tidbits < Thor


desc 'test', 'Run the unit tests for the TidBits library'

def test

	require_relative 'test/run'

	TidBits::TestSuite.run

end


end # class Options
