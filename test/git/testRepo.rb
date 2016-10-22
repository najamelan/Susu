Susu.refine binding

module Susu
module Git

Branch
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


def test03Branches

	r = Repo.new @@repo

	branches = r.branches

	assert_equal [ 'dev', 'master' ], branches.keys

	branches.values.each { |branch| assert_instance_of Branch, branch }


	# Make sure we don't send stale data
	#
	cmd 'git checkout -b newBranch', r.path

	branches = r.branches

	assert_equal [ 'dev', 'master', 'newBranch' ], branches.keys

	branches.values.each { |branch| assert_instance_of Branch, branch }

end


end # class  TestRepo
end # module Git
end # module Susu
