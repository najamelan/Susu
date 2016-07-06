# Module Susu provides finegrained functionality for changing the credentials of the current process.
#
# Security is opt-out, so by default the most restrictive settings are used
#
#
# ## Installation
# This module is meant to be mixed into your own framework. It's not a gem, just make this git repository a
# submodule, or grab this file and check for updates before you release a new version of your package.
#
# For example I will mix this into my fork of rush, so rush users will be able to call Rush::su in order
# to change the privileges of the running process.
#
#  git submodule add https://github.com/najamelan/ruby-susu
#  git submodule init && git submodule update
#
# @example In you ruby code:
#   reqduire 'ruby-susu/susu'
#
#
# @example In your module:
#
#     module Rush
#
#         include Susu
#
#         ...
#
#     end
#
# ##Usage
#
# @example To run a block of code with different credentials, do:
#
#   pid = Process.fork do
#
#       Susu.su( user: 'alice' )
#
#       my_cool_code_here
#
#   end
#
#   Process.wait pid
#
module TidBits
module Susu

	# Change credentials of the current process on unix compatible systems
	#
	# The code was tested with debian jessie and ruby 2.0.0. The filesystem uid and gid seem not to be confibgurable with Process::Sys.
	# Normally it always follows the effective ID. The saved ID in theory can by set with Process::Sys, but on the above mentioned system
	# at least, it follows the effective ID as well, and setting it to anything else has no effect. I won't include features of which it
	# is unknown if they can work on all systems, so for now saved and filesystem ID are not configurable.
	#
	#
	# supported arguments (all are named and optional)
	#
	# @param [string, integer] user                the new, valid user id or name
	# @param [bool]            setEuid   whether to set the eid to the new user
	# @param [bool]            setRuid        whether to set the rid to the new user
	# @param [string, integer] group               a valid group name or id (defaults to the primary group of the user)
	# @param [bool]            setEgid   whether to set the egid to the new group
	# @param [bool]            setRgid        whether to set the rgid to the new group
	# @param [bool]            initGroups         set the suplementary groups to those of the target user
	# @param [array]           suplemGroups       additional valid group names or id's
	# @param [bool]            unsetEnvOthers     clear environment variables except specified by env or setEnvStandard
	# @param [bool]            setEnvStandard     will set the following env vars for the new user: $HOME, $USER, $PATH, $PWD
	# @param [int]             umask               umask for file creation
	# @param [hash]            env                 name => val : set the environment variable,
	#                                              name => nil : unset the environment variable
	#
	# @return [nil] nothing so far
	#
	# @raise [ArgumentError] if both user and group are nil or omitted.
	#
	# @todo check order of group/user. If going from normal to superuser, prob have to set user
	#   before setting groups
	# @todo verify that only setting real and effective does never leave saved or fs on the old value
	# @todo find a better way to set the standard environment variables. Right now requires `su` which might not be non-interactive
	#
	def self.su                  \
	(
		user:     nil             ,
		setEuid:  true            ,
		setRuid:  true            ,
		setSuid:  true            ,

		# group:    nil             ,
		setEgid:  true            ,
		setRgid:  true            ,
		setSgid:  true            ,

		initGroups:     true      ,
		suplemGroups:   nil       ,

		unsetEnvStandard: false   ,
		setEnvStandard:   true    ,

		unsetEnvOthers:   true    ,
		env:              nil     ,

		umask:            nil
	)
		# Find the user in the password database.
		#
		u = ( user .is_a? Integer ) ? Etc.getpwuid( user ) : Etc.getpwnam( user  )

		# TODO: what about setting the primary group? like sg
		# group ||= u.gid
		# g = ( group.is_a? Integer ) ? Etc.getpwgid( group ) : Etc.getpwnam( group )


		# Set the supplementary groups for the new user
		#
		initGroups and Process.initgroups( u.name, u.gid )


		# Change the GID (after dropping privileges, we won't be able anymore)
		#
		setRgid  and Process::Sys.setresgid( u.gid, -1, -1 )
		setEgid  and Process::Sys.setresgid( -1, u.gid, -1 )
		setSuid  and Process::Sys.setresgid( -1, -1, u.gid )


		unsetEnvStandard and ENV.delete_if { | key | key  =~ /^HOME|^PWD|^USER|^PATH/ }
		unsetEnvOthers   and ENV.keep_if   { | key | key  =~ /^HOME|^PWD|^USER|^PATH/ }

		umask            and File.umask umask


		# This is a dirty hack. If you know a better way to obtain these environment vars, please send a pull request at github.com/najamelan
		#
		if setEnvStandard

			env = `su --login --command printenv #{ user }`.split( "\n" )

			env.map do | line |

											 arr              = line.split( '=', 2 )
				arr.length == 2  and  ENV[ arr.first ] = arr.last

			end

			ENV.keep_if { | key, value | key  =~ /^HOME|^PWD|^USER|^PATH/ }

		end


		env  and  env.map { | name, value | ENV[ name.to_s ] = value }


		# Now drop
		#
		setRuid  and Process::Sys.setresuid( u.uid, -1, -1 )
		setEuid  and Process::Sys.setresuid( -1, u.uid, -1 )
		setSuid  and Process::Sys.setresuid( -1, -1, u.uid )

	end


	# Allows you to fork into a different process with a block like Kernel.fork, but returns
	# the return value of the block to the current process!
	#
	# @see https://stackoverflow.com/questions/1076257/returning-data-from-forked-processes
	#
	def self.fork( &blk )

		read, write = IO.pipe
		read .binmode
		write.binmode


		pid = Process.fork do

			read.close

			result = Marshal.dump( yield )

			write.puts [result].pack( "m" )
			exit!

		end


		write.close
		result = read.read
		Process.wait(pid)

		Marshal.load(result.unpack( "m" )[ 0 ] )

	end


	def self.info

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
		# We don't have rights to do this after dropping privileges, so it don't work unless we are root
		#
		# environment = `cat /proc/$$/task/$$/environ`.gsub( "\0", "\n" )
		environment = `env`

		result[ :USER            ] = environment[ /^USER=(.*)/            , 1 ]
		result[ :USERNAME        ] = environment[ /^USERNAME=(.*)/        , 1 ]
		result[ :LOGNAME         ] = environment[ /^LOGNAME=(.*)/         , 1 ]
		result[ :SUDO_USER       ] = environment[ /^SUDO_USER=(.*)/       , 1 ]
		result[ :HOME            ] = environment[ /^HOME=(.*)/            , 1 ]
		result[ :PWD             ] = environment[ /^PWD=(.*)/             , 1 ]
		result[ :PATH            ] = environment[ /^PATH=(.*)/            , 1 ]
		result[ :SHELL           ] = environment[ /^SHELL=(.*)/           , 1 ]
		result[ :XDG_RUNTIME_DIR ] = environment[ /^XDG_RUNTIME_DIR=(.*)/ , 1 ]

		result

	end


	protected

	def su_validateEnv( user, options )


	end


	def su_validateGroup( user, options )


	end


	def su_validateUser( user, options )


	end


	def su_validateSupplemGroups( user, options )


	end


	# umask must be Integer and 0 <= umask <= 0777
	#
	def su_validateUmask( user, options )


		if umask.integer? && umask.between?( 0, 0777 )

			return true

		end

		return false

	end

end # module Susu
end # module TidBits
