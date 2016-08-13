module TidBits
module Git

class TestFactRepo < TestRepoCase



def test00DependOnPath

	path = @@tmpdir/'doesnotexist/haha'

	f = Facts::Repo.new( path: path, bare: false )

	assert !path.exist?

	assert_fix f
	assert     path          .directory?
	assert     path[ '.git' ].directory?

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
	assert     ! h.repo.bare?

	# Test create bare
	#
	h = Facts::Repo.new( path: @@repo, exist: false )
	assert   h.fix
	assert ! @@repo[ '.git' ].exist?

	h = Facts::Repo.new( path: @@repo, bare: true )
	assert h.fix
	assert h.repo.bare?

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


def test03Clean

	f = Facts::Repo.new( path: @@repo, clean: true )

	assert_analyze f
	assert_check   f


	f = Facts::Repo.new( path: @@repo, clean: true )

	f.repo.pollute
	assert ! f.repo.clean?

	assert_analyze    f
	assert_check_fail f
	assert_fix        f

end


end # class  TestFactRepo
end # module Git
end # module TidBits
