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

end



end # class  TestFactPath
end # module Facts
end # module TidBits
