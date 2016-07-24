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



def test01Exist

	f = Path.new path: @@tmpdir

	assert_equal( Status::PASSA, f.analyze )
	assert      ( f.passedAnalyze? )

	assert_equal( Status::PASSA | Status::PASSC, f.check   )
	assert      ( f.passedCheck? )

	g = Path.new( path: @@tmpdir + 'doesntexist' )

	assert_equal( Status::PASSA, g.analyze )
	assert      ( g.passedAnalyze? )

	assert_equal( Status::PASSA | Status::FAILC, g.check   )
	assert      ( ! g.passedCheck? )

end



end # class  TestFactPath
end # module Facts
end # module TidBits
