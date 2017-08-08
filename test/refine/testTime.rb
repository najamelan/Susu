using Susu.refines

module Susu
module Refine

class TestTime < Test::Unit::TestCase


data do

	{

		"Identical time"  => [ ::Time.new( 2015,  1,  1             ), ::Date.new( 2015, 1, 1 ),  0 ] ,
		"Earlier   time"  => [ ::Time.new( 2014, 12, 31, 23, 59, 59 ), ::Date.new( 2015, 1, 1 ), -1 ] ,
		"Later     time"  => [ ::Time.new( 2015,  1,  1,  0,  0,  1 ), ::Date.new( 2015, 1, 1 ),  1 ] ,

	}

end

def test01Spaceship(( a, b, expect ))

	assert_equal expect, a <=> b

end


data do

	{

		"Identical time"  => [ ::Time.new( 2015,  1,  1             ), ::Date.new( 2015, 1, 1 ), false ] ,
		"Earlier   time"  => [ ::Time.new( 2014, 12, 31, 23, 59, 59 ), ::Date.new( 2015, 1, 1 ), true  ] ,
		"Later     time"  => [ ::Time.new( 2015,  1,  1,  0,  0,  1 ), ::Date.new( 2015, 1, 1 ), false ] ,

	}

end

def test02Smaller(( a, b, expect ))

	assert_equal expect, a < b

end


data do

	{

		"Identical time"  => [ ::Time.new( 2015,  1,  1             ), ::Date.new( 2015, 1, 1 ), false ] ,
		"Earlier   time"  => [ ::Time.new( 2014, 12, 31, 23, 59, 59 ), ::Date.new( 2015, 1, 1 ), false ] ,
		"Later     time"  => [ ::Time.new( 2015,  1,  1,  0,  0,  1 ), ::Date.new( 2015, 1, 1 ), true  ] ,

	}

end

def test03Bigger(( a, b, expect ))

	assert_equal expect, a > b

end


data do

	{

		"Identical time"  => [ ::Time.new( 2015,  1,  1             ), ::Date.new( 2015, 1, 1 ), true  ] ,
		"Earlier   time"  => [ ::Time.new( 2014, 12, 31, 23, 59, 59 ), ::Date.new( 2015, 1, 1 ), false ] ,
		"Later     time"  => [ ::Time.new( 2015,  1,  1,  0,  0,  1 ), ::Date.new( 2015, 1, 1 ), false ] ,

	}

end

def test04Equals(( a, b, expect ))

	assert_equal expect, a == b

end


data do

	{

		"Identical time"  => [ ::Time.new( 2015,  1,  1             ), ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1             ), true  ] ,
		"Earlier   time"  => [ ::Time.new( 2014, 12, 31, 23, 59, 59 ), ::Date.new( 2015, 1, 1 ), ::Time.new( 2015, 12, 31, 23, 59, 59 ), false ] ,
		"Later     time"  => [ ::Time.new( 2015,  1,  1,  0,  0,  1 ), ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1,  0,  0,  2 ), true  ] ,

	}

end

def test05Between?(( a, min, max, expect ))

	assert_equal expect, a.between?( min, max )

end

end # class  TestTime
end # module Refine
end # module Susu
