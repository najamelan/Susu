module TidBits
module Facts


class DummyFact < Fact

include InstanceCount, TidBits::Options::Configurable

def initialize( path:, **opts )

	path = path.path

	super( path: path )

	dependOn( Path, path: path.parent, **opts )

end


# Conditions
#
class Dummy; end

end # class DummyFact


class MockFact < Fact

include InstanceCount, TidBits::Options::Configurable

def initialize( path:, **opts )

	path = path.path

	super( path: path )

	dependOn( DummyFact, path: path       , **opts )
	dependOn( Path     , path: path.parent, **opts )

end


# Conditions
#
class Mock; end

end # class MockFact


class TestFact < TestFactCase

# include TidBits::Options::Configurable



def setup

	super

	@@count      = Fact      .count
	@@pathCount  = Path      .count
	@@mockCount  = MockFact  .count
	@@dummyCount = DummyFact .count

end


def teardown

	super

	# @@tmp and @@tmp.exist? and @@tmp.rm_secure

end


def test_00FactCounter

	assert_equal( 0, Fact.count - @@count     )
	assert_equal( 0, Path.count - @@pathCount )

	Path.new( path: '/tmp' )

	assert_equal( 1, Fact.count - @@count     )
	assert_equal( 1, Path.count - @@pathCount )

end



# Make sure we don't create unnecessary dependencies.
#
def test_01NoDoubleDepends

	one   = Path.new( path: '/tmp', type: :directory )
	assert_equal( 1, Fact.count - @@count     )
	assert_equal( 1, Path.count - @@pathCount )

	two   = Path.new( path: '/tmp', type: :directory, dependOn: one )
	assert_equal( 1  , two.depends.count    )
	assert( one.equal? two.depends.first    )
	assert_equal( 2  , Fact.count - @@count     )
	assert_equal( 2  , Path.count - @@pathCount )

	three = Path.new( path: '/tmp', type: :directory, dependOn: two )
	assert_equal( 1, three.depends.count  )
	assert_equal( 3, Fact.count - @@count     )
	assert_equal( 3, Path.count - @@pathCount )

	four = Path.new( path: '/tmp', type: :directory )
	assert_equal( 0, four.depends.count   )
	assert_equal( 4, Fact.count - @@count     )
	assert_equal( 4, Path.count - @@pathCount )

end



# Make sure we don't create unnecessary dependencies.
#
def test_02dependOn

	f = MockFact.new( path: '/tmp' )
	assert_equal( 3, Fact      .count - @@count      )
	assert_equal( 1, MockFact  .count - @@mockCount  )
	assert_equal( 1, DummyFact .count - @@dummyCount )
	assert_equal( 1, Path      .count - @@pathCount  )
	assert_equal( [ DummyFact, Path ], f.depends.map { |dep| dep.class } )

	assert_analyze f
	assert_check   f

	path = @@tmpdir + 'doesnotexist/o'
	f = MockFact.new( path: path, exist: true, type: :directory )
	assert_equal( 6, Fact      .count - @@count      )
	assert_equal( 2, MockFact  .count - @@mockCount  )
	assert_equal( 2, DummyFact .count - @@dummyCount )
	assert_equal( 2, Path      .count - @@pathCount  )
	assert_equal( 2, f.depends.count                 )

	assert_analyze_fail f
	assert_fix          f

	assert path.parent.directory?

end


end # class  TestFact
end # module Facts
end # module TidBits
