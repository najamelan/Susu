require 'etc'

module TidBits
module Facts

class TestFactPath < TestFactCase


def test00Constructor

	f = Path.new path: @@tmpdir

	assert_instance_of  Path     , f
	assert_option       @@tmpdir , f, :path
	assert_param        @@tmpdir , f, :path
	assert_state        :fresh   , f

end



def test01Exist

	f = Path.new path: @@tmpdir

	assert_analyze f
	assert_check   f
	assert_fix     f

	assert ! f.fixedAny?
	assert   @@tmpdir.directory?

	# Test create file
	#
	path = @@tmpdir + 'doesntexist'

	assert ! path.exist?
	f = Path.new( path: path )

	assert_analyze    f
	assert_check_fail f
	assert_fix        f
	assert            f.fixedAny?

	assert  path.file?


	# Test remove file
	#
	assert( path.file? )
	f = Path.new( path: path, exist: false )

	assert_analyze    f
	assert_check_fail f
	assert_fix        f

	assert            f.fixedAny?
	assert            ! path.exist?


	# Test create directory
	#
	assert( ! path.exist? )
	f = Path.new( path: path, createType: :directory )

	assert_analyze    f
	assert_check_fail f
	assert_fix        f

	assert            f.fixedAny?
	assert            path.directory?


	# Test create file call fix without calling analyze and check
	#
	path.rm_secure
	assert ! path.exist?

	f = Path.new( path: path )

	assert_fix  f
	assert      f.fixedAny?

	assert      path.file?

end



def test02Type

	f = Path.new path: @@tmpdir, type: :directory

	assert_analyze   f
	assert_check     f
	assert_fix       f

	assert         ! f.fixedAny?
	assert           @@tmpdir.directory?

	# Test create directory
	#
	path = @@tmpdir + 'doesntexist'

	assert ! path.exist?

	f = Path.new( path: path, type: :directory )
	f.fix

	assert  path.directory?


	# Turn it into a file
	#
	f = Path.new( path: path, type: :file )

	assert_analyze    f
	assert_check_fail f
	assert_fix        f

	assert            f.fixedAny?
	assert            path.file?


	# Turn it back to directory without calling analyze and check
	#
	assert path.file?

	f = Path.new( path: path, type: :directory )

	assert_fix  f
	assert      f.fixedAny?

	assert      path.directory?

end



def test03Own

	# Test an existing file
	#
	path = @@tmpdir
	f = Path.new( path: path, own: { uid: options.uid , gid: options.gid  } )
	g = Path.new( path: path, own: { uid: options.uid2, gid: options.gid2 } )

	assert_check      f
	assert_check_fail g


	# Create file with different owner
	#
	path = @@tmpdir + 'own'
	f = Path.new( path: path, type: :file, own: { uid: options.uid2, gid: options.gid2 } )

	assert_fix f

	stat = path.stat

	assert path.file?
	assert_equal stat.uid, options.uid2
	assert_equal stat.gid, options.gid2


	# Change owner on existing file
	#
	path = @@tmpdir + 'fix'
	f = Path.new( path: path )

	assert_fix f

	assert       path.file?
	assert_equal path.stat.uid, options.uid
	assert_equal path.stat.gid, options.gid

	f = Path.new( path: path, own: { uid: options.uid2, gid: options.gid2 } )

	assert_fix f
	stat = path.stat

	assert path.file?
	assert_equal stat.uid, options.uid2
	assert_equal stat.gid, options.gid2

end



end # class  TestFactPath
end # module Facts
end # module TidBits
