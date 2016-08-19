require          'thor'

require          'awesome_print'
require          'byebug'
require          'pry'

require_relative 'lib/susu'


class Susu < Thor


desc 'test', 'Run the unit tests for the Susu library'

def test

	$stdout.sync = true
	$stderr.sync = true

	require_relative 'test/run'

	::Susu::TestSuite.run

end


end # class Susu
