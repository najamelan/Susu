using Susu.refines

module Susu
module Refine

class TestModule < Test::Unit::TestCase


def test01lastname

	assert_equal 'Array', Susu::Refine::Array.lastname

end


end # class  TestModule
end # module Refine
end # module Susu
