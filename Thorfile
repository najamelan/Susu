require          'thor'


class Susu < Thor

# package_name "susu"


desc 'test', 'Run the unit tests for the Susu library'
def test

	require_relative 'test/run'

	TidBits::Susu::TestSuite.run

end


end
