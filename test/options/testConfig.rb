require_relative 'TestHelper'

using Susu.refines

module Susu
module Options

class TestConfig < Test::Unit::TestCase


def test00ClassProperties

	TestHelper.reset

	assert( ! TestHelper.configured? )

	config = Susu::Options::Config.new
	config.setup TestHelper

	assert( TestHelper.configured? )

	assert_instance_of( Settings, TestHelper.settings.default )
	assert_instance_of( Settings, TestHelper.settings.userset )
	assert_instance_of( Settings, TestHelper.settings.runtime )
	assert_instance_of( Settings, TestHelper.options          )
	assert_equal(       config  , TestHelper.settings.cfgObj  )

end



def test01Defaults

	one = { a: 1 }

	TestHelper.reset
	config = Susu::Options::Config.new( default: one )
	config.setup TestHelper

	assert_equal( one   , TestHelper.settings.default )
	assert_equal( {}    , TestHelper.settings.userset  )
	assert_equal( {}    , TestHelper.settings.runtime  )
	assert_equal( one   , TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj  )

end



def test02DefaultsArray

	one    = { a: 1, b: { c: 2, d: 3 } }
	two    = {       b: {       d: 4 } }
	expect = { a: 1, b: { c: 2, d: 4 } }

	TestHelper.reset
	config = Susu::Options::Config.new( default: [ one, two ] )
	config.setup TestHelper

	assert_equal( expect, TestHelper.settings.default  )
	assert_equal( {}    , TestHelper.settings.userset  )
	assert_equal( {}    , TestHelper.settings.runtime  )
	assert_equal( expect, TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj   )

end



def test03OverridingAll

	one    = { a: 1, b: { c: 2, d: 3 } }
	two    = {       b: {       d: 4 } }
	three  = {       b: { c: 5       } }

	TestHelper.reset
	config = Susu::Options::Config.new( default: one, userset: two, runtime: three )
	config.setup TestHelper

	TestHelper.reset
	config = Susu::Options::Config.new
	config.setup TestHelper


	assert_equal( {}    , TestHelper.settings.default  )
	assert_equal( {}    , TestHelper.settings.userset  )
	assert_equal( {}    , TestHelper.settings.runtime  )
	assert_equal( {}    , TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj   )

end



def test04Userset

	one = { a: 1 }

	TestHelper.reset
	config = Susu::Options::Config.new( userset: one )
	config.setup TestHelper

	assert_equal( {}    , TestHelper.settings.default  )
	assert_equal( one   , TestHelper.settings.userset  )
	assert_equal( {}    , TestHelper.settings.runtime  )
	assert_equal( one   , TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj   )

end



def test05UsersetArray

	one    = { a: 1, b: { c: 2, d: 3 } }
	two    = {       b: {       d: 4 } }
	expect = { a: 1, b: { c: 2, d: 4 } }

	TestHelper.reset
	config = Susu::Options::Config.new( userset: [ one, two ] )
	config.setup TestHelper

	assert_equal( {}    , TestHelper.settings.default  )
	assert_equal( expect, TestHelper.settings.userset  )
	assert_equal( {}    , TestHelper.settings.runtime  )
	assert_equal( expect, TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj   )

end



def test06Runtime

	one = { a: 1 }

	TestHelper.reset
	config = Susu::Options::Config.new( runtime: one )
	config.setup TestHelper

	assert_equal( {}    , TestHelper.settings.default  )
	assert_equal( {}    , TestHelper.settings.userset  )
	assert_equal( one   , TestHelper.settings.runtime  )
	assert_equal( one   , TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj   )

end



def test07RuntimeArray

	one    = { a: 1, b: { c: 2, d: 3 } }
	two    = {       b: {       d: 4 } }
	expect = { a: 1, b: { c: 2, d: 4 } }

	TestHelper.reset
	config = Susu::Options::Config.new( runtime: [ one, two ] )
	config.setup TestHelper

	assert_equal( {}    , TestHelper.settings.default  )
	assert_equal( {}    , TestHelper.settings.userset  )
	assert_equal( expect, TestHelper.settings.runtime  )
	assert_equal( expect, TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj   )

end



def test08Combine

	one    = { a: 1, b: { c: 2, d: 3 } }
	two    = {       b: {       d: 4 } }
	three  = {       b: { c: 5       } }
	expect = { a: 1, b: { c: 5, d: 4 } }

	TestHelper.reset
	config = Susu::Options::Config.new( default: one, userset: two, runtime: three )
	config.setup TestHelper

	assert_equal( one   , TestHelper.settings.default  )
	assert_equal( two   , TestHelper.settings.userset  )
	assert_equal( three , TestHelper.settings.runtime  )
	assert_equal( expect, TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj   )

end



def test09FromRelFile

	one    = { a: 1, b: { c: 2, d: 3 } }
	two    = 'data/two.yml'.relpath
	three  = {       b: { c: 5       } }
	expect = { a: 1, b: { c: 5, d: 4 } }

	TestHelper.reset
	config = Susu::Options::Config.new( default: one, userset: two, runtime: three )
	config.setup TestHelper

	two = Settings.load two

	assert_equal( one   , TestHelper.settings.default  )
	assert_equal( two   , TestHelper.settings.userset  )
	assert_equal( three , TestHelper.settings.runtime  )
	assert_equal( expect, TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj   )

end



def test10FromRelString

	one    = { a: 1, b: { c: 2, d: 3 } }
	two    = 'data/two.yml'
	three  = {       b: { c: 5       } }
	expect = { a: 1, b: { c: 5, d: 4 } }

	TestHelper.reset
	config = Susu::Options::Config.new( default: one, userset: two, runtime: three )
	config.setup TestHelper

	two = Settings.load two.relpath

	assert_equal( one   , TestHelper.settings.default  )
	assert_equal( two   , TestHelper.settings.userset  )
	assert_equal( three , TestHelper.settings.runtime  )
	assert_equal( expect, TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj   )

end



def test11FromDirectory

	data = 'data'

	TestHelper.reset
	assert_nothing_raised { Susu::Options::Config.new( default: data ) }
	# config.setup TestHelper

	# two = Settings.load two

	# assert_equal( one   , TestHelper.settings.default  )
	# assert_equal( two   , TestHelper.settings.userset  )
	# assert_equal( three , TestHelper.settings.runtime  )
	# assert_equal( expect, TestHelper.options           )
	# assert_equal( config, TestHelper.settings.cfgObj   )

end



def test12FromInclude

	two    = 'data/two.yml'
	one    = { a: 1, b: { c: 2, d: 3 }, include: two }
	three  = {       b: { c: 5       } }
	expect = { a: 1, b: { c: 5, d: 4 } }

	TestHelper.reset
	config = Susu::Options::Config.new( default: one, runtime: three )
	config.setup TestHelper

	one.delete :include
	two = Settings.load two.relpath

	assert_equal( one   , TestHelper.settings.default  )
	assert_equal( two   , TestHelper.settings.userset  )
	assert_equal( three , TestHelper.settings.runtime  )
	assert_equal( expect, TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj   )

end



def test13SetupPartial

	two    = 'data/two.yml'
	one    = { a: 1, b: { c: 2, d: 3 }, include: two }
	three  = {       b: { c: 5       } }
	expect = { a: 1, b: { c: 5, d: 4 } }

	TestHelper.reset
	config = Susu::Options::Config.new( default: one, runtime: three )
	config.setup TestHelper, :b

	one.delete :include
	two = Settings.load two.relpath

	assert_equal( one   [ :b ], TestHelper.settings.default  )
	assert_equal( two   [ :b ], TestHelper.settings.userset  )
	assert_equal( three [ :b ], TestHelper.settings.runtime  )
	assert_equal( expect[ :b ], TestHelper.options           )
	assert_equal( config      , TestHelper.settings.cfgObj   )

end



def test14Inheritance

	two     = 'data/two.yml'
	one     = { a: 1, b: { c: 2, d: 3 }, include: two }
	three   = {       b: { c: 5       } }
	expect  = { a: 1, b: { c: 5, d: 4 } }

	threeC  = {       b: { c: 6       } }
	expectC = { a: 1, b: { c: 6, d: 4 } }


	TestHelper      .reset
	TestHelperChild .reset

	assert( ! TestHelperChild.configured? )

	config  = Susu::Options::Config.new( default: one, runtime: three  )
	config.setup TestHelper

	configC = Susu::Options::Config.new( default: one, runtime: threeC )
	configC.setup TestHelperChild

	assert( TestHelperChild.configured? )


	one.delete :include
	two = Settings.load two.relpath

	assert_equal( one    , TestHelper      .settings.default  )
	assert_equal( two    , TestHelper      .settings.userset  )
	assert_equal( three  , TestHelper      .settings.runtime  )
	assert_equal( expect , TestHelper      .options           )
	assert_equal( config , TestHelper      .settings.cfgObj   )

	assert_equal( one    , TestHelperChild .settings.default  )
	assert_equal( two    , TestHelperChild .settings.userset  )
	assert_equal( threeC , TestHelperChild .settings.runtime  )
	assert_equal( expectC, TestHelperChild .options           )
	assert_equal( configC, TestHelperChild .settings.cfgObj   )

end



def test15IncludeFromFile

	one    = 'data/one.yml'  .relpath
	two    = 'data/two.yml'  .relpath
	three  = 'data/three.yml'.relpath
	expect = Settings.load( one ).deep_merge!( Settings.load( two ) ).deep_merge!( Settings.load( three ) )

	TestHelper.reset
	config = Susu::Options::Config.new( default: 'data/include.yml' )
	config.setup TestHelper


	assert_equal( {}    , TestHelper.settings.default  )
	assert_equal( expect, TestHelper.settings.userset  )
	assert_equal( {}    , TestHelper.settings.runtime  )
	assert_equal( expect, TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj   )

end



def test16NestedInclude

	one    = 'data/one.yml'  .relpath
	two    = 'data/two.yml'  .relpath
	three  = 'data/three.yml'.relpath
	expect = Settings.load( one ).deep_merge!( Settings.load( two ) ).deep_merge!( Settings.load( three ) )

	TestHelper.reset
	config = Susu::Options::Config.new( default: { include: 'data/include.yml' } )
	config.setup TestHelper


	assert_equal( {}    , TestHelper.settings.default  )
	assert_equal( expect, TestHelper.settings.userset  )
	assert_equal( {}    , TestHelper.settings.runtime  )
	assert_equal( expect, TestHelper.options           )
	assert_equal( config, TestHelper.settings.cfgObj   )

end



def test17AbsolutePath

	defInclude = 'data/include.yml'.relpath.realpath
	one        = 'data/one.yml'    .relpath
	two        = 'data/two.yml'    .relpath
	three      = 'data/three.yml'  .relpath

	expect     = Settings.load( one ).deep_merge!( Settings.load( two ) ).deep_merge!( Settings.load( three ) )


	TestHelper.reset
	config = Susu::Options::Config.new( default: { include: defInclude } )
	config.setup TestHelper


	parsed = [ defInclude, one, two, three ]


	assert_equal( {}    , TestHelper.settings.default            )
	assert_equal( expect, TestHelper.settings.userset            )
	assert_equal( {}    , TestHelper.settings.runtime            )
	assert_equal( expect, TestHelper.options                     )
	assert_equal( config, TestHelper.settings.cfgObj             )
	assert_equal( parsed, TestHelper.settings.cfgObj.parsedFiles )

end



def test18Sanitizer

	one           = { a:  1 , b: { c:  2 , d:  3  } }
	two           = {         b: {         d:  4  } }
	expectDefault = { a: '1', b: { c: '2', d: '3' } }
	expectUser    = {         b: {         d: '4' } }
	expect        = { a: '1', b: { c: '2', d: '4' } }


	san = lambda do |key, value|

		if value.kind_of?( Settings )

			value._sanitizer_ = san
			return key, value

		end

		return key, value.to_s

	end


	TestHelper.reset
	config = Susu::Options::Config.new( default: one, userset: two )
	config.setup( TestHelper, sanitizer: san )

	assert_equal( expectDefault, TestHelper.settings.default  )
	assert_equal( expectUser   , TestHelper.settings.userset  )
	assert_equal( {}           , TestHelper.settings.runtime  )
	assert_equal( expect       , TestHelper.options           )
	assert_equal( config       , TestHelper.settings.cfgObj   )

end


end # class  TestConfig
end # module Options
end # module Susu
