Susu.refine binding

module Susu
module Refine

class TestDate < Test::Unit::TestCase


data do

	{

		"Identical time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1             ), 0  ] ,
		"Earlier   time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2014, 12, 31, 23, 59, 59 ), 1  ] ,
		"Later     time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1,  0,  0,  1 ), -1 ] ,

	}

end

def test01Spaceship(( a, b, expect ))

	assert_equal expect, a <=> b

end


data do

	{

		"Identical time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1             ), false ] ,
		"Earlier   time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2014, 12, 31, 23, 59, 59 ), false ] ,
		"Later     time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1,  0,  0,  1 ), true  ] ,

	}

end

def test02Smaller(( a, b, expect ))

	assert_equal expect, a < b

end


data do

	{

		"Identical time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1             ), false ] ,
		"Earlier   time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2014, 12, 31, 23, 59, 59 ), true  ] ,
		"Later     time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1,  0,  0,  1 ), false ] ,

	}

end

def test03Bigger(( a, b, expect ))

	assert_equal expect, a > b

end


data do

	{

		"Identical time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1             ), true  ] ,
		"Earlier   time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2014, 12, 31, 23, 59, 59 ), false ] ,
		"Later     time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1,  0,  0,  1 ), false ] ,

	}

end

def test04Equals(( a, b, expect ))

	assert_equal expect, a == b

end


data do

	{

		"Identical time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1             ), ::Time.new( 2015,  1,  1             ), true  ] ,
		"Earlier   time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2014, 12, 31, 23, 59, 59 ), ::Time.new( 2015, 12, 31, 23, 59, 59 ), true  ] ,
		"Later     time"  => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1,  0,  0,  1 ), ::Time.new( 2015,  1,  1,  0,  0,  2 ), false ] ,

	}

end

def test05Between?(( a, min, max, expect ))

	assert_equal expect, a.between?( min, max )

end

end # class  TestDate
end # module Refine
end # module Susu
