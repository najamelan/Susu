require          'pp'
require 'active_support/core_ext/hash/except'
require 'awesome_print'


module Susu
module Sys

class TestSys < Test::Unit::TestCase


@@user  = 'user'
@@group = 'user'
@@uid   = '1000'
@@gid   = '1000'

# This is the process thread id, but since we fork, this always changes
#
@@whitelist = [:tgid]

# This basically tells Sys to do nothing, so we can test each parameter independantly.
#
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

	unsetEnvStandard: false  ,
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

		result[ :before ] = Sys::info

		yield

		result[ :after  ] = Sys::info
		result[ :diff   ] = result[ :before ].diff result[ :after  ]
		result[ :rdiff  ] = result[ :after  ].diff result[ :before ]

	else

		result = Sys::info

	end


	result

end



# The behaviour of this is not as desired. Right now the unit test fix the behaviour
# rather than testing for desired behaviour. Ruby doesn't seem to support complete
# independant changing of uids. Maybe it's a system limitation, not a ruby one, but
# if these tests fail, check them well, cause it might be an improvement.
# eg. only euid now says that suid and fsuid also change...
#
def test_change_uid()

	# Structure:
	#
	# elem[ 0 ] = message
	# elem[ 1 ] = params for Sys.su merged with defaults that disable everything
	# elem[ 2 ] = which keys should have the new user id
	#
	data =
	[
			[
				  "Only euid"                                               \
				, { user: @@user, setEuid: true }                           \
				, [ :euid, :suid, :fsuid ]                                  \
			]                                                              \
                                                                        \
		,  [                                                              \
			    "Only ruid"                                                \
			  , { user: @@user, setRuid: true }                            \
			  , [ :ruid ]                                                  \
			]                                                              \
                                                                        \
		,  [                                                              \
			    "Only suid"                                                \
			  , { user: @@user, setSuid: true }                            \
			  , []                                                         \
			]                                                              \
                                                                        \

	]


	data.each do | arr |

		info = Sys.fork do

			userInfo { Sys.su( @@params.merge arr[ 1 ] ) }

		end


		arr[ 2 ].each do | key |

			assert_equal( @@uid        , info[ :after ][ key ], "\n\nTEST: #{arr.first}\n"                  )
			assert_equal( arr[ 2 ].size + @@whitelist.size, info[ :diff ].size, "\n\nTEST: #{arr.first} - length of diff\n" )

		end

	end

end



# The behaviour of this is not as desired. Right now the unit test fix the behaviour
# rather than testing for desired behaviour. Ruby doesn't seem to support complete
# independant changing of uids. Maybe it's a system limitation, not a ruby one, but
# if these tests fail, check them well, cause it might be an improvement.
# eg. only euid now says that suid and fsuid also change...
#
def test_change_gid()

	# Structure:
	#
	# elem[ 0 ] = message
	# elem[ 1 ] = params for Sys.su merged with defaults that disable everything
	# elem[ 2 ] = which keys should have the new user id
	#
	data =
	[
			[
				  "Only egid"                                               \
				, { user: @@user, setEgid: true }                           \
				, [ :egid, :sgid, :fsgid ]                                  \
			]                                                              \
                                                                        \
		,  [                                                              \
			    "Only rgid"                                                \
			  , { user: @@user, setRgid: true }                            \
			  , [ :rgid ]                                                  \
			]                                                              \
                                                                        \
		,  [                                                              \
			    "Only sgid"                                                \
			  , { user: @@user, setSgid: true }                            \
			  , []                                                         \
			]                                                              \
                                                                        \

	]


	data.each do | arr |

		info = Sys.fork do

			userInfo { Sys.su( @@params.merge arr[ 1 ] ) }

		end


		arr[ 2 ].each do | key |

			assert_equal( @@gid        , info[ :after ][ key ], "\n\nTEST: #{arr.first}\n"                  )
			assert_equal( arr[ 2 ].size + @@whitelist.size, info[ :diff ].size, "\n\nTEST: #{arr.first} - length of diff\n" )

		end

	end

end


end # class TestSys
end # module Sys
end # module Susu
