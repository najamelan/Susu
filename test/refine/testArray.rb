eval Susu::ALL_REFINES, binding

module Susu
module Refine

class TestArray < Test::Unit::TestCase


def test01Nest_concat

	# Format: message, input1, input1 control, input2, input2 control, expect
	data =
	[
			[                                     \
				  "Empty inputs"                   \
				, []                               \
				, []                               \
				, []                               \
				, []                               \
				, []                               \
			]                                     \
                                               \
		,  [                                     \
				  "Basic usage"                    \
				, [ [1], [2] ]                     \
				, [ [1], [2] ]                     \
				, [ [3], [4] ]                     \
				, [ [3], [4] ]                     \
				, [ [1,3], [2,4] ]                 \
			]                                     \
	]


	data.each do | arr |

		assert_equal( arr[ 5 ], arr[ 1 ].nest_concat( arr[ 3 ] ), "\n\nTEST: " + arr.first + "\n" )

		# Verify the originals haven't changed
		#
		assert_equal( arr[ 2 ], arr[ 1 ], "\n\nTEST: " + arr.first + "\n" )
		assert_equal( arr[ 4 ], arr[ 3 ], "\n\nTEST: " + arr.first + "\n" )

	end


	assert [].respond_to? :nest_concat

end


def test02Nest_concat!

	# Format: message, input1, input1 control, input2, input2 control, expect
	#
	data =
	[
			[                                     \
				  "Empty inputs"                   \
				, []                               \
				, []                               \
				, []                               \
				, []                               \
				, []                               \
			]                                     \
                                               \
		,  [                                     \
				  "Basic usage"                    \
				, [ [1], [2] ]                     \
				, [ [1,3], [2,4] ]                 \
				, [ [3], [4] ]                     \
				, [ [3], [4] ]                     \
				, [ [1,3], [2,4] ]                 \
			]                                     \
	]


	data.each do | arr |

		assert_equal( arr[ 5 ], arr[ 1 ].nest_concat!( arr[ 3 ] ), "\n\nTEST: " + arr.first + "\n" )

		# Verify the originals haven't changed
		#
		assert_equal( arr[ 2 ], arr[ 1 ], "\n\nTEST: " + arr.first + "\n" )
		assert_equal( arr[ 4 ], arr[ 3 ], "\n\nTEST: " + arr.first + "\n" )

	end


	assert [].respond_to? :nest_concat!

end



def test03first=

	# Format: message, original array, value, expect
	#
	data =
	[
			[                                     \
				  "Empty array"                    \
				, []                               \
				, 1                                \
				, [ 1 ]                            \
			]                                     \
                                               \
		,  [                                     \
				  "Basic usage"                    \
				, [ 9, 8 ]                         \
				, 1                                \
				, [ 1, 8 ]                         \
			]                                     \
	]


	data.each do | arr |

		arr[ 1 ].first = arr[ 2 ]

		assert_equal( arr[ 3 ], arr[ 1 ], "\n\nTEST: " + arr.first + "\n" )

	end


	assert [].respond_to? :first=

end



def test04last=

	# Format: message, original array, value, expect
	#
	data =
	[
			[                                     \
				  "Empty array"                    \
				, []                               \
				, 1                                \
				, [ 1 ]                            \
			]                                     \
                                               \
		,  [                                     \
				  "Basic usage"                    \
				, [ 9, 8 ]                         \
				, 1                                \
				, [ 9, 1 ]                         \
			]                                     \
	]


	data.each do | arr |

		arr[ 1 ].last = arr[ 2 ]

		assert_equal( arr[ 3 ], arr[ 1 ], "\n\nTEST: " + arr.first + "\n" )

	end


	assert [].respond_to? :last=

end


end # class  TestArray
end # module Refine
end # module Susu
