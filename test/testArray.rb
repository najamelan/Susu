
module TidBits
module CoreExtend

class TestArray < Test::Unit::TestCase


	def testNest_concat

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

	end


def testNest_concat!

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

end


end # class  TestArray
end # module CoreExtend
end # module TidBits
