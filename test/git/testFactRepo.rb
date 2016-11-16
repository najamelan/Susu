Susu.refine binding

module Susu
module Git

class TestFactRepo < TestRepoCase



def test00DependOnPath

	path = @@tmpdir/'doesnotexist/haha'

	f = Facts::Repo.new( path: path, bare: false )

	assert !path.exist?

	assert_analyze_fail f

	assert_fix          f
	assert              path          .directory?
	assert              path[ '.git' ].directory?

end



def test01Exist

	assert @@repo[ '.git' ].exist?

	f = Facts::Repo.new( path: @@repo )

	assert_analyze f
	assert_check   f


	# Remove the repo
	#
	g = Facts::Repo.new( path: @@repo, exist: false )

	assert_check_fail g
	assert_fix        g

	assert            ! @@repo[ '.git' ].exist?


	# Recreate it
	#
	f.reset

	assert_check_fail f

	h = Facts::Repo.new( path: @@repo, bare: false )

	assert_fix   h
	assert       @@repo[ '.git' ].exist?
	assert       @@repo[ '.git' ].directory?
	assert     ! h.repo.bare?

	# Test create bare
	#
	h = Facts::Repo.new( path: @@repo, exist: false )
	assert   h.fix
	assert ! @@repo[ '.git' ].exist?

	h = Facts::Repo.new( path: @@repo, bare: true )
	assert h.fix
	assert h.repo.bare?

	# Create in non empty directory
	#
	path = @@tmpdir.mkpath 'doesnotexist/haha'
	path.touch '.git'

	g = Facts::Repo.new( path: path, bare: false )

	assert_analyze_fail g
	assert_fix          g

	assert              path[ '.git' ].exist?
	assert              path[ '.git' ].directory?
	assert              Repo.new( path ).valid?


	# Create in non empty directory, shoouldn't if force is not set
	#
	path = @@tmpdir.mkpath 'doesnotexist/hoho'
	path.touch '.git'

	g = Facts::Repo.new( path: path, bare: false, force: false )

	assert_analyze_fail g

	assert_raise Rugged::FilesystemError do

		g.fix

	end

	assert              path[ '.git' ].exist?
	assert            ! Repo.new( path ).valid?

end


def test02Bare

	f = Facts::Repo.new( path: @@repo, bare: false )

	assert_analyze f
	assert_check   f

	# Change to bare
	#
	f.reset
	g = Facts::Repo.new( path: @@repo, bare: true )

	assert_check_fail g
	assert_fix        g
	assert_check      g
	assert_check_fail f
	assert            g.repo.bare?


	# Change back to non bare
	#
	assert_fix   f
	assert     ! f.repo.bare?

end


def test03Update

	f = Facts::Repo.new( path: @@repo, update: true )

	assert_analyze f
	assert_check   f


	f = Facts::Repo.new( path: @@repo, update: true )

	f.repo.pollute
	assert ! f.repo.clean?

	assert_analyze    f
	assert_check_fail f
	assert_fix        f
	assert_check      f

end


def test04Head

	r = Repo.new @@repo
	f = Facts::Repo.new( path: @@repo, head: 'master' )

		assert_equal   'master', r.head
		assert_analyze f
		assert_check   f
		assert_fix     f
		assert_equal   'master', r.head


	f = Facts::Repo.new( path: @@repo, head: 'dev' )

		assert_equal      'master', r.head
		assert_analyze    f
		assert_check_fail f
		assert_fix        f
		assert_check      f
		assert_equal      'dev', r.head


	# TODO: This throws an exception, because the reference does not exist. We probably should depend on branches condition
	# in order to make sure that branches that should be created will be so.
	#
	# f = Facts::Repo.new( path: @@repo, head: 'doesnotexist' )

	# 	assert_equal      'dev', r.head
	# 	assert_analyze    f
	# 	assert_check_fail f
	# 	assert_fix        f
	# 	assert_check      f
	# 	assert_equal      'doesnotexist', r.head

end


end # class  TestFactRepo
end # module Git
end # module Susu

