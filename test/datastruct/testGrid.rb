using Susu.refines

module Susu
module DataStruct


class TestGrid < Test::Unit::TestCase


def setup

	super

	@@sample = g = Grid.new 0,0,'_'

	g[ 0, 0 ] = 'a'
	g[ 1, 0 ] = 'b'
	g[ 2, 0 ] = 'c'

	g[ 0, 1 ] = 'd'
	g[ 1, 1 ] = 'e'
	g[ 2, 1 ] = 'f'

end


def test00_constructor

	g = Grid.new 1, 1, 54

		assert_equal [ 1, 1 ], g.size
		assert_equal 54      , g.default
		assert_equal 54      , g[ 0, 0 ]

end



def test01_get_set

	g = Grid.new

		assert_nil g[ 2, 2 ]


	g[ 3, 7 ] = 'i'

		assert_equal  'i', g[ 3, 7 ]


	g[ 3, 7 ] = 'b'

		assert_equal  'b', g[ 3, 7 ]


	# Try with array
	#
	g[ [ 3, 7 ] ] = 'c'

		assert_equal  'c', g[ 3, 7 ]

end



def test02_size

	g = Grid.new

	g[ 3, 7 ] = 'i'

		assert_equal [ 4, 8 ], g.size

end



def test03_size=

	g = Grid.new 0, 0, 54

		assert_equal 54, g.default


	g.size = [ 3, 3 ]

		assert_equal  [ 3, 3 ], g.size
		assert_equal g.default, g[ 2, 2 ]


	g.size = [ 3, 3 ]

		assert_equal  [ 3, 3 ], g.size
		assert_equal g.default, g[ 2, 2 ]


	g.size = [ 1, 1 ]

		assert_equal  [ 1, 1 ], g.size
		assert_equal g.default, g[ 0, 0 ]


	g.size = [ 0, 0 ]

		assert_equal   [ 0, 0 ], g.size
		assert_nil    g[ 1, 1 ]


	# Test taking two separate parameters
	#
	g.size = 2, 2

		assert_equal  [ 2, 2 ], g.size
		assert_equal g.default, g[ 1, 1 ]


	# Test assymetric sizes
	#
	g.size = 2, 4

		assert_equal  [ 2, 4 ], g.size
		assert_equal g.default, g[ 1, 3 ]


	# After a discovered bug, make a test which tests more aspects of how exactly a grid evolves after resizing:
	#
	g = Grid.new 0, 0, 'x'

		assert_equal [ 0, 0 ], g.size
		assert_equal 'x'     , g.default
		assert_nil   g[ 0, 0 ]


	g[ 0, 0 ] = 'a'

		assert_equal [ 1, 1 ], g.size
		assert_equal 'x'     , g.default
		assert_equal 'a'     , g[ 0, 0 ]

		assert_nil   g[ 1, 1 ]


	g[ 1, 0 ] = 'b'

		assert_equal [ 2, 1 ], g.size
		assert_equal 'x'     , g.default
		assert_equal 'a'     , g[ 0, 0 ]
		assert_equal 'b'     , g[ 1, 0 ]

		assert_nil   g[ 2, 1 ]


	g[ 0, 1 ] = 'c'

		assert_equal [ 2, 2 ], g.size
		assert_equal 'x'     , g.default
		assert_equal 'a'     , g[ 0, 0 ]
		assert_equal 'b'     , g[ 1, 0 ]
		assert_equal 'c'     , g[ 0, 1 ]

		assert_nil   g[ 2, 1 ]


	g[ 1, 1 ] = 'd'

		assert_equal [ 2, 2 ], g.size
		assert_equal 'x'     , g.default
		assert_equal 'a'     , g[ 0, 0 ]
		assert_equal 'b'     , g[ 1, 0 ]
		assert_equal 'c'     , g[ 0, 1 ]
		assert_equal 'd'     , g[ 1, 1 ]

		assert_nil   g[ 2, 2 ]


	# Test adding several rows at once
	#
	g = Grid.new 0, 0, 'x'

	g[ 0, 3 ] = 'a'

		assert_equal 'x', g[ 0, 0 ]
		assert_equal 'x', g[ 0, 1 ]
		assert_equal 'x', g[ 0, 2 ]
		assert_equal 'a', g[ 0, 3 ]

		assert_nil g[ 0, 4 ]
		assert_nil g[ 1, 0 ]

end



def test04_clear

	g = Grid.new 0, 0, 54

	g.size = [ 3, 3 ]

		assert_equal [ 3, 3 ] , g.size
		assert_equal g.default, g[ 2, 2 ]


	g.clear

		assert_equal  [ 0, 0 ], g.size
		assert_nil   g[ 1, 1 ]

end



def test05_each

	expect = [ 'a', 'b', 'c', 'd', 'e', 'f' ]
	output = []

	@@sample.each { |e| output << e }

		assert_equal expect, output

end



def test06_each_with_coord

	assert_equal [ ['a', 0, 0], ['b', 1, 0], ['c', 2, 0], ['d', 0, 1], ['e', 1, 1], ['f', 2, 1] ],
	             @@sample.each_with_coord.to_a

end



def test07_select

	assert_equal [ 'b', 'c', 'f'  ], @@sample.select { |str| str =~ /[bcf]/ }

end



def test08_reject

	assert_equal [ 'b', 'c', 'f'  ], @@sample.reject { |str| str =~ /[ade]/ }

end



def test09_rows

	assert_equal [], Grid.new.rows.map( &:to_a )
	assert_equal [ ['a', 'b', 'c'], ['d', 'e', 'f'] ], @@sample.rows.map( &:to_a )

end



def test10_cols

	assert_equal [], Grid.new.cols.map( &:to_a )
	assert_equal [ ['a', 'd'], ['b', 'e'], ['c', 'f'] ], @@sample.cols.map( &:to_a )

end



def test11_map!

	assert_equal [ 'A', 'B', 'C', 'D', 'E', 'F' ], @@sample.map!( &:upcase ).each.to_a
	assert_equal [ 'A', 'B', 'C', 'D', 'E', 'F' ], @@sample.each.to_a

end



def test12_map

	# Verify we get correct input
	#
	assert_equal [ 'a', 'b', 'c', 'd', 'e', 'f' ], @@sample.each.to_a

	assert_equal [ 'A', 'B', 'C', 'D', 'E', 'F' ], @@sample.map( &:upcase ).each.to_a

	# map shouldn't change the original
	#
	assert_equal [ 'a', 'b', 'c', 'd', 'e', 'f' ], @@sample.each.to_a

end



end # class TestGrid < Test::Unit::TestCase
end # module DataStruct
end # module Susu
