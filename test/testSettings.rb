require_relative 'TestHelper'

module TidBits
module Options

class TestSettings < Test::Unit::TestCase


def test00LoadString

	assert_nothing_thrown do

		@@settings = Settings.load 'data/default.yml'.relpath.to_s

	end

end


def test01LoadPathname

	assert_nothing_thrown do

		@@settings = Settings.load 'data/default.yml'.relpath

	end

end


def test02MethodAccess

	assert_equal( ['A', 'B', 'C'], @@settings.default.level1.list )

end


def test03MethodAccessOnNew

	@@settings.default.other = { a: { b: { c: 5 } } }

	assert_equal( 5, @@settings.default.other.a.b.c )

end


def test04SymbolizeKeys

	set = { 'a' => { 'b' => { 'c' => 5 } } }.to_settings

	assert_instance_of( Symbol, set    .keys.first )
	assert_instance_of( Symbol, set.a  .keys.first )
	assert_instance_of( Symbol, set.a.b.keys.first )

	@@settings.default.other = { 'a' => { 'b' => { 'c' => 5 } } }

	assert_instance_of( Symbol, @@settings.default.other    .keys.first )
	assert_instance_of( Symbol, @@settings.default.other.a  .keys.first )
	assert_instance_of( Symbol, @@settings.default.other.a.b.keys.first )

end


def test05TestOverrideMethods

	h = Settings[{ a: 2, a?: 5 }]

	assert_equal( 5, h.a? )

end


def test06KeyDefault

	h = Settings[{ default: 2}]

	assert_equal( 2, h.default )

end




end # class  TestSettings
end # module Options
end # module TidBits
