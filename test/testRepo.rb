module TidBits
module Git

class TestRepo < TestRepoCase


def test00Constructor

	r = Repo.new @@clean

	assert_instance_of  Repo	, r

end


end # class  TestRepo
end # module Git
end # module TidBits
