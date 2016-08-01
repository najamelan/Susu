module TidBits
module Git

class TestFactRepo < TestRepoCase


def test01Exist

	f = Facts::Repo.new( path: @@repo )

	assert         @@repo[ '.git' ].exist?
	assert_analyze f
	assert_check   f

	g = Facts::Repo.new( path: @@repo, exist: false )

	assert_check_fail g
	assert_fix        g

	assert            ! @@repo[ '.git' ].exist?

	# h = Facts::Repo.new( path: @@repo )
	f.reset

	assert_check_fail f
	assert_fix f
	assert     @@repo[ '.git' ].exist?

end


end # class  TestFactRepo
end # module Git
end # module TidBits
