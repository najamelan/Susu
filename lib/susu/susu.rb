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
	#   Normally it always follows the effective ID. The saved ID in theory can by set with Process::Sys, but on the above mentioned system
	#   at least, it follows the effective ID as well, and setting it to anything else has no effect. I won't include feature of which it
	#   is unknown if they can work on any system, so for now saved and filesystem ID are not configurable.
	#
	#
	# supported arguments (all are named and optional)
	#
	# @param [string, integer] user                the new, valid user id or name
	# @param [bool]            set_effective_uid   which id to set to the new user
	# @param [bool]            set_real_uid        which id to set to the new user
	# @param [string, integer] group               a valid group name or id (defaults to the primary group of the user)
	# @param [bool]            set_effective_gid   which gid to set to the new group
	# @param [bool]            set_real_gid        which gid to set to the new group
	# @param [bool]            init_groups         set the suplementary groups to those of the target user
	# @param [array]           suplem_groups       additional valid group names or id's
	# @param [bool]            unsetenv_others     clear environment variables except specified by env or setenv_standard
	# @param [bool]            setenv_standard     will set the following env vars for the new user: $HOME, $USER, $PATH, $PWD
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
	def self.su                          \
	(                                    \
		  user:               nil         \
		, set_effective_uid:  true        \
		, set_real_uid:       true        \
                                        \
		, group:              nil         \
		, set_effective_gid:  true        \
		, set_real_gid:       true        \
                                        \
		, init_groups:        true        \
		, suplem_groups:      nil         \
                                        \
		, unsetenv_others:    true        \
		, setenv_standard:    true        \
		, env:                nil         \
                                        \
		, umask:              nil         \
	)

		# Find the user in the password database.
		#
		u = ( user.is_a? Integer ) ? Etc.getpwuid( user  ) : Etc.getpwnam( user  )
		# g = ( group.is_a? Integer ) ? Etc.getpwgid( group ) : Etc.getpwnam( group )
		#

		Process::initgroups( u.name, u.gid ) unless init_groups == false

		set_effective_gid and Process::GID.eid = u.gid
		# set_effective_gid and Process::Sys.setegid( u.gid )
		# set_real_gid      and Process::GID.rid u.gid
		# set_real_gid      and Process::Sys.setrgid( u.gid )
		unsetenv_others   and ENV.clear
		umask             and File::umask umask


		# This is a dirty hack. If you know a better way to obtain these environment vars, please send a pull request at github.com/najamelan
		#
		if setenv_standard

			env = `su --login --command printenv #{ user }`.split( "\n" )

			env.map do | line |

				                      arr             = line.split( '=', 2 )
				arr.length == 2  and  ENV[ arr[ 0 ] ] = arr[ 1 ]

			end

			ENV.keep_if { | key | key  =~ /^HOME=|^PWD=|^USER=|^PATH=/ }

		end


		env  and  env.map { | name, value | ENV[ name.to_s ] = value }




		# Now drop
		#
		set_effective_uid and Process::Sys.seteuid( u.gid )
		# set_real_uid      and Process::Sys.setruid( u.gid )

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
