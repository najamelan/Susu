Susu.refine binding

module Susu
module Refine

class TestString < Test::Unit::TestCase


# TODO: does not cover all scenarios supported by wrap
#
data do

	empty = ''                         .freeze
	text  = 'abcd efgh ijkl'           .freeze
	text2 = "abcd\n\nefgh hoh\nijkl\n" .freeze
	dash  = "abcd-efgh"                .freeze
	white = "a\n  \t "                 .freeze

	{
		'Empty string'                                             => [ 10, empty, ''                          ] ,

		'Zero length wrap'                                         => [  0, text ,  text                       ] ,
		'Wrap equals total   text length'                          => [ 14, text ,  text                       ] ,
		'Wrap length exceeds text length'                          => [ 15, text ,  text                       ] ,

		'Wrap width smaller than first       word  length,  1 - 4' => [  1, text ,  "abcd\nefgh\nijkl"         ] ,
		'Wrap width smaller than first       word  length,  2 - 4' => [  2, text ,  "abcd\nefgh\nijkl"         ] ,
		'Wrap width smaller than first       word  length,  3 - 4' => [  3, text ,  "abcd\nefgh\nijkl"         ] ,
		'Wrap width equal   to   first       word  length,  4 - 4' => [  4, text ,  "abcd\nefgh\nijkl"         ] ,
		'Wrap width smaller than first two   words length,  5 - 4' => [  5, text ,  "abcd\nefgh\nijkl"         ] ,
		'Wrap width smaller than first two   words length,  6 - 4' => [  6, text ,  "abcd\nefgh\nijkl"         ] ,
		'Wrap width smaller than first two   words length,  7 - 4' => [  7, text ,  "abcd\nefgh\nijkl"         ] ,
		'Wrap width smaller than first two   words length,  8 - 4' => [  8, text ,  "abcd\nefgh\nijkl"         ] ,
		'Wrap width equal   to   first two   words length,  9 - 4' => [  9, text ,  "abcd efgh\nijkl"          ] ,
		'Wrap width smaller than first three words length, 10 - 4' => [ 10, text ,  "abcd efgh\nijkl"          ] ,
		'Wrap width smaller than first three words length, 11 - 4' => [ 11, text ,  "abcd efgh\nijkl"          ] ,
		'Wrap width smaller than first three words length, 12 - 4' => [ 12, text ,  "abcd efgh\nijkl"          ] ,
		'Wrap width smaller than first three words length, 13 - 4' => [ 13, text ,  "abcd efgh\nijkl"          ] ,

		'String with newlines, short wrap - 1'                     => [  1, text2, "abcd\n\nefgh\nhoh\nijkl\n" ] ,
		'String with newlines, short wrap - 2'                     => [  2, text2, "abcd\n\nefgh\nhoh\nijkl\n" ] ,
		'String with newlines, short wrap - 3'                     => [  3, text2, "abcd\n\nefgh\nhoh\nijkl\n" ] ,
		'String with newlines, word  wrap - 4'                     => [  4, text2, "abcd\n\nefgh\nhoh\nijkl\n" ] ,
		'String with newlines, width falls in    newlines -  5'    => [  5, text2, "abcd\n\nefgh\nhoh\nijkl\n" ] ,
		'String with newlines, width falls in    newlines -  6'    => [  6, text2, "abcd\n\nefgh\nhoh\nijkl\n" ] ,
		'String with newlines, width falls after newlines -  7'    => [  7, text2, "abcd\n\nefgh\nhoh\nijkl\n" ] ,
		'String with newlines, width falls after newlines -  8'    => [  8, text2, "abcd\n\nefgh hoh\nijkl\n"  ] ,
		'String with newlines, width falls after newlines -  9'    => [  9, text2, "abcd\n\nefgh hoh\nijkl\n"  ] ,
		'String with newlines, width falls after newlines - 10'    => [ 10, text2, "abcd\n\nefgh hoh\nijkl\n"  ] ,

		'String with dash - shorter than dash    - 4'              => [  4, dash , "abcd-\nefgh"               ] ,
		'String with dash - exact width for dash - 5'              => [  5, dash , "abcd-\nefgh"               ] ,
		'String with dash - longer than dash     - 6'              => [  6, dash , "abcd-\nefgh"               ] ,
		'String with dash - entire string        - 9'              => [  9, dash , "abcd-efgh"                 ] ,
		'String with whitespace line, don\'t add newlines'         => [  4, white, "a\n  \t "                  ]
	}

end

def test01Wrap(( length, input, expect ))

	assert_equal expect, input.wrap( length )

end



def test02Wrap!

	text = ';lkj;lk;lkmkl;'

		assert_same text, text.wrap!( 10 )

end



def test03Strip_or_nil!

	none     = 'jklm'
	text     = ' jklm '
	stripped = text.strip_or_nil!

		assert_equal  none, stripped    , 'strip_or_nil! should remove whitespace'
		assert_same   text, stripped    , 'strip_or_nil! should perform inplace'

		assert_nil    none.strip_or_nil!, 'strip_or_nil! should return nil if there is no whitespace to remove'

end



def test04Strip!

	none     = 'jklm'
	text     = ' jklm '
	stripped = text.strip!

		assert_equal  none, stripped   , 'strip! should remove whitespace'
		assert_same   text, stripped   , 'strip! should perform inplace'

		assert_same   none, none.strip!, 'strip! should return self if there is no whitespace to remove'

end



def test05Lstrip_or_nil!

	none      = 'jklm '
	text      = ' jklm '
	lstripped = text.lstrip_or_nil!

		assert_equal  none, lstripped    , 'lstrip_or_nil! should remove whitespace'
		assert_same   text, lstripped    , 'lstrip_or_nil! should perform inplace'

		assert_nil    none.lstrip_or_nil!, 'lstrip_or_nil! should return nil if there is no whitespace to remove'

end



def test06Lstrip!

	none      = 'jklm '
	text      = ' jklm '
	lstripped = text.lstrip!

		assert_equal  none, lstripped   , 'lstrip! should remove whitespace'
		assert_same   text, lstripped   , 'lstrip! should perform inplace'

		assert_same   none, none.lstrip!, 'lstrip! should return self if there is no whitespace to remove'

end



def test07Rstrip_or_nil!

	none      = ' jklm'
	text      = ' jklm '
	rstripped = text.rstrip_or_nil!

		assert_equal  none, rstripped    , 'rstrip_or_nil! should remove whitespace'
		assert_same   text, rstripped    , 'rstrip_or_nil! should perform inplace'

		assert_nil    none.rstrip_or_nil!, 'rstrip_or_nil! should return nil if there is no whitespace to remove'

end



def test08Rstrip!

	none      = ' jklm'
	text      = ' jklm '
	rstripped = text.rstrip!

		assert_equal  none, rstripped   , 'rstrip! should remove whitespace'
		assert_same   text, rstripped   , 'rstrip! should perform inplace'

		assert_same   none, none.rstrip!, 'rstrip! should return self if there is no whitespace to remove'

end



def test09First

	assert_equal nil, ''   .first
	assert_equal 'a', 'aeg'.first

end



def test10Last

	assert_equal nil, ''   .last
	assert_equal 'g', 'aeg'.last

end



data do

	{
		'Empty string'                  => [ ""            , ""          ] ,
		'Simple usecase'                => [ "as \nlkj "   , "as\nlkj"   ] ,
		'Simple usecase with tab'       => [ "as \t\nlkj"  , "as\nlkj"   ] ,
		'End with newline'              => [ "as \nlkj\n"  , "as\nlkj\n" ] ,
		'Line with only trailing space' => [ "as \n  \n"   , "as\n\n"    ] ,
	}

end

def test11RtrimLines(( input, expect ))

	assert_equal expect, input.rtrimLines

end



data do

	{
		'Empty string'                  => [ ""            , ""          ] ,
		'Simple usecase'                => [ " as\n lkj"   , "as\nlkj"   ] ,
		'Simple usecase with tab'       => [ " \tas\nlkj"  , "as\nlkj"   ] ,
		'End with newline'              => [ " as\nlkj\n"  , "as\nlkj\n" ] ,
		'Line with only trailing space' => [ " as\n  \n"   , "as\n\n"    ] ,
	}

end

def test12LtrimLines(( input, expect ))

	assert_equal expect, input.ltrimLines

end



data do

	{
		'Empty string'                  => [ ""             , ""          ] ,
		'Simple usecase'                => [ " as \n lkj"   , "as\nlkj"   ] ,
		'Simple usecase with tab'       => [ " \tas \nlkj"  , "as\nlkj"   ] ,
		'End with newline'              => [ " as \nlkj \n" , "as\nlkj\n" ] ,
		'Line with only trailing space' => [ " as \n  \n"   , "as\n\n"    ] ,
	}

end

def test13TrimLines(( input, expect ))

	assert_equal expect, input.trimLines

end



def test13RtrimLines!

	text = " as \n lkj"

	assert_same text, text.rtrimLines!

end



def test13LtrimLines!

	text = " as \n lkj"

	assert_same text, text.ltrimLines!

end



def test13TrimLines!

	text = " as \n lkj"

	assert_same text, text.trimLines!

end

end # class  TestString
end # module Refine
end # module Susu
