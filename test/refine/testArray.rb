Susu.refine binding

module Susu
module Refine

class TestArray < Test::Unit::TestCase

data do

	{
		"Empty inputs" =>

			[
				[] ,
				[] ,
				[] ,
				[] ,
				[]
			],

      "Basic usage"  =>

			[
				[ [1], [2] ]      ,
				[ [1], [2] ]      ,
				[ [3], [4] ]      ,
				[ [3], [4] ]      ,
				[ [1,3], [2,4] ]
			]
	}

end

def test01Nest_concat data

	input1, input1Control, input2, input2Control, expect = data


	assert_equal  expect, input1.nest_concat( input2 )

	# Verify the originals haven't changed
	#
	assert_equal input1Control, input1
	assert_equal input2Control, input2

end



data do

	{
		"Empty inputs" =>

			[
				[] ,
				[] ,
				[] ,
				[] ,
				[]
			],

      "Basic usage"  =>

			[
				[ [1], [2] ]      ,
				[ [1,3], [2,4] ]  ,
				[ [3], [4] ]      ,
				[ [3], [4] ]      ,
				[ [1,3], [2,4] ]
			]
	}

end

def test02Nest_concat! data

	input1, input1Control, input2, input2Control, expect = data


	assert_equal  expect, input1.nest_concat!( input2 )

	# Verify the originals haven't changed
	#
	assert_equal input1Control, input1
	assert_equal input2Control, input2

end



data do

	{
		"Empty array" =>

			[
				[]    ,
				1     ,
				[ 1 ] ,
			],

      "Basic usage"  =>

			[
				[ 9, 8 ]  ,
				1         ,
				[ 1, 8 ]  ,
			]
	}

end

def test03first= data

	original, value, expect = data

	original.first = value

	assert_equal expect, original

end



data do

	{
		"Empty array" =>

			[
				[]    ,
				1     ,
				[ 1 ] ,
			],

      "Basic usage"  =>

			[
				[ 9, 8 ]  ,
				1         ,
				[ 9, 1 ]  ,
			]
	}

end

def test04last= data

	original, value, expect = data

	original.last = value

	assert_equal expect, original

end



def test05pgrep

	paths = [ Pathname( '/var' ), Pathname( '/etc' ) ]

	assert_equal paths.map( &:to_s ).grep( /ddd/ ), paths.pgrep( /ddd/ ).map( &:to_s )
	assert_equal paths.map( &:to_s ).grep( /var/ ), paths.pgrep( /var/ ).map( &:to_s )

	# Should call normal grep when not receiving a Regexp
	#
	objects = [ [], {}, 3 ]

	assert_equal objects.grep( Hash ), objects.pgrep( Hash )


end



data do

	{
		'Single object'              => [    :a    , [ :a     ] ] ,
		'Nil'                        => [    nil   , [        ] ] ,
		'Empty Array'                => [  [    ]  , [        ] ] ,
		'Array 1 elem'               => [  [ :a ]  , [ :a     ] ] ,
		'Nested Array'               => [ [[ :a ]] , [ [:a]   ] ] ,
		'Object that defines #to_a'  => [  {a: 1}  , [ {a: 1} ] ]
	}

end

def test06ArrayEat data

	input, expect = data

	assert_equal expect, ::Array.eat( input )

end



data do

	{
		'Single object'   => [ 3        , 3      ] ,
		'Empty Array'     => [ []       , []     ] ,
		'Array with nil'  => [ [  nil ] , nil    ] ,
		'Array 1 elem'    => [ [  :a  ] , :a     ] ,
		'Nested Array'    => [ [[ :a ]] , [:a]   ] ,
		'Array with Hash' => [ [{a: 1}] , {a: 1} ]
	}

end

def test07ArraySpit data

	input, expect = data

	assert_equal expect, ::Array.spit( input )

end


#-------------------------------------------------------------------------------


data do

	{
		'Empty Array'           => [ [         ] , nil    ] ,
		'Array 1 elem'          => [ [ :a      ] , nil    ] ,
		'Array with nil'        => [ [ nil     ] , []     ] ,
		'Array 1 elem and nil'  => [ [ :a, nil ] , [ :a ] ]
	}

end

def test08Compact_orig! data

	input, expect = data

	assert_equal expect, input.compact_orig!

end



data do

	{
		'Empty Array'           => [ [         ] , []     ] ,
		'Array 1 elem'          => [ [ :a      ] , [ :a ] ] ,
		'Array with nil'        => [ [ nil     ] , []     ] ,
		'Array 1 elem and nil'  => [ [ :a, nil ] , [ :a ] ]
	}

end

def test09Compact! data

	input, expect = data

	assert_equal expect, input.compact!

end


#-------------------------------------------------------------------------------


data do

	{
		'Empty Array'             => [ [            ] , nil        ] ,
		'Array 1 elem'            => [ [ :a, :b     ] , nil        ] ,
		'Nested Array'            => [ [ [ :a ]     ] , [ :a     ] ] ,
		'Array 1 elem and array'  => [ [ :a, [ :b ] ] , [ :a, :b ] ]
	}

end

def test10Flatten_orig! data

	input, expect = data

	assert_equal expect, input.flatten_orig!

end



data do

	{
		'Empty Array'             => [ [            ] , []         ] ,
		'Array 1 elem'            => [ [ :a, :b     ] , [ :a, :b ] ] ,
		'Nested Array'            => [ [ [ :a ]     ] , [ :a     ] ] ,
		'Array 1 elem and array'  => [ [ :a, [ :b ] ] , [ :a, :b ] ]
	}

end

def test11Flatten! data

	input, expect = data

	assert_equal expect, input.flatten!

end


#-------------------------------------------------------------------------------


data do

	{
		'Empty Array'             => [ [        ] , nil    ] ,
		'2 different elements'    => [ [ :a, :b ] , nil    ] ,
		'2 times same element'    => [ [ :a, :a ] , [ :a ] ]
	}

end

def test12Uniq_orig! data

	input, expect = data

	assert_equal expect, input.uniq_orig!

end



data do

	{
		'Empty Array'             => [ [        ] , [        ] ] ,
		'2 different elements'    => [ [ :a, :b ] , [ :a, :b ] ] ,
		'2 times same element'    => [ [ :a, :a ] , [ :a     ] ]
	}

end

def test13Uniq! data

	input, expect = data

	assert_equal expect, input.uniq!

end


end # class  TestArray
end # module Refine
end # module Susu
