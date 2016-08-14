eval Susu::ALL_REFINES, binding

module Susu
module Fs

class TestRefine < Test::Unit::TestCase


def test_00Path

	assert( '.'.path.exist?     )
	assert( '.'.path.directory? )

	assert_equal( __FILE__, __FILE__.path.to_path )

end


def test_00RelPath

	p = '.'.relpath
	file = File.basename __FILE__

	assert( p.exist?     )
	assert( p.directory? )

	# From string to rpath and back
	#
	assert_equal( File.join( __dir__, file ), p.join( file ).to_s )

end


def test_02To_path

	assert_equal( __FILE__, __FILE__.to_path )

end


end # class  TestString
end # module CoreExtend
end # module Susu