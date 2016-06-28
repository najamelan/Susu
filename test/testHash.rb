require          'test/unit'
require          'pp'
require_relative '../lib/core_extend'

module TidBits
module CoreExtend

class TestHash < Test::Unit::TestCase


def testMergeNestedHash!

	data =
	[
			[
				  "merge two empty hashes, shourld return empty hash"       \
				, {}                                                        \
				, {}                                                        \
				, {}                                                        \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "a simple nested merge"                                   \
				, { a: { b: 1, c: 2       } }                               \
				, { a: { e: 3             } }                               \
				, { a: { b: 1, c: 2, e: 3 } }                               \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "override an existing non-hash element"                   \
				, { a: { b: 1 , c: 2      } }                               \
				, { a: { b: 4, e: 3       } }                               \
				, { a: { b: 4, c: 2, e: 3 } }                               \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "hash in first, string in second"                         \
				, { a: { b: 1 , c: 2      } }                               \
				, { a: 'boom'               }                               \
				, { a: 'boom'               }                               \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "string in first, hash in second"                         \
				, { a: 'boom'               }                               \
				, { a: { b: 1 , c: 2      } }                               \
				, { a: { b: 1 , c: 2      } }                               \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "nest two levels"                                         \
				, { a: { b: 1 , c: { d: 3, e: 4 }       } }                 \
				, { a: { b: 1 , c: { d: 5, f: 6 }       } }                 \
				, { a: { b: 1 , c: { d: 5, e: 4, f: 6 } } }                 \
			]                                                              \
	]


	data.each do | arr |

		control = arr[ 1 ].dup
		result  = arr[ 1 ].recursive_merge arr[ 2 ]
		assert_equal( control , arr[ 1 ], "\n\nTEST: " + arr[ 0 ] + "\n" )
		assert_equal( arr[ 3 ], result  , "\n\nTEST: " + arr[ 0 ] + "\n" )

		# The in place version
		#
		assert_equal( arr[ 3 ], arr[ 1 ].recursive_merge!( arr[ 2 ] ), "\n\nTEST: " + arr[ 0 ] + "\n" )

	end

end


end # class  TestHash
end # module CoreExtend
end # module TidBits
