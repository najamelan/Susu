Susu.refine binding

module Susu
module Git

class TestBranch < TestRepoCase

# include Susu::Options::Configurable



def test_01Initialize


	r = Git::Repo.new @@repo

	assert r.branches.count > 0

	r.branches.each do |name, branch|

		assert_equal( name, branch.name      )
		assert_equal( nil , branch.upstream  )
		assert_equal( nil , branch.diverged  )
		assert_equal( nil , branch.ahead     )
		assert_equal( nil , branch.behind    )
		assert_equal( nil , branch.diverged? )
		assert_equal( nil , branch.ahead?    )
		assert_equal( nil , branch.behind?   )

	end


end


def test_02Remote

	localName, remoteName, url, out = addRemote @@repo

	branch = 'master'
	track  = "#{localName}/#{branch}"
	r      = Git::Repo.new @@repo

	b = r.branches[ branch ]

	assert_equal( branch, b.name             , out.ai )
	assert_equal( track , b.upstreamName     , out.ai )
	assert_equal( track , b.upstream.name    , out.ai )
	assert_equal( [0,0] , b.diverged         , out.ai )
	assert_equal( 0     , b.ahead            , out.ai )
	assert_equal( 0     , b.behind           , out.ai )
	assert_equal( false , b.diverged?        , out.ai )
	assert_equal( false , b.ahead?           , out.ai )
	assert_equal( false , b.behind?          , out.ai )

ensure

	rmRemote remoteName

end


# def test_03Ahead

# 	@@help.repo( 'test_03Ahead' ) do |path, repoName, out|

# 		remote, url, rOut = @@help.addRemote path

# 		file, cOut = @@help.commitOne path

# 		branch = 'master'
# 		track  = "#{remote}/#{branch}"

# 		r = Gitomate::Git::Repo.new path

# 		b = r.branches[ branch ]

# 		out += rOut + cOut

# 		assert_equal( branch, b.name             , out )
# 		assert_equal( track , b.upstreamName     , out )
# 		assert_equal( track , b.upstream.name    , out )
# 		assert_equal( [1,0] , b.diverged         , out )
# 		assert_equal( 1     , b.ahead            , out )
# 		assert_equal( 0     , b.behind           , out )
# 		assert_equal( false , b.diverged?        , out )
# 		assert_equal( true  , b.ahead?           , out )
# 		assert_equal( false , b.behind?          , out )

# 	end

# end


# def test_04Behind

# 	@@help.repo( 'test_04Behind' ) do |path, repoName, out|

# 		remoteName, url, rOut = @@help.addRemote path

# 		path2, clOut = @@help.clone url

# 		file, cOut = @@help.commitOne path2

# 		pOut = @@help.push path2

# 		branch = 'master'
# 		track  = "#{remoteName}/#{branch}"

# 		r = Gitomate::Git::Repo.new path

# 		b = r.branches[ branch ]

# 		out += rOut + clOut + cOut + pOut

# 		assert_equal( branch, b.name             , out )
# 		assert_equal( track , b.upstreamName     , out )
# 		assert_equal( track , b.upstream.name    , out )
# 		assert_equal( [0,1] , b.diverged         , out )
# 		assert_equal( 0     , b.ahead            , out )
# 		assert_equal( 1     , b.behind           , out )
# 		assert_equal( false , b.diverged?        , out )
# 		assert_equal( false , b.ahead?           , out )
# 		assert_equal( true  , b.behind?          , out )

# 	end

# end


# def test_05Diverged

# 	@@help.repo( 'test_05Diverged' ) do |path, repoName, out|

# 		remoteName, url, rOut = @@help.addRemote path

# 		path2, clOut = @@help.clone url

# 		file, cOut  = @@help.commitOne path2
# 		file, cOut2 = @@help.commitOne path

# 		pOut = @@help.push path2

# 		branch = 'master'
# 		track  = "#{remoteName}/#{branch}"

# 		r = Gitomate::Git::Repo.new path

# 		b = r.branches[ branch ]

# 		out += rOut + clOut + cOut + cOut2 + pOut

# 		assert_equal( branch, b.name             , out )
# 		assert_equal( track , b.upstreamName     , out )
# 		assert_equal( track , b.upstream.name    , out )
# 		assert_equal( [1,1] , b.diverged         , out )
# 		assert_equal( 1     , b.ahead            , out )
# 		assert_equal( 1     , b.behind           , out )
# 		assert_equal( true  , b.diverged?        , out )
# 		assert_equal( true  , b.ahead?           , out )
# 		assert_equal( true  , b.behind?          , out )

# 	end

# end

end # class TestBranch
end # module Git
end # module Gitomate
