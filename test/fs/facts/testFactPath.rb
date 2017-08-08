require 'etc'

using Susu.refines

module Susu
module Fs

class TestFactPath < Susu::Facts::TestFactCase


def test00Constructor

	f = Facts::Path.new path: @@tmpdir

	assert_instance_of  Facts::Path     , f
	assert_option       @@tmpdir , f, :path
	assert_param        @@tmpdir , f, :path
	assert_state        :fresh   , f

end



def test01Exist

	f = Facts::Path.new path: @@tmpdir

	assert_analyze f
	assert_check   f
	assert_fix     f

	assert ! f.fixed?
	assert   @@tmpdir.directory?

	# Test create file
	#
	path = @@tmpdir + 'doesntexist'

	assert ! path.exist?
	f = Facts::Path.new( path: path, type: :file )

	assert_analyze_fail f
	assert_fix          f
	assert              f.fixed?

	assert  path.file?


	# Test remove file
	#
	assert( path.file? )
	f = Facts::Path.new( path: path, exist: false )

	assert_analyze    f
	assert_check_fail f
	assert_fix        f

	assert            f.fixed?
	assert            ! path.exist?


	# Test create directory
	#
	assert( ! path.exist? )
	f = Facts::Path.new( path: path, type: :directory )

	assert_analyze_fail f
	assert_fix          f

	assert              f.fixed?
	assert              path.directory?


	# Test create file call fix without calling analyze and check
	#
	path.rm_secure
	assert ! path.exist?

	f = Facts::Path.new( path: path, type: :file )

	assert_fix  f
	assert      f.fixed?

	assert      path.file?

end



def test02Type

	f = Facts::Path.new path: @@tmpdir, type: :directory

	assert_analyze   f
	assert_check     f
	assert_fix       f

	assert         ! f.fixed?
	assert           @@tmpdir.directory?

	# Test create directory
	#
	path = @@tmpdir + 'doesntexist'

	assert ! path.exist?

	f = Facts::Path.new( path: path, type: :directory )
	f.fix

	assert  path.directory?


	# Turn it into a file
	#
	f = Facts::Path.new( path: path, type: :file )

	assert_analyze    f
	assert_check_fail f
	assert_fix        f

	assert            f.fixed?
	assert            path.file?


	# Turn it back to directory without calling analyze and check
	#
	assert path.file?

	f = Facts::Path.new( path: path, type: :directory )

	assert_fix  f
	assert      f.fixed?

	assert      path.directory?


	# Turn it back to file should fail if :force is false
	#
	assert path.directory?

	f = Facts::Path.new( path: path, type: :file, force: false )

	assert_fix_fail f
	assert          path.directory?

end



def test03Own

	puid = Process.euid
	pgid = Process.egid

	ouid = Etc.getpwnam( 'nobody' ).uid
	ogid = Etc.getpwnam( 'nobody' ).gid

	# Test an existing file
	#
	path = @@tmpdir
	f = Facts::Path.new( path: path, own: { uid: puid , gid: pgid } )
	assert_check      f


	omit_if( puid != 0, 'Cannot test changing ownership unless run as root' )

	g = Facts::Path.new( path: path, own: { uid: ouid, gid: ogid } )
	assert_check_fail g


	# Create file with different owner
	#
	path = @@tmpdir + 'own'
	f = Facts::Path.new( path: path, type: :file, own: { uid: ouid, gid: ogid } )

	assert_fix f

	stat = path.stat

	assert path.file?
	assert_equal stat.uid, ouid
	assert_equal stat.gid, ogid


	# Change owner on existing file
	#
	path = @@tmpdir + 'fix'
	f = Facts::Path.new( path: path, type: :file )

	assert_fix f

	assert       path.file?
	assert_equal path.stat.uid, puid
	assert_equal path.stat.gid, pgid

	f = Facts::Path.new( path: path, own: { uid: ouid, gid: ogid } )

	assert_fix f
	assert     path.file?

	stat = path.stat

	assert_equal ouid, stat.uid
	assert_equal ogid, stat.gid

end



def test04Mode

	# Test an existing file
	#
	path = @@tmpdir
	f = Facts::Path.new( path: path, mode: path.stat.mode )
	g = Facts::Path.new( path: path, mode: 040600         )

	assert_check      f
	assert_check_fail g


	# Create file with specific mode
	#
	path = @@tmpdir + 'mode'
	f = Facts::Path.new( path: path, type: :file, mode: 0100640 )

	assert_fix   f
	assert       path.file?
	assert_equal 0100640, path.stat.mode


	# Change owner on existing directory
	#
	path = @@tmpdir + 'fixd'
	f = Facts::Path.new( path: path, type: :directory )

	assert_fix f

	assert       path.directory?
	assert_equal 040755, path.stat.mode

	f = Facts::Path.new( path: path, mode: 040600 )

	assert_fix   f
	assert       path.directory?
	assert_equal 040600, path.stat.mode


	# Change owner on existing file
	#
	path = @@tmpdir + 'fix'
	f = Facts::Path.new( path: path, type: :file )

	assert_fix f

	assert       path.file?
	assert_equal path.stat.mode, 0100644

	f = Facts::Path.new( path: path, mode: 0100600 )

	assert_fix   f
	assert       path.file?
	assert_equal 0100600, path.stat.mode

end


end # class  TestFactPath
end # module Fs
end # module Susu
