Susu.refine binding

module Susu
module Refine

class TestHash < Test::Unit::TestCase


data do

	{

		"Completely unrelated hashes"  => [ { a: 1, b: 2                    }, { c: 3, d: 4 }              , false ] ,
		"Same values, different keys"  => [ { a: 1, b: 2                    }, { c: 1, d: 2 }              , false ] ,
		"Same keys, different values"  => [ { a: 1, b: 2                    }, { a: 3, b: 4 }              , false ] ,
		"One corresponding, other not" => [ { a: 1, b: 2                    }, { a: 1, b: 4 }              , false ] ,
		"Identical Hashes"             => [ { a: 1, b: 2                    }, { a: 1, b: 2 }              , true  ] ,
		"Actual subset"                => [ { a: 1, b: 2, c: 3              }, { a: 1, b: 2 }              , true  ] ,
		"Nested Hash"                  => [ { a: 1, b: 2, c: { a: 1, b: 2 } }, { a: 1, b: 2 }              , true  ] ,
		"Subset in Nested Hash"        => [ { a: 1, b: 2, c: { a: 1, b: 2 } }, { a: 1, b: 2, c: { b: 2 } } , true  ] ,
		"Empty hashes"                 => [ {}                               , {}                          , true  ] ,
		"Superset of empty hash"       => [ { a: 1 }                         , {}                          , true  ]

	}

end

def testSuperset data

	a, b, expect = data

	controla = a.dup
	controlb = b.dup

	assert_equal expect, a.superset?( b )
	assert_equal expect, b.subset?(   a )

	assert_equal controla, a
	assert_equal controlb, b

end


data do

	{

		"diff two empty hashes" => [ {}      , {}      , {}       ] ,
		"identical properties"  => [ { a: 1 }, { a: 1 }, {}       ] ,
		"add a property"        => [ {}      , { a: 1 }, { a: 1 } ] ,
		"remove a property"     => [ { a: 1 }, {}      , { a: 1 } ] ,
		"change a property"     => [ { a: 1 }, { a: 2 }, { a: 1 } ]

	}

end

def testDiff data

	a, b, expect = data

	controla = a.dup
	controlb = b.dup

	assert_equal expect  , a.diff( b )
	assert_equal a       , a.diff( b ).diff( b ), 'Diffing twice should cancel out'

	assert_equal controla , a, 'Verify the original doesn\'t change'
	assert_equal controlb , b, 'Verify the original doesn\'t change'

end



# This actually tests an active support method, but since we already had the tests,
# it never hurts to double check
#
data do

	{

		"merge two empty hashes, should return empty hash" => [ {}, {}, {} ] ,
		"a simple nested merge"                 => [ { a: { b: 1, c: 2 } }, { a: { e: 3        } }, { a: { b: 1, c: 2, e: 3 } } ] ,
		"override an existing non-hash element" => [ { a: { b: 1, c: 2 } }, { a: { b: 4, e: 3  } }, { a: { b: 4, c: 2, e: 3 } } ] ,
		"hash in first, string in second"       => [ { a: { b: 1, c: 2 } }, { a: 'boom'          }, { a: 'boom'               } ] ,
		"string in first, hash in second"       => [ { a: 'boom'         }, { a: { b: 1 , c: 2 } }, { a: { b: 1 , c: 2      } } ] ,
		"nest two levels"                       => [ { a: { b: 1 , c: { d: 3, e: 4 } } }, { a: { b: 1 , c: { d: 5, f: 6 } } }, { a: { b: 1 , c: { d: 5, e: 4, f: 6 } } } ]
	}

end

def testMergeNestedHash data

	a, b, expect = data

	controla = a.dup
	controlb = b.dup

	assert_equal expect  , a.deep_merge( b )
	assert_equal controla, a
	assert_equal controlb, b

	# The in place version
	#
	assert_equal expect, a.deep_merge!( b )
	assert_equal controlb, b

end



def testDig

	# TODO
	#

end


end # class  TestHash
end # module Refine
end # module Susu
