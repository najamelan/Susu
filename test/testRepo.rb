module TidBits
module Git

class TestRepo < TestRepoCase


def test00Constructor

	r = Repo.new @@repo

	assert_instance_of  Repo  , r
	assert_equal        @@repo, r.path

	assert                r.valid?
	assert                r.clean?
	assert              ! r.bare?

end


def test01clean

	r = Repo.new @@repo

	assert r.clean?

	pollute r.path

	assert ! r.clean?

end


end # class  TestRepo
end # module Git
end # module TidBits
