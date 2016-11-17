Susu.refine binding

module Susu
module Git

class TestSubmodule < TestRepoCase

# include Susu::Options::Configurable



def test_01Initialize

	r   = Repo.new @@repo
	url = addRepo

	sub = r.addSubmodule url

		assert_equal       r                , sub.repo
		assert_equal       url.path.basename, sub.name
		assert_instance_of Rugged::Submodule, sub.rug

end



def test_02Path

	r   = Repo.new @@repo
	url = addRepo

	sub = r.addSubmodule url

		assert_instance_of Fs::Path                   , sub.path
		assert_equal       r.path[ url.path.basename ], sub.path
		assert_equal       sub.path.expand_path       , sub.path

end



def test_03Lpath

	r   = Repo.new @@repo
	url = addRepo

	sub = r.addSubmodule url

		assert_instance_of Fs::Path         , sub.lpath
		assert_equal       url.path.basename, sub.lpath.to_path

end



def test_04Url

	r   = Repo.new @@repo
	url = addRepo

	sub = r.addSubmodule url

		assert_instance_of String     , sub.url
		assert_equal       url.to_path, sub.url

end



def test_05SubRepo

	r   = Repo.new @@repo
	url = addRepo

	sub = r.addSubmodule url

		assert_instance_of Repo             , sub.subRepo
		assert_equal       sub.subRepo.path , sub.path
		assert             sub.subRepo.valid?

end





end # class TestSubmodule
end # module Git
end # module Susu
