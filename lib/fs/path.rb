require 'pathname'


module TidBits
module Fs

class Path < Pathname


	# Runs Pathname.glob
	#
	# @param  pattern  The pattern will be created by doing self + pattern if
	#                  self.directory? otherwise, it will be self.dirname + pattern
	# @param  flags    The flags as in File::Constants, see Dir.glob
	# @param  block    The block will receive the pathname of each found path as parameter.
	#
	# @return nil
	#
	def glob( pattern, flags = 0, &block )

		p = self
		p.directory? or p = p.dirname

		Pathname.glob p + pattern, flags, &block

	end


	def path

		self

	end


	def relpath( from = caller_locations( 1 ).first.absolute_path )

		self.class.new File.join( File.dirname( from ), @path )

	end


	# Will make a path, creating intermediate directories as needed.
	#
	# @param  subPath  The sub path to create relative to the path of self.
	# @param  options  The options as take by FileUtils.mkpath (eg. mode, noop, verbose)
	#
	# @return A Path object to the new directory.
	#
	def mkpath( subPath = '', options = {} )

		require 'fileutils'

		FileUtils.mkpath( self.join( subPath ).to_path )

	end


	# Will create a directory
	#
	# @param  [Path|String] subPath  The sub path to create relative to the path of self.
	# @param  [FixNum]      mode     The permissions for the new directory.
	#
	# @return A Path object to the new directory.
	#
	def mkdir( subPath = '', mode = 0777 )

		Dir.mkdir( self.join( subPath ).to_path, mode )

		self.join( subPath )

	end


	# Secure recursive delete of path.
	# @see FileUtils.remove_entry_secure
	#
	def rm_secure( force = false )

	  require 'fileutils'

	  FileUtils.remove_entry_secure( @path, force )

	end



end # class  Pathname
end # module Fs
end # module TidBits
