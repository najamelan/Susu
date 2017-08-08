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

		"Before"          => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1,  0,  0,  1 ), ::Time.new( 2015,  1,  1,  0,  0,  2 ), false ] ,
		"Identical"       => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1             ), ::Time.new( 2015,  1,  1             ), true  ] ,
		"Include min"     => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2015,  1,  1             ), ::Time.new( 2015,  1,  2             ), true  ] ,
		"Include max"     => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2014,  1,  1             ), ::Time.new( 2015,  1,  1             ), true  ] ,
		"Between"         => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2014, 12, 31, 23, 59, 59 ), ::Time.new( 2015, 12, 31, 23, 59, 59 ), true  ] ,
		"After"           => [ ::Date.new( 2015, 1, 1 ), ::Time.new( 2014, 12, 31, 23, 59, 58 ), ::Time.new( 2014, 12, 31, 23, 59, 59 ), false ] ,

	}

end

def test05Between?(( a, min, max, expect ))

	assert_equal expect, a.between?( min, max )

end



data do

	{

		"Year 1"     => [ '0001-01-01' ] ,
		"Year 2016"  => [ '2016-12-31' ] ,
	}

end

def test06iso8601(( string ))

	assert_equal ::Date.iso8601_orig( string ), ::Date.iso8601( string )

end

end # class  TestDate
end # module Refine
end # module Susu
