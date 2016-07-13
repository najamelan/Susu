module TidBits
module CoreExtend

class TestString < Test::Unit::TestCase


def test_00Path

	assert( '.'.path.exist?     )
	assert( '.'.path.directory? )

end


end # class  TestString
end # module CoreExtend
end # module TidBits
