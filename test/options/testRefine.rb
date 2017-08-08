using Susu.refines

module Susu
module Options

class TestRefine < Test::Unit::TestCase


def test01ToSettings

	assert_instance_of Settings, {}.to_settings

end


def test02Dig

	s = { a: { b: 3 }, c: 4 }.to_settings

	assert_equal s, s.dig

end


end # class  TestRefine
end # module Options
end # module Susu
