require 'etc'

module TidBits
module Facts

class TestFactPath < Test::Unit::TestCase


def self.startup

	@@tmp  = Dir.mktmpdir 'TestFactPath'

end


def self.shutdown

	FileUtils.remove_entry_secure @@tmp

end


def setup

	@@tmpdir  = @@tmp.path.mkdir method_name

end


def teardown

	FileUtils.remove_entry_secure @@tmpdir

end



def test00Constructor

	f = Path.new path: @@tmpdir

	assert_instance_of( Path         , f              )
	assert_equal(       @@tmpdir     , f.options.path )
	assert_equal(       @@tmpdir     , f.params .path )
	assert_equal(       Status::FRESH, f.status       )

end



end # class  TestFactPath
end # module Facts
end # module TidBits
