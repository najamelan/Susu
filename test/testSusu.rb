require          'test/unit'
require          'pp'
require_relative '../lib/susu'
require 'active_support/core_ext/hash/except'
require 'awesome_print'


module TidBits
module Susu

class TestSusu < Test::Unit::TestCase


@@user  = 'user'
@@group = 'user'
@@uid   = 1000

@@params =
{
	          user:   nil  ,
	       setEuid: false  ,
	       setRuid: false  ,
	       setSuid: false  ,

	         group:   nil  ,
	       setEgid: false  ,
	       setRgid: false  ,
	       setSgid: false  ,

	    initGroups: false  ,
	  suplemGroups:   nil  ,

	unsetEnvOthers: false  ,
	setEnvStandard: false  ,
	           env:   nil  ,

	         umask:   nil
}





# Poll user info for this process
# We are testing ruby functions for correctness, so don't use any ruby functions to query the system.
# Exception umask, because it wouldn't run in backticks.
# We take everything directly out of /proc. This is no reference method. I'm no unix expert and I
# took the first thing I found.
#
def userInfo &block

	result = {}


	if block

		result[ :before ] = Susu::info

		yield

		result[ :after  ] = Susu::info
		result[ :diff   ] = result[ :before ].diff result[ :after ]
		result[ :rdiff  ] = result[ :after ].diff result[ :before ]

	else

		result = Susu::info

	end


	result

end






def test_change_uid()



	data =
	[
			[
				  "Only euid"                                               \
				, { user: @@user, group: @@group, setEuid: true }           \
				, :euid                                                     \
				, false                                                     \
			]                                                              \
                                                                        \
		# ,  [                                                              \
				  # "Same values, different keys"                             \
				# , { a: 1, b: 2 }                                            \
				# , { c: 1, d: 2 }                                            \
				# , false                                                     \
			# ]                                                              \
                                                                        \

	]


	data.each do | arr |

		pid = Process.fork do

			info = userInfo do

				Susu.su( @@params.merge arr[ 1 ] )

			end

			ap info.except :before, :after

		end

		Process.wait pid


		# control1 = arr[ 1 ].dup
		# control2 = arr[ 2 ].dup

		# result   = arr[ 1 ].superset? arr[ 2 ]
		# result2  = arr[ 2 ].subset?   arr[ 1 ]

		# assert_equal( control1, arr[ 1 ], "\n\nTEST: " + arr.first + "\n" )
		# assert_equal( control2, arr[ 2 ], "\n\nTEST: " + arr.first + "\n" )

		# assert_equal( arr[ 3 ], result  , "\n\nTEST: " + arr.first + "\n" )
		# assert_equal( arr[ 3 ], result2 , "\n\nTEST: " + arr.first + "\n" )

	end




end


end # class TestSusu
end # module Susu
end # module TidBits
