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

	assert_instance_of( Path             , f              )
	assert_equal(       @@tmpdir         , f.options.path )
	assert_equal(       @@tmpdir         , f.params .path )
	assert_equal(       [ :fresh ].to_set, f.status       )

end



def test01Exist

	f = Path.new path: @@tmpdir

	assert_equal( [ :passA ].to_set, f.analyze )
	assert      ( f.analyzePassed?  )

	assert_equal( [ :passA, :passC ].to_set, f.check )
	assert      ( f.analyzePassed? )
	assert      ( f.checkPassed?   )


	# Test create file
	#
	path = @@tmpdir + 'doesntexist'

	assert( ! path.exist? )
	g = Path.new( path: path )

	assert_equal( [ :passA ].to_set, g.analyze )
	assert      ( g.analyzePassed? )

	assert_equal( [ :passA, :failC ].to_set, g.check )
	assert      ( g.analyzePassed? )
	assert      ( ! g.checkPassed? )

	assert_equal( [ :passA, :passC, :passF ].to_set, g.fix )
	assert      ( g.analyzePassed? )
	assert      ( g.checkPassed?   )
	assert      ( g.fixPassed?     )
	assert      ( path.exist?      )
	assert      ( path.file?       )


	# Test remove file
	#
	assert( path.exist? )
	h = Path.new( path: path, exist: false )

	assert_equal( [ :passA ].to_set, h.analyze )
	assert      ( h.analyzePassed? )

	assert_equal( [ :passA, :failC ].to_set, h.check )
	assert      ( h.analyzePassed? )
	assert      ( ! h.checkPassed? )

	assert_equal( [ :passA, :passC, :passF ].to_set, h.fix )
	assert      ( h.analyzePassed? )
	assert      ( h.checkPassed?   )
	assert      ( h.fixPassed?     )
	assert      ( ! path.exist?    )


	# Test create directory
	#
	path = @@tmpdir + 'doesntexist'

	assert( ! path.exist? )
	g = Path.new( path: path, createType: :directory )

	assert_equal( [ :passA ].to_set, g.analyze )
	assert      ( g.analyzePassed? )

	assert_equal( [ :passA, :failC ].to_set, g.check )
	assert      ( g.analyzePassed? )
	assert      ( ! g.checkPassed? )

	assert_equal( [ :passA, :passC, :passF ].to_set, g.fix )
	assert      ( g.analyzePassed? )
	assert      ( g.checkPassed?   )
	assert      ( g.fixPassed?     )
	assert      ( path.exist?      )
	assert      ( path.directory?  )

end



end # class  TestFactPath
end # module Facts
end # module TidBits
