Susu.refine binding

module Susu
module Git

Branch
Repo


class TestRepo < TestRepoCase


def test00Constructor

	r = Repo.new @@repo

	assert_instance_of    Repo  , r
	assert_equal          @@repo, r.path

	assert                r.valid?
	assert                r.clean?
	assert              ! r.bare?

end



def test01clean

	r = Repo.new @@repo

		assert r.clean?


	r.pollute

		assert  ! r.clean?


	r.addAll
	r.commit 'Commit pollution'

		assert  r.clean?


	r.addSubmodule Repo.new( addRepo )

		assert  ! r.clean?

end



def test02valid

	r = Repo.new @@repo

		assert r.valid?


	r.path[ '.git' ].rm_secure

		assert ! r.valid?


	r.path.rm_secure

		assert ! r.valid?

end



def test03AddAll

	r = Repo.new @@repo

		assert r.clean?


	r.pollute
	r.addAll
	r.commit 'clean working dir'

		assert  r.clean?

end



def test04Branches

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



def test05AddSubmodule

	r   = Repo.new @@repo
	sub = Repo.new addRepo

		assert_equal 0, r.submodules.count


	r.addSubmodule sub

		assert_equal 1, r.submodules.count
		assert       r.path[ '.gitmodules' ].exist?

end


end # class  TestRepo
end # module Git
end # module Susu
