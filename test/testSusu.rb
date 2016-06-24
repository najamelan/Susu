require          'test/unit'
require          'pp'
require_relative '../lib/susu'

module TidBits
module Susu

class TestSusu < Test::Unit::TestCase


# Poll user info for this process
# We are testing ruby functions for correctness, so don't use any ruby functions to query the system.
# Exception umask, because it wouldn't run in backticks.
# We take everything directly out of /proc. This is no reference method. I'm no unix expert and I
# took the first thing I found.
#
def userInfo

	result = {}

	# the login uid
	#
	result[ :loginuid ] =  `cat /proc/$$/task/$$/loginuid`.to_i

	# Get the process user related information directly from the system
	#
	status = `cat /proc/$$/task/$$/status`

	# this will output something like: "Uid:	0	0	0	0"
	#
	uids = status[ /^Uid:.*/ ].scan( /\d+/ )
	gids = status[ /^Gid:.*/ ].scan( /\d+/ )

	result[ :ruid   ] = uids[ 0 ]  # the “owner” of the current process
	result[ :euid   ] = uids[ 1 ]  # the identity in effect
	result[ :suid   ] = uids[ 2 ]  # stores some previous user ID, so that it can be restored (copied to the euid) at some later time
	result[ :fsuid  ] = uids[ 3 ]  # create files with this credential

	result[ :rgid   ] = gids[ 0 ]
	result[ :egid   ] = gids[ 1 ]
	result[ :sgid   ] = gids[ 2 ]
	result[ :fsgid  ] = gids[ 3 ]

	result[ :tgid   ] = status[ /^Tgid:.*/   ].scan( /\d+/ ).first  # Thread group ID (i.e., Process ID)
	result[ :groups ] = status[ /^Groups:.*/ ].scan( /\d+/ )        # supplementary groups
	result[ :umask  ] = sprintf( "%03o", File.umask )               # create files with these privs


	# put some important environment variables
	# if child processes are supposed to run as a different user, they might rely
	# on $HOME, $USER, ...
	# other candidates not yet included MAIL, SUDO*
	#
	environment = `cat /proc/$$/task/$$/environ`.gsub( "\0", "\n" )

	result[ :USER            ] = environment[ /^USER=(.*)/            , 1 ]
	result[ :USERNAME        ] = environment[ /^USERNAME=(.*)/        , 1 ]
	result[ :LOGNAME         ] = environment[ /^LOGNAME=(.*)/         , 1 ]
	result[ :SUDO_USER       ] = environment[ /^SUDO_USER=(.*)/       , 1 ]
	result[ :HOME            ] = environment[ /^HOME=(.*)/            , 1 ]
	result[ :PWD             ] = environment[ /^PWD=(.*)/             , 1 ]
	result[ :PATH            ] = environment[ /^PATH=(.*)/            , 1 ]
	result[ :SHELL           ] = environment[ /^SHELL=(.*)/           , 1 ]
	result[ :XDG_RUNTIME_DIR ] = environment[ /^XDG_RUNTIME_DIR=(.*)/ , 1 ]

	return result

end


def test_one

	pp userInfo


	pid = Process.fork do

	      Susu.su( user: 'www-data' )

	      pp userInfo

	  end

	  Process.wait pid

end


end # class TestSusu
end # module Susu
end # module TidBits
