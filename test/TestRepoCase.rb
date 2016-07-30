require 'etc'

module TidBits
module Git

class TestRepoCase < Test::Unit::TestCase


def self.startup

	@@tmp  = Dir.mktmpdir( self.class.lastname ).path

end


def self.shutdown

	@@tmp.rm_secure

end


def setup

	@@tmpdir  = @@tmp.path.mkdir method_name
	@@clean   = 'data/fixtures/clean'.relpath.copy @@tmpdir
	@@clean[ '.gitted' ].rename '.git'

end


def teardown

	@@tmpdir.rm_secure

end


end # class  TestRepoCase
end # module Git
end # module TidBits
