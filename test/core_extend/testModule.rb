eval Susu::ALL_REFINES, binding

module Susu
module CoreExtend

class TestModule < Test::Unit::TestCase


def test01lastname

	assert_equal 'RefineArray', Susu::CoreExtend::RefineArray.lastname
	assert       Susu.respond_to? :lastname

end


end # class  TestModule
end # module CoreExtend
end # module Susu
