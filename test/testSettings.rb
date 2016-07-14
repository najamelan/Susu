require_relative 'TestHelper'

module TidBits
module Options

class TestSettings < Test::Unit::TestCase

def self.startup


end


def setup


end


def test00LoadString

	assert_nothing_raised do

		@@settings = Settings.load 'data/default.yml'.relpath.to_s

	end

end


def test01LoadPathname

	assert_nothing_raised do

		@@settings = Settings.load 'data/default.yml'.relpath

	end

end


def test02MethodAccess

	assert_equal( ['A', 'B', 'C'], @@settings.defaults.level1.list )

end


def test03MethodAccessOnNew

	@@settings.defaults.other = { a: { b: { c: 5 } } }

	assert_equal( 5, @@settings.defaults.other.a.b.c )

end




end # class  TestSettings
end # module Options
end # module TidBits
