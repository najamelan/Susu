eval Susu::ALL_REFINES, binding

module Susu
module Facts

# Load classes
#
StateMachine


class DummyFact < Fact

include InstanceCount, Options::Configurable


def self.configure( config )

	config.setup( self, Module.nesting[ 1 ].lastname.to_sym, self.lastname.to_sym, sanitizer: self.method( :sanitize ) )

end



def initialize( path:, **opts )

	path = path.path

	super( path: path )

	dependOn( Fs::Facts::Path, path: path.parent, **opts )

end


# Conditions
#
class Dummy; end

end # class DummyFact

DummyFact.configure Susu.config




class MockFact < Fact

include InstanceCount, Susu::Options::Configurable


def self.configure( config )

	config.setup( self, Module.nesting[ 1 ].lastname.to_sym, self.lastname.to_sym, sanitizer: self.method( :sanitize ) )

end



def initialize( path:, **opts )

	path = path.path

	super( path: path )

	dependOn( DummyFact      , path: path       , **opts )
	dependOn( Fs::Facts::Path, path: path.parent, **opts )

end


# Conditions
#
class Mock; end

end # class MockFact

MockFact.configure Susu.config


class TestFact < TestFactCase

# include Susu::Options::Configurable



def setup

	super

	@@count      = Fact            .count
	@@pathCount  = Fs::Facts::Path .count
	@@mockCount  = MockFact        .count
	@@dummyCount = DummyFact       .count

end


def teardown

	super

	# @@tmp and @@tmp.exist? and @@tmp.rm_secure

end


def test_00FactCounter

	assert_equal( 0, Fact            .count - @@count     )
	assert_equal( 0, Fs::Facts::Path .count - @@pathCount )

	Fs::Facts::Path.new( path: '/tmp' )

	assert_equal( 1, Fact            .count - @@count     )
	assert_equal( 1, Fs::Facts::Path .count - @@pathCount )

end



# Make sure we don't create unnecessary dependencies.
#
def test_01NoDoubleDepends

	one   = Fs::Facts::Path.new( path: '/tmp', type: :directory )
	assert_equal( 1, Fact            .count - @@count     )
	assert_equal( 1, Fs::Facts::Path .count - @@pathCount )

	two   = Fs::Facts::Path.new( path: '/tmp', type: :directory, dependOn: one )
	assert_equal( 1  , two.depends.count    )
	assert( one.equal? two.depends.first    )
	assert_equal( 2  , Fact            .count - @@count     )
	assert_equal( 2  , Fs::Facts::Path .count - @@pathCount )

	three = Fs::Facts::Path.new( path: '/tmp', type: :directory, dependOn: two )
	assert_equal( 1, three.depends.count  )
	assert_equal( 3, Fact            .count - @@count     )
	assert_equal( 3, Fs::Facts::Path .count - @@pathCount )

	four = Fs::Facts::Path.new( path: '/tmp', type: :directory )
	assert_equal( 0, four.depends.count   )
	assert_equal( 4, Fact            .count - @@count     )
	assert_equal( 4, Fs::Facts::Path .count - @@pathCount )

end



# Make sure we don't create unnecessary dependencies.
#
def test_02dependOn

	f = MockFact.new( path: '/tmp' )
	assert_equal( 3, Fact            .count - @@count      )
	assert_equal( 1, MockFact        .count - @@mockCount  )
	assert_equal( 1, DummyFact       .count - @@dummyCount )
	assert_equal( 1, Fs::Facts::Path .count - @@pathCount  )
	assert_equal( [ DummyFact, Fs::Facts::Path ], f.depends.map { |dep| dep.class } )

	assert_analyze f
	assert_check   f

	path = @@tmpdir + 'doesnotexist/o'
	f = MockFact.new( path: path, exist: true, type: :directory )
	assert_equal( 6, Fact            .count - @@count      )
	assert_equal( 2, MockFact        .count - @@mockCount  )
	assert_equal( 2, DummyFact       .count - @@dummyCount )
	assert_equal( 2, Fs::Facts::Path .count - @@pathCount  )
	assert_equal( 2, f.depends.count                 )

	assert_analyze_fail f
	assert_fix          f

	assert path.parent.directory?

end


end # class  TestFact
end # module Facts
end # module Susu
