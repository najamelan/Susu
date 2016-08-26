require_relative 'TestHelper'

Susu.refine binding

module Susu
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


def test07Sanitizer

	h = Settings[{ default: 2}]

	h._sanitizer_ = lambda { |key, value| return :defalt, value + 1 }

	assert_equal( nil, h.default )
	assert_equal( 3  , h.defalt  )


	# Test sanitizing values added after adding sanitizer
	#
	h = Settings.new

	h._sanitizer_ = lambda { |key, value| return :defalt, value + 1 }

	h[ :blo ] = 5

	assert_equal( nil, h.blo     )
	assert_equal( 6  , h.defalt  )

end


def test08Validator

	h = Settings[{ default: 'string'}]

	# shouldn't
	assert_raise { h._validator_ = lambda { |key, value| value.kind_of? Numeric or raise } }

	assert_raise { h[ :other ] = 'nnn' }

	assert_nothing_thrown { h[ :ok ] = 4 }

end




end # class  TestSettings
end # module Options
end # module Susu
