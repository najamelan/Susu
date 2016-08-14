eval Susu::ALL_REFINES, binding

module Susu
module CoreExtend

class TestHash < Test::Unit::TestCase


def testSuperset

	data =
	[
			[
				  "Completely unrelated hashes"                             \
				, { a: 1, b: 2 }                                            \
				, { c: 3, d: 4 }                                            \
				, false                                                     \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "Same values, different keys"                             \
				, { a: 1, b: 2 }                                            \
				, { c: 1, d: 2 }                                            \
				, false                                                     \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "Same keys, different values"                             \
				, { a: 1, b: 2 }                                            \
				, { a: 3, b: 4 }                                            \
				, false                                                     \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "One corresponding, other not"                            \
				, { a: 1, b: 2 }                                            \
				, { a: 1, b: 4 }                                            \
				, false                                                     \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "Identical Hashes"                                        \
				, { a: 1, b: 2 }                                            \
				, { a: 1, b: 2 }                                            \
				, true                                                      \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "Actual subset"                                           \
				, { a: 1, b: 2, c: 3 }                                      \
				, { a: 1, b: 2       }                                      \
				, true                                                      \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "Nested Hash"                                             \
				, { a: 1, b: 2, c: { a: 1, b: 2 } }                         \
				, { a: 1, b: 2                    }                         \
				, true                                                      \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "Subset in Nested Hash"                                   \
				, { a: 1, b: 2, c: { a: 1, b: 2 } }                         \
				, { a: 1, b: 2, c: {       b: 2 } }                         \
				, true                                                      \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "Empty hashes"                                            \
				, {}                                                        \
				, {}                                                        \
				, true                                                      \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "Empty hashes"                                            \
				, { a: 1 }                                                  \
				, {}                                                        \
				, true                                                      \
			]                                                              \
	]


	data.each do | arr |

		control1 = arr[ 1 ].dup
		control2 = arr[ 2 ].dup

		result   = arr[ 1 ].superset? arr[ 2 ]
		result2  = arr[ 2 ].subset?   arr[ 1 ]

		assert_equal( control1, arr[ 1 ], "\n\nTEST: " + arr.first + "\n" )
		assert_equal( control2, arr[ 2 ], "\n\nTEST: " + arr.first + "\n" )

		assert_equal( arr[ 3 ], result  , "\n\nTEST: " + arr.first + "\n" )
		assert_equal( arr[ 3 ], result2 , "\n\nTEST: " + arr.first + "\n" )

	end

end


def testDiff

	data =
	[
			[
				  "diff two empty hashes"                                   \
				, {}                                                        \
				, {}                                                        \
				, {}                                                        \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "identical properties"                                    \
				, { a: 1 }                                                  \
				, { a: 1 }                                                  \
				, {}                                                        \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "add a property"                                          \
				, {}                                                        \
				, { a: 1 }                                                  \
				, { a: 1 }                                                  \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "remove a property"                                       \
				, { a: 1 }                                                  \
				, {}                                                        \
				, { a: 1 }                                                  \
			]                                                              \
                                                                        \
		,  [                                                              \
				  "change a property"                                       \
				, { a: 1 }                                                  \
				, { a: 2 }                                                  \
				, { a: 1 }                                                  \
			]                                                              \
	]


	data.each do | arr |

		# Verify the original doesn't change
		#
		control = arr[ 1 ].dup
		assert_equal( control , arr[ 1 ], "\n\nTEST: " + arr[ 0 ] + "\n" )

		result  = arr[ 1 ].diff arr[ 2 ]
		assert_equal( arr[ 3 ], result  , "\n\nTEST: " + arr[ 0 ] + "\n" )

		result2 = arr[ 1 ].diff( arr[ 2 ] ).diff( arr[ 2 ] )
		assert_equal( arr[ 1 ], result2 , "\n\nTEST: " + arr[ 0 ] + " - double diff test\n" )

	end

end



# This actually tests an active support method, but since we already had the tests,
# it never hurts to double check
#
def testMergeNestedHash

	data =
	[
			[
				  "merge two empty hashes, should return empty hash"        \
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
		result  = arr[ 1 ].deep_merge arr[ 2 ]
		assert_equal( control , arr[ 1 ], "\n\nTEST: " + arr[ 0 ] + "\n" )
		assert_equal( arr[ 3 ], result  , "\n\nTEST: " + arr[ 0 ] + "\n" )

		# The in place version
		#
		assert_equal( arr[ 3 ], arr[ 1 ].deep_merge!( arr[ 2 ] ), "\n\nTEST: " + arr[ 0 ] + "\n" )

	end

end



def testDig

	# TODO

end


end # class  TestHash
end # module CoreExtend
end # module Susu
