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
	b      = r.branches[ branch ]

	assert_equal( branch, b.name             , out.ai )
	assert_equal( track , b.upstreamName     , out.ai )
	assert_equal( track , b.upstream.name    , out.ai )
	assert_equal( [0,0] , b.diverged         , out.ai )
	assert_equal( 0     , b.ahead            , out.ai )
	assert_equal( 0     , b.behind           , out.ai )
	assert_equal( false , b.diverged?        , out.ai )
	assert_equal( false , b.ahead?           , out.ai )
	assert_equal( false , b.behind?          , out.ai )

end



def test_03Diverged

	localName, remoteName, url, out = addRemote @@repo

	path, clOut  = clone     url, @@tmpdir.mkdir( 'clone' )

	cOut         = commitOne @@repo
	ccOut        = commitOne path
	pOut         = push      path

	out         += clOut + cOut + ccOut + pOut

	branch = 'master'
	track  = "#{localName}/#{branch}"

	r = Repo.new @@repo
	b = r.branches[ branch ]

	assert_equal( branch, b.name             , out.ai )
	assert_equal( track , b.upstreamName     , out.ai )
	assert_equal( track , b.upstream.name    , out.ai )
	assert_equal( [1,1] , b.diverged         , out.ai )
	assert_equal( 1     , b.ahead            , out.ai )
	assert_equal( 1     , b.behind           , out.ai )
	assert_equal( true  , b.diverged?        , out.ai )
	assert_equal( true  , b.ahead?           , out.ai )
	assert_equal( true  , b.behind?          , out.ai )

end



def test_04Ahead

	localName, remoteName, url, out = addRemote @@repo

	out += commitOne @@repo

	branch = 'master'
	track  = "#{localName}/#{branch}"
	r      = Repo.new @@repo
	b      = r.branches[ branch ]

	assert_equal( branch, b.name             , out.ai )
	assert_equal( track , b.upstreamName     , out.ai )
	assert_equal( track , b.upstream.name    , out.ai )
	assert_equal( [1,0] , b.diverged         , out.ai )
	assert_equal( 1     , b.ahead            , out.ai )
	assert_equal( 0     , b.behind           , out.ai )
	assert_equal( false , b.diverged?        , out.ai )
	assert_equal( true  , b.ahead?           , out.ai )
	assert_equal( false , b.behind?          , out.ai )

end



def test_05Behind

	localName, remoteName, url, out = addRemote @@repo

	path, clOut  = clone     url, @@tmpdir.mkdir( 'clone' )
	cOut         = commitOne path
	pOut         = push      path
	out         += clOut + cOut + pOut

	branch = 'master'
	track  = "#{localName}/#{branch}"

	r = Repo.new @@repo
	b = r.branches[ branch ]

	assert_equal( branch, b.name             , out.ai )
	assert_equal( track , b.upstreamName     , out.ai )
	assert_equal( track , b.upstream.name    , out.ai )
	assert_equal( [0,1] , b.diverged         , out.ai )
	assert_equal( 0     , b.ahead            , out.ai )
	assert_equal( 1     , b.behind           , out.ai )
	assert_equal( false , b.diverged?        , out.ai )
	assert_equal( false , b.ahead?           , out.ai )
	assert_equal( true  , b.behind?          , out.ai )

end



end # class TestBranch
end # module Git
end # module Susu
