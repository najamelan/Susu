using Susu.refines

module Susu
module Git


class TestRepo < TestRepoCase


def self.startup

	super

end



def test00Constructor

	r = Repo.new @@repo

	assert_instance_of    Repo  , r
	assert_equal          @@repo, r.path

	assert                r.valid?
	assert                r.clean?
	assert              ! r.bare?

end



def test01clean?

	r = Repo.new @@repo

		assert r.clean?


	r.pollute

		assert  ! r.clean?


	# TODO: Rugged bugs out if we don't set this. We should catch this in the repo class.
	# 
	r.rug.config[ 'user.name'  ] = true
	r.rug.config[ 'user.email' ] = true


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


	# TODO: Rugged bugs out if we don't set this. We should catch this in the repo class.
	# 
	r.rug.config[ 'user.name'  ] = true
	r.rug.config[ 'user.email' ] = true

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

	r    = Repo.new @@repo
	sub  = Repo.new addRepo
	sub2 = Repo.new addRepo

		assert_equal 0, r.submodules.count


	r.addSubmodule sub

		assert_equal 1, r.submodules.count
		assert       r.path[ '.gitmodules'     ]          .exist?
		assert       r.path[ sub.path.basename ][ '.git' ].file?


	r.addSubmodule sub2

		assert_equal 2, r.submodules.count

end



def test06Head

	r = Repo.new @@repo

		assert_equal 'master', r.head

	r.checkout 'dev'

		assert_equal 'dev', r.head
end



def test07AddBranch

	r = Repo.new @@repo

	r.addBranch 'ola'

		assert_instance_of Branch, r.branches[ 'ola' ]
		assert_equal       3     , r.branches.count

end


end # class  TestRepo
end # module Git
end # module Susu
