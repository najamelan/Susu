Susu.refine binding

module Susu
module Git

Repo

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

	r.pollute

	assert  ! r.clean?

end


def test02AddAll

	r = Repo.new @@repo

	assert r.clean?

	r.pollute
	r.addAll
	r.commit 'clean working dir'

	assert  r.clean?

end


end # class  TestRepo
end # module Git
end # module Susu
