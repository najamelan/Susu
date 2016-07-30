module TidBits
module Git

class TestRepo < TestRepoCase


def test00Constructor

	r = Repo.new @@repo

	assert_instance_of  Repo  , r
	assert_equal        @@repo, r.path

	assert                r.valid?
	assert                r.workingDirClean?
	assert              ! r.bare?

end


def test01CleanWorkingDir

	r = Repo.new @@repo

	assert r.workingDirClean?

	pollute r.path

	assert ! r.workingDirClean?

end


end # class  TestRepo
end # module Git
end # module TidBits
